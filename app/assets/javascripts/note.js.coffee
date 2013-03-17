$(document).ready ()->
  $("#player-container img").css('user-drag', 'none').css('-moz-user-select','none').css('-webkit-user-drag','none')
  noteListView = new NoteListView(el: '#player-container')
