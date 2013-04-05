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
  slug = $("meta[name=session_slug]").attr("content")
  host = $("meta[name=session_host]").attr("content")

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
    mes = controller: 'chat', command: 'add', type: 'pubchat', through: 'rails', ext: {messagecontent: text, host: host, slug: slug}
    window.publisher.publish mes

  $("#btn-asking").click ->
    $form = $(this).closest("#asking-wrap")
    text = $form.find("#input-asking").val()
    mes = controller: 'question', command: 'add', type: 'pubquestion', through: 'rails', ext: {messagecontent: text, host: host, slug: slug}
    window.publisher.publish mes

  $(".voteup").live 'click', () ->
      $cell = $(this).closest('.questioncell')
      id = $cell.attr("id")
      mes = controller: 'question', command:'voteup', type: 'pubquestion', through: 'rails', ext:{host: host, slug: slug, qid: id}
      window.publisher.publish mes

  $(".votedown").live 'click', () ->
      $cell = $(this).closest('.questioncell')
      id = $cell.attr("id")
      mes = controller: 'question', command:'votedown', type: 'pubquestion', through: 'rails', ext:{host: host, slug: slug, qid: id}
      window.publisher.publish mes

  true
