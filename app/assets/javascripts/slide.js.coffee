$(document).ready ()->
  clip = new ZeroClipboard document.getElementById("zeroclipbtn"), { moviePath: "/ZeroClipboard/ZeroClipboard.swf" }
  clip.on "load", (client) ->

  clip.on "complete", (client, args)->
    alert("yanked")

  clip.glue document.getElementById("zeroclipbtn")

  player = new SlidePlayer(slidePrefixUrl, totalPage)
  player.preload()
  window.player = player #there is only one player instance
  
  $(".prev").click (e) ->
    player.prev()

  $(".next").click (e) ->
    player.next()

  event_server = $("#event-server").html()

  $(document).keydown (e) ->
    switch e.keyCode
      when 37 # left key
        player.prev()

      when 39 # right key
        player.next()
        
  
  $('#start-session').click ->
    slug_name = $("#slug-name").html()
    callback = (response) ->
      $('#streaming-gif').show()
      $('#pause-gif').hide()

      window.channel = response.channel
      if window.publisher?
        window.publisher = null
      faye = new Faye.Client(event_server)
      window.publisher = new Publisher(faye, response.channel)
      window.publisher.turnon()
      window.publisher.addablility('pubcommand')

      window.receiver = new Receiver(faye, response.channel)
      window.receiver.addablility('recvquestion')

      $showurl = $("#stream-url-name")
      $showurl.find("input").attr("value", response.url)
      $showurl.show()
      $("#zeroclipbtn").attr "data-clipboard-text", response.url

    $.get '/streamsessions/generate', {slug_name: slug_name, page: player.currentPage}, callback, 'json'

  $('#stop-session').click ->
    window.publisher.turnstop()
    $('#streaming-gif').hide()
    $('#pause-gif').show()


  $('#delete-session').click ->
    window.publisher.turnoff()
    if window.publisher?
      window.publisher = null
      $('#streaming-gif').hide()
      $('#pause-gif').hide()
      $showurl = $("#stream-url-name")
      $showurl.hide()

  $('#resume-session').click ->
    window.publisher.turnon()
    $('#streaming-gif').show()
    $('#pause-gif').hide()

  launchFullscreen = (element) ->
    if element.requestFullScreen
      element.requestFullScreen()
    else if element.mozRequestFullScreen
      element.mozRequestFullScreen()
    else if element.webkitRequestFullScreen
      element.webkitRequestFullScreen()


  $("#fullscreen-btn").click (e) ->
    launchFullscreen($("#current-slide")[0])
  
  return true
