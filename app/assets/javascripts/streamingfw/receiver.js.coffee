class Receiver
  constructor: (@servername, @channel) ->
    self = this
    @faye = new Faye.Client(@servername)
    @faye.subscribe @channel, (data) ->
      self.execute(data.text)

  execute: (message) ->
    console.log ('received'+message)
    switch message.controller
      when 'slide'
        controller = new SlideController
        controller.execute(message.command)
      when 'messagebox'
        controller = new MessageBoxController
        controller.execute(message.command)
      when 'receiver'
        controller = new ReceiverDomController
        controller.execute(message.command)

      else
        return

window.Receiver = Receiver
