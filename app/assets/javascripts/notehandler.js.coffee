#=====================================================
# NoteHandler
#=====================================================
class NoteHandler
  constructor: (@notearea) ->
    @router = new Launchvn.Routers.NotesRouter()

    $("#{@notearea}").mousedown (e) =>
      @mousedown(e)
    $("#{@notearea}").mousemove (e) =>
      @mousemove(e)
    $("#{@notearea}").mouseup (e) =>
      @mouseup(e)

  mousedown: (e) ->
    if($(e.target).hasClass('note-content') || $(e.target).hasClass('note') || $(e.target).hasClass('note-icon'))
      return
    @mouseFlag = true
    @locationOnMouseDown = {x: e.pageX - $("#{@notearea}").offset().left, y: e.pageY - $("#{@notearea}").offset().top}
    console.log "mouse down: x = #{@locationOnMouseDown.x}, y = #{@locationOnMouseDown.y}"

  mousemove: (e) ->
    if !@mouseFlag
      return
    w = e.pageX - $("#{@notearea}").offset().left - @locationOnMouseDown.x
    h = e.pageY - $("#{@notearea}").offset().top - @locationOnMouseDown.y
    if @newNoteCreated
      @router.updateTopNote(w,h)
    else
      @router.createNewNote(@slideid, @pagenum, @locationOnMouseDown.y, @locationOnMouseDown.x)
      @newNoteCreated = true

  mouseup: (e) ->
    @mouseFlag = false
    if @newNoteCreated
      @newNoteCreated = false
      @router.changeTopNoteStatus(1)
    console.log "mouse up"

  getNotes: (slideid, pagenum) ->
    @slideid = slideid
    @pagenum = pagenum
    @router.index(slideid, pagenum)

window.NoteHandler = NoteHandler
