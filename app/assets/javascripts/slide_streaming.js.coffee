$(document).ready ()->
  event_server = $("#event-server").html()
  channel_name = $("#channel-name").html()
  receiver = new Receiver(event_server, channel_name)
