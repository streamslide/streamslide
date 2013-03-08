class Publisher
  constructor: (@servername, @channel) ->
    console.log 'publisher created'
    @faye = new Faye.Client(@servername)
    @faye.subscribe @channel, (data) ->
      console.log('received data')

  publish: (controller, command) ->
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
