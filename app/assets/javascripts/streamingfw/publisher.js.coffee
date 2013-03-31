class Publisher
  constructor: (@faye, @channel, @identifier, @token=null, @state = null, @abilities=[])  ->
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
    through = message.through

    if @state == @STATEOPTIONS.ON and (type in @abilities)
      message = this.makemessage(message)

      if through == 'faye'
        publication = @faye.publish(@channel, message)
        success = ()->
          console.log('publish success')
        error = (e)->
          console.log('publish error' + e)

        publication.callback success
        publication.errback error
      else if through == 'rails'
        $.post '/fayemessages/auth_publish',
          'data': message
          'channel' : @channel
          (data) ->
            console.log 'publish success'

    return true
  
  makemessage: (origin_mes) ->
    controller = origin_mes.controller
    command = origin_mes.command
    type = origin_mes.type
    ext = origin_mes.ext
 
    MAPPER = 'pubcommand':'recvcommand', 'pubmessage':'recvmessage', 'pubquestion':'recvquestion','pubchat':'recvchat'

    data = controller: controller, command: command, type: MAPPER[type]
    if ext?
      data.ext = ext

    message =
      'content': data
      'identifier': @identifier
      'token' : @token
    return message

window.Publisher = Publisher #export
