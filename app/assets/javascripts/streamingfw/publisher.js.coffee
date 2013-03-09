class Publisher
  constructor: (@servername, @channel, @state = null) ->
    console.log 'publisher created'
    @STATEOPTIONS = ON: 'on', STOP: 'stop', OFF: 'off'
    @faye = new Faye.Client(@servername)
    @faye.subscribe @channel, (data) ->
      console.log('received data')

  turnon: () ->
    @state = @STATEOPTIONS.ON
    this.publish('receiver', 'on')

  turnstop: () ->
    @state = @STATEOPTIONS.ON
    this.publish('receiver', 'stop')
    @state = @STATEOPTIONS.STOP

  turnoff: () ->
    @state = @STATEOPTIONS.ON
    this.publish('receiver', 'off')
    @state = @STATEOPTIONS.OFF

  publish: (controller, command) ->
    if @state == @STATEOPTIONS.ON
      message = this.makemessage(controller, command)
      publication = @faye.publish(@channel, message)
      success = ()->
        console.log('publish success')
      error = (e)->
        console.log('publish error' + e)

      publication.callback success
      publication.errback error
    return true
  
  makemessage: (controller, command) ->
    data = controller: controller, command: command
    message =
      'text': data
      'ext': {'auth_token' : 'anything'}
    return message

window.Publisher = Publisher #export
