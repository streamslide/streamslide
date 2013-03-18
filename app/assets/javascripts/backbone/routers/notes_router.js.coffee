class Launchvn.Routers.NotesRouter extends Backbone.Router
  initialize: ->
    @notes = new Launchvn.Collections.NotesCollection()

  routes:
    "new"      : "newNote"
    "index"    : "index"
    ".*"        : "index"

  newNote: ->
    console.log "Router: new"
    @view = new Launchvn.Views.Notes.NewView(collection: @notes)
    $("#notes").html(@view.render().el)

  index: (slideid, pagenum) ->
    console.log "Router: index"
    @notes.slideid = slideid
    @notes.pagenum = pagenum

    @notes.fetch
      data:
        s: slideid
        p: pagenum
      success: (collection, response, options)->
        console.log "Fetch: success"
        @notes = collection
        for n in @notes.models
          n.set(status: 2)
        @view = new Launchvn.Views.Notes.IndexView(notes: @notes)
        $("#notes-area").html(@view.render().el)
      error: ->
        console.log "Fetch: error"

  createNewNote: (slideid, pagenum, t, l) ->
    console.log "Router: Create new note"
    @newNote = new Launchvn.Models.Note(slide_id: slideid, pagenum: pagenum, top: t, left: l, status: 0)
    @notes.add @newNote
    @newNoteView = new Launchvn.Views.Notes.NoteView({model: @newNote})
    #$("#notes-collection").append(@newNoteView.rerender().el)
    $("#notes-area").append(@newNoteView.rerender().el)

    @newNote.save(@newNote.attributes,{
      success: ->
        console.log "Save success"
      error: ->
        console.log "Save error"
      })

  updateTopNote:(w, h) ->
    console.log "Router: update top note"
    @newNote.set({width: w, height: h})
    @newNoteView.rerender()

  changeTopNoteStatus: (s) ->
    @newNote.set(status: s)
