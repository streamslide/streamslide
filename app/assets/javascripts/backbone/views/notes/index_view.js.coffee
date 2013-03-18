Launchvn.Views.Notes ||= {}

class Launchvn.Views.Notes.IndexView extends Backbone.View
  id: "notes-collection"

  initialize: () ->
    @options.notes.bind('reset', @addAll)

  addAll: () =>
    @options.notes.each(@addOne)

  addOne: (note) =>
    view = new Launchvn.Views.Notes.NoteView({model : note})
    $(@el).append(view.render().el)

  render: =>
    @addAll()
    return this
