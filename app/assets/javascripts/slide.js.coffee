$(document).ready ()->
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
        if publisher?
          publisher.publish 'slide', 'left'
          $.post '/streamsessions/set_page',
            from: 'host'
            page: player.currentPage
            (data) ->

      when 39 # right key
        player.next()
        if publisher?
          publisher.publish 'slide', 'right'
          $.post '/streamsessions/set_page',
            from: 'host'
            page: player.currentPage
            (data) ->
  
  $('#start-session').click ->
    slug_name = $("#slug-name").html()
    callback = (response) ->
      alert "subscribing!"
      window.channel = response.channel
      publisher = new Publisher(event_server, response.channel)
      window.publisher = publisher #export
      $showurl = $("#stream-url-name")
      $showurl.find("input").attr("value", response.url)
      $showurl.show()

    $.get '/streamsessions/generate', {slug_name: slug_name, page: player.currentPage}, callback, 'json'

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
