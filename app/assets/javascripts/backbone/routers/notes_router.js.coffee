class Launchvn.Routers.NotesRouter extends Backbone.Router
  initialize: ->
    @notes = new Launchvn.Collections.NotesCollection()
    @indexview = new Launchvn.Views.Notes.IndexView({collection: @notes})
    #$("#notesarea").html(@indexview.render().el)

  routes:
    "new"      : "newNote"
    "index"    : "index"
    ".*"        : "index"

  index: (slideid, pagenum) ->
    console.log "Router: index"
    @notes.fetch
      data:
        s: slideid
        p: pagenum
      success: ->
        console.log "Fetch: success"
      error: ->
        console.log "Fetch: error"

  createNewNote: (slideid, pagenum, t, l) ->
    console.log "Router: Create new note" + @notes.length
    @newNote = new Launchvn.Models.Note(slide_id: slideid, pagenum: pagenum, top: t, left: l, status: 0)
    @notes.add @newNote

    @newNote.save(@newNote.attributes, {
      success: ->
        console.log "Save success"
      error: ->
        console.log "Save error"
      })

  updateTopNote:(w, h) ->
    @newNote.set({width: w, height: h})

  changeTopNoteStatus: (s) ->
    @newNote.set(status: s)

  saveNotes: ->
    @notes.update()
