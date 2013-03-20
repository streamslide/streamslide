$(document).ready ()->
  $("#player-container img").css('user-drag', 'none').css('-moz-user-select','none').css('-webkit-user-drag','none')

  currentpage = 1

  noteHandler = new NoteHandler('#notesarea')
  noteHandler.getNotes(slideid, currentpage)

  $(".next").click (e) ->
    noteHandler.saveNotes()
    if currentpage < totalPage
      currentpage++
      noteHandler.getNotes(slideid, currentpage)

  $(".prev").click (e) ->
    noteHandler.saveNotes()
    if currentpage > 1
      currentpage--
      noteHandler.getNotes(slideid, currentpage)
