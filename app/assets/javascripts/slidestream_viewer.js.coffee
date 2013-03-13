$(document).ready ()->
  player = new SlidePlayer(slidePrefixUrl, totalPage)
  player.preload()
  window.player = player #there is only one player instance
  $("#streaming-gif").show()
  $("#pause-gif").hide()
  $("#offline-gif").hide()
  
  recvdomctl = new ReceiverDomController()
  recvdomctl.synchronize_with_host()

  event_server = $("#event-server").html()
  channel_name = $("#channel-name").html()
  faye = new Faye.Client(event_server)
  window.receiver = new Receiver(faye, channel_name)
  window.receiver.addablility('recvcommand')
  window.publisher = new Publisher(faye, channel_name)
  window.publisher.turnon()
  window.publisher.addablility('pubquestion')

  $("#to-speaker-send").click ->
    $form = $(this).closest("#to-speaker-form")
    text = $form.find("#to-speaker-message").val()
    mes = controller: 'getquestion', command: 'addtodom', type: 'pubquestion', ext: {messagecontent: text}

    window.publisher.publish mes
  true
