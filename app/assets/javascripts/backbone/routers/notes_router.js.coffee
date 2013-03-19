class Launchvn.Routers.NotesRouter extends Backbone.Router
  initialize: ->
    @notes = new Launchvn.Collections.NotesCollection()
    @indexview = new Launchvn.Views.Notes.IndexView({notes: @notes})

  routes:
    "new"      : "newNote"
    "index"    : "index"
    ".*"        : "index"

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
          n.set({status: 2}, {silent: true})
        @indexview = new Launchvn.Views.Notes.IndexView({notes: @notes})
        $("#notesarea").html(@indexview.render().el)
      error: ->
        console.log "Fetch: error"

  createNewNote: (slideid, pagenum, t, l) ->
    console.log "Router: Create new note"
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
