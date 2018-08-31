
# Speech Recognition Demo on Roku using Google STT API

This demo app showcases how to implement Speech Recognition on Roku OS 7.6 and above using Google Cloud Speech-to-Text API. Follow this step-by-step [tutorial](https://medium.com/float-left-insights/speech-recognition-on-roku-using-google-cloud-speech-to-text-api-ac79bb944986) for more details.

## How to enable the STT API
As with any Google Cloud API, the API has to be enabled on a project within the Google Cloud Console and all the API calls will be associated to that project.

### Summarized steps:
1. Create a project (or use an existing one) in the [Cloud Console](https://console.cloud.google.com/).  
2. Make sure that [billing](https://console.cloud.google.com/billing?project=_) is enabled for your project.  
3. Enable the [Speech-to-Text API](https://console.cloud.google.com/apis/api/speech.googleapis.com/overview?project=_).  
4. Create an [API key](https://console.cloud.google.com/apis/credentials?project=_).

## Running the app
1.  Clone this repo 
	```
	$ git clone https://github.com/acotilla91/Google-STT-Roku-Demo.git
	```
2.  Open project.
3.  Go to the `SpeechRecognizer` component and replace `YOUR_API_KEY` with the actual API key that was obtained from the steps above.
4.  Side-load the app.
5. Press and hold the "OK" button to start dictation, release it once you're done.
6. The spoken words should be displayed shortly after the "OK" button is released.
