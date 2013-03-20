Launchvn.Views.Notes ||= {}

class Launchvn.Views.Notes.IndexView extends Backbone.View
  id: "notes-collection"
  #el: 'notesarea'

  initialize: () ->
    @collection.bind 'add', @appendNote
    @collection.bind 'reset', @reset
    @collection.bind 'remove', @remove
    @collection.bind 'sync', @sync

  reset: () =>
    console.log "reset"
    $("#notesarea").html(@render().el)

  remove: () =>
    console.log "remove"

  sync: () =>
    console.log "sync"

  #==========================

  appendNote: (note) =>
    console.log "ADD"
    noteview = new Launchvn.Views.Notes.NoteView({model: note})
    $(@el).append noteview.render().el

  addAll: () =>
    @collection.each(@appendNote)

  render: =>
    @addAll()
    return this
