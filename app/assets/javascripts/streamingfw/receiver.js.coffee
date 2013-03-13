class Receiver
  constructor: (@faye, @channel, @abilities=[]) ->
    self = this
    @ABILITYLIST = ['recvmessage', 'recvcommand', 'recvquestion']
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
        when 'getquestion'
          question = ext.messagecontent
          alert(question)
        else
          return

window.Receiver = Receiver
