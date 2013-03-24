class Receiver
  constructor: (@faye, @channel, @abilities=[]) ->
    self = this
    @ABILITYLIST = ['recvmessage', 'recvcommand', 'recvquestion', 'recvchat']
    @faye.subscribe @channel, (data) ->
      self.execute(data.content)
  
  addablility: (ability) ->
    if ability in @ABILITYLIST and !(ability in @abilities)
      @abilities.push(ability)
      return true
    else
      return false
  
  removeability: (ability) ->
    @abilities = _.without(@abilities, ability)
    return true

  execute: (message) ->
    console.log ('received'+message)
    controller = message.controller
    command = message.command
    type = message.type
    ext = message.ext
    
    if type in @abilities
      switch controller
        when 'slide'
          controller = new SlideController
          controller.execute(command)
        when 'messagebox'
          controller = new MessageBoxController
          controller.execute(command)
        when 'receiver'
          controller = new ReceiverDomController
          controller.execute(command)
        when 'question'
          controller =  new QuestionController
          controller.execute(command, ext)
        when 'chat'
          controller = new ChatController
          controller.execute(command, ext)
        else
          return

window.Receiver = Receiver
