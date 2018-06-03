function startListening(params = invalid)
  m.top.functionName = "runRecognizer"
  m.top.control = "RUN"
end function

sub runRecognizer()
  mic = createObject("roMicrophone")

  ' If can't record, there's no point on continuing
  if not mic.CanRecord()
    ? "Can't use microphone. Check that you're using a valid remote and that microphone usage is allowed."
    ' Developer must handle error here.
    return
  end if

  ' Set port to listen for microphone events https://sdkdocs.roku.com/display/sdkdoc/roMicrophoneEvent
  port = CreateObject("roMessagePort")
  mic.SetMessagePort(port)

  ' Start recording audio.
  ' When initiating recording for the first time within the app,
  ' the OS will display a popup asking the user for permission.
  mic.StartRecording()

  ' Create buffer that will contain all the captured audio data bytes
  buffer = CreateObject("roByteArray")

  ' Start loop to begin capturing the audio recording events
  while true
    ' Capture microphone event
    event = wait(0, port)
    if event.IsRecordingInfo() ' The user is holding the OK button
      info = event.GetInfo()
      buffer.append(info.sample_data)
    else ' The user released the OK button
      exit while
    end if
  end while

  if buffer.count()
    ' The audio content must be a base64-encoded string representing the audio data bytes
    audioContent = buffer.ToBase64String()
    body = buildRequestBody(audioContent)
    headers = {
      "X-Goog-Api-Key": kAPIKey()
      "Content-Type": "application/json; charset=utf-8"
    }
    response = makePostRequest(kAPIUrl(), body, headers)

    ' Access transcript. Developer must handle error here.
    results = response.results
    transcript = ""
    for each result in results
      for each alternative in result.alternatives
        transcript += alternative.transcript
      end for
    end for
    m.top.delegate.callFunc("speechRecognizerDidReceiveTranscript", transcript)
  else
    ' Developer must handle error here.
  end if
end sub

function buildRequestBody(audioContent as String) as String
  bodyObject = {
    "audio": {
      "content": audioContent
    },
    "config": {
      ' Only available using the beta API: https://cloud.google.com/speech-to-text/docs/reference/rest/v1p1beta1/RecognitionConfig
      "enableAutomaticPunctuation": true,
      ' See allowed encoding types here: https://cloud.google.com/speech-to-text/docs/reference/rest/v1/RecognitionConfig#AudioEncoding'
      "encoding": "LINEAR16",
      ' See supported languages here: https://cloud.google.com/speech-to-text/docs/languages
      "languageCode": "en-US",
      ' See allowed rates here: https://cloud.google.com/speech-to-text/docs/reference/rest/v1/RecognitionConfig
      "sampleRateHertz": 16000
    }
  }

  body = FormatJson(bodyObject)
  return body
end function

' Just a function that makes a POST request
function makePostRequest(url as String, body as String, headers as Object) as Object
  request = CreateObject("roUrlTransfer")
  request.setCertificatesFile("common:/certs/ca-bundle.crt")
  request.initClientCertificates()

  port = CreateObject("roMessagePort")
  request.setPort(port)
  request.setUrl(url)
  request.setHeaders(headers)
  request.RetainBodyOnError(true)

  timeout = 20000
  request.asyncPostFromString(body)
  event = wait(timeout, port)

  response = event.getString()
  ?"ResponseCode "event.getResponseCode()
  ?"Response "response
  responseObject = ParseJson(response)
  return responseObject
end function

function kAPIUrl() as String
  ' Production API: https://cloud.google.com/speech-to-text/docs/reference/rest/v1/speech/recognize
  ' Uncomment to use production API. `enableAutomaticPunctuation` will not work.
  ' return "https://speech.googleapis.com/v1/speech:recognize"

  ' Beta API: https://cloud.google.com/speech-to-text/docs/reference/rest/v1p1beta1/speech/recognize
  return "https://speech.googleapis.com/v1p1beta1/speech:recognize"
end function

function kAPIKey() as String
  return YOUR_API_KEY
end function
