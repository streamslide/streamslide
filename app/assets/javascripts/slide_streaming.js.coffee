$(document).ready ()->
  player = new SlidePlayer(slidePrefixUrl, totalPage)
  player.preload()
  window.player = player #there is only one player instance
  
  $(".prev").click (e) ->
    player.prev()

  $(".next").click (e) ->
    player.next()


  event_server = $("#event-server").html()
  channel_name = $("#channel-name").html()
  receiver = new Receiver(event_server, channel_name)
  loaded = false

  tryLoadingImg = (page) ->
    if page?
      idx = parseInt(page)
      player.loadImage(idx)
      if player.isImgloaded(idx)
        player.gotoPage(idx)
        loaded = true

  callback = (response) ->
    window.gotopage_loop = setInterval =>
      if (loaded)
        clearInterval(gotopage_loop)
      else
        tryLoadingImg(response.page)
      true
    , 1000
    true
  
  $.get 'streamsessions/get_page', {}, callback, 'json'

  true
