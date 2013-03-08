$(document).ready ()->
  event_server = $("#event-server").html()
  channel_name = $("#channel-name").html()
  receiver = new Receiver(event_server, channel_name)

  callback = (response) ->
    if player?
      clearInterval(window.getpage_loop)
      tryLoadingImg = () ->
        if response.page?
          idx = parseInt(response.page)
          if player.loadedImg(idx)
              clearInterval(window.gotopage_loop)
              player.gotoPage(idx)

      window.gotopage_loop = setInterval =>
        tryLoadingImg()
      , 1000
  
  window.getpage_loop = setInterval =>
    $.get 'streamsessions/get_page', {}, callback, 'json'
    , 1000
    true

  true
