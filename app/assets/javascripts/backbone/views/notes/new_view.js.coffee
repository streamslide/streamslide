Launchvn.Views.Notes ||= {}

class Launchvn.Views.Notes.NewView extends Backbone.View
  template: JST["backbone/templates/notes/new"]

  events:
    "submit #new-note": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (note) =>
        @model = note
        window.location.hash = "/#{@model.id}"

      error: (note, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
