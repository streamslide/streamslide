$(document).ready ()->
  player = new SlidePlayer(slidePrefixUrl, totalPage)
  player.preload()
  window.player = player #there is only one player instance
  $("#streaming-gif").show()
  $("#pause-gif").hide()
  $("#offline-gif").hide()
  
  recvdomctl = new ReceiverDomController()
  recvdomctl.synchronize_with_host()

  event_server = $("meta[name=session_event_server]").attr("content")
  channel_name = $("meta[name=session_channel]").attr("content")
  session_token = $("meta[name=session_token]").attr("content")

  alert(event_server)
  alert(channel_name)
  alert(session_token)

  faye = new Faye.Client(event_server)

  window.receiver = new Receiver(faye, channel_name)
  window.receiver.addablility('recvcommand')
  window.receiver.addablility('recvquestion')
  window.receiver.addablility('recvchat')


  window.publisher = new Publisher(faye, channel_name, 'client', session_token)
  window.publisher.turnon()
  window.publisher.addablility('pubquestion')
  window.publisher.addablility('pubchat')
  
  $("#chat-btn").click ->
    $form = $(this).closest("#input-chat-area")
    text = $form.find("#input-chat").val()
    mes = controller: 'chat', command: 'add', type: 'pubchat', through: 'rails', ext: {messagecontent: text}
    window.publisher.publish mes

  $("#btn-asking").click ->
    $form = $(this).closest("#asking-wrap")
    text = $form.find("#input-asking").val()
    mes = controller: 'question', command: 'add', type: 'pubquestion', through: 'rails', ext: {messagecontent: text}
    window.publisher.publish mes
  true
