sub init()
  m.top.backgroundURI = ""
  m.top.backgroundColor = "#282a31"

  m.infoLb = m.top.createChild("Label")
  m.infoLb.width = 1920
  m.infoLb.translation = [0, 100]
  m.infoLb.font.size = 40
  m.infoLb.horizAlign = "center"
  m.infoLb.vertAlign = "top"
  m.infoLb.text = "Hold the OK button to start dictation, relase it once you're done."
  m.infoLb.opacity = 0.8

  m.label = m.top.createChild("Label")
  m.label.width = 1800
  m.label.height = 900
  m.label.wrap = true
  m.label.translation = [1920/2 - m.label.width/2, 1080/2 - m.label.height/2]
  m.label.font.size = 60
  m.label.horizAlign = "center"
  m.label.vertAlign = "center"
  m.label.color = "#00B16A"
end sub
