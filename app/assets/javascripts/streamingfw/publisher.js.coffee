class Publisher
  constructor: (@faye, @channel, @state = null, @abilities=[]) ->
    console.log 'publisher created'
    @STATEOPTIONS = ON: 'on', STOP: 'stop', OFF: 'off'
    @ABILITYLIST = ['pubmessage', 'pubcommand', 'pubquestion', 'pubchat']
    @faye.subscribe @channel, (data) ->

    @state = @STATEOPTIONS.OFF
  
  addablility: (ability) ->
    if ability in @ABILITYLIST and !(ability in @abilities)
      @abilities.push(ability)
      return true
    else
      return false
  
  removeability: (ability) ->
    @abilities = _.without(@abilities, ability)
    return true

  turnon: () ->
    @state = @STATEOPTIONS.ON
    mes = controller: 'receiver', command: 'on', type: 'pubcommand'
    this.publish(mes)

  turnstop: () ->
    @state = @STATEOPTIONS.ON
    mes = controller: 'receiver', command: 'stop', type: 'pubcommand'
    this.publish(mes)
    @state = @STATEOPTIONS.STOP

  turnoff: () ->
    @state = @STATEOPTIONS.ON
    mes = controller: 'receiver', command: 'off', type: 'pubcommand'
    this.publish(mes)
    @state = @STATEOPTIONS.OFF

  publish: (message) ->
    type = message.type
    controller = message.controller
    command = message.command
    ext = message.ext

    if @state == @STATEOPTIONS.ON and (type in @abilities)
      message = this.makemessage(controller, command, type, ext)
      publication = @faye.publish(@channel, message)
      success = ()->
        console.log('publish success')
      error = (e)->
        console.log('publish error' + e)

      publication.callback success
      publication.errback error
    return true
  
  makemessage: (controller, command, type, ext) ->
    MAPPER = 'pubcommand':'recvcommand', 'pubmessage':'recvmessage', 'pubquestion':'recvquestion','pubchat':'recvchat'

    data = controller: controller, command: command, type: MAPPER[type]
    if ext?
      data.ext = ext

    message =
      'content': data
      'ext': {'token' : 'anything'}
    return message

window.Publisher = Publisher #export
