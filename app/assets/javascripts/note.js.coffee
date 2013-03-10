//= require jquery.ui.draggable

$(document).ready ()->
  $("#player-container img").css('user-drag', 'none').css('-moz-user-select','none').css('-webkit-user-drag','none')
  noteHandler = new NoteHandler('#player-container')
  noteHandler.startTracking()
