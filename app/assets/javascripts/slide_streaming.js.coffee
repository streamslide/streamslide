$(document).ready ()->
  player = new SlidePlayer(slidePrefixUrl, totalPage)
  player.preload()
  window.player = player #there is only one player instance
  $("#streaming-gif").show()
  $("#pause-gif").hide()
  $("#offline-gif").hide()
  
  recvdomctl = new ReceiverDomController()
  recvdomctl.synchronize_with_host()

  $(".prev").click (e) ->
    player.prev()

  $(".next").click (e) ->
    player.next()


  event_server = $("#event-server").html()
  channel_name = $("#channel-name").html()
  receiver = new Receiver(event_server, channel_name)
  
  true
