$(document).ready ()->
  $("#player-container img").css('user-drag', 'none').css('-moz-user-select','none').css('-webkit-user-drag','none')

  noteHandler = new NoteHandler('#notes-area')
  noteHandler.getNotes(2, 1)

  #$(".next").click (e) ->
  #  notehandler.syncNotes(2, 1)
  #  notehandler.getNotes(2,2)
