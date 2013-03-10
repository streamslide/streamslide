class NoteHandler
  constructor: (@notearea) ->
    @currentNoteIndex = 0

  startTracking: ->
    $("#{@notearea}").mousedown (e) =>
      @mousedown(e)
    $("#{@notearea}").mousemove (e) =>
      @mousemove(e)
    $("#{@notearea}").mouseup (e) =>
      @mouseup(e)

  createNote: (w, h) ->
    console.log "Add new note"
    newNoteIndex = @currentNoteIndex++

    #template = require("views/notes/note")
    #editingElement = template(newNoteId)

    editingElement = '<div id="note-' + newNoteIndex + '" class="note-draggable note" style="position: absolute;">' +
                       '<img class="note-delete-btn" src="/assets/note-delete.png">' +
                       '<textarea class="note-content" placeholder="new note..."></textarea>' +
                    '</div>'

    @currentNote = $(editingElement)
    @currentNote.css("top","#{@newNoteTop}px")
    @currentNote.css("left", "#{@newNoteLeft}px")
    @currentNote.css("width", "#{w}px !important")
    @currentNote.css("height", "#{h}px !important")

    @currentNote.appendTo("#{@notearea}")

    # enable drag
    @currentNote.draggable ->
      containment: "#{@notearea}"
      stop (e, ui) ->
        console.log "stop dragging"

    @currentNote.find('textarea').bind 'blur', (e) =>
      @disableEditing(newNoteIndex)

    @currentNote.find('.note-delete-btn').bind 'click', (e) =>
      @deleteNote(newNoteIndex)

  updateNoteSize: (w, h) ->
    @currentNote.css({width: "#{w}px", height: "#{h}px"})

  enableEditing: (noteIndex) ->
    n = @getNote(noteIndex)
    notecontent = n.find('p').text()
    n.find('p').replaceWith('<textarea class="note-content" placeholder="new note...">' + notecontent + '</textarea>')
    n.find('textarea').bind 'blur', (e) =>
      @disableEditing(noteIndex)
    console.log notecontent

  disableEditing: (noteIndex) ->
    console.log "disable note: " + noteIndex
    n = @getNote(noteIndex)
    notecontent = n.find('textarea').val()
    console.log notecontent
    p = $("<p class='note-content'>#{notecontent}</p>")
    p.bind 'dblclick', (e) =>
      @enableEditing(noteIndex)
    n.find('textarea').replaceWith(p)

  getNote: (noteIndex) ->
    $("#{@notearea}").find("#note-"+noteIndex)

  deleteNote: (noteIndex) ->
    console.log "Delete note" + noteIndex
    @getNote(noteIndex).remove()

  mousedown: (e) ->
    if ($(e.target).hasClass('note-content'))
      return
    @mouseFlag = true
    @newNoteTop = e.pageY - $("#{@notearea}").offset().top
    @newNoteLeft = e.pageX - $("#{@notearea}").offset().left
    console.log "top = #{@newNoteTop}, left=#{@newNoteLeft}"

  mousemove: (e) ->
    if !@mouseFlag
      return
    w = e.pageX - $("#{@notearea}").offset().left - @newNoteLeft
    h = e.pageY - $("#{@notearea}").offset().top - @newNoteTop
    console.log "mouse dragging: W = #{w}, H = #{h}"
    if w > 10
      if @newNoteCreated
        @updateNoteSize(w,h)
      else
        @createNote(w, h)
        @newNoteCreated = true

  mouseup: (e) ->
    @mouseFlag = false
    @newNoteCreated = false
    console.log "mouseup"

window.NoteHandler = NoteHandler
