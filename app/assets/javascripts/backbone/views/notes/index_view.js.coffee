Launchvn.Views.Notes ||= {}

class Launchvn.Views.Notes.IndexView extends Backbone.View
  id: "notes-collection"
  #el: 'notesarea'

  initialize: () ->
    @options.notes.bind 'add', @appendNote
    @options.notes.bind 'reset', @addAll

  appendNote: (note) =>
    noteview = new Launchvn.Views.Notes.NoteView({model: note})
    $(@el).append noteview.render().el

  addAll: () =>
    @options.notes.each(@appendNote)

  render: =>
    @addAll()
    return this
