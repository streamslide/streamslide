Launchvn.Views.Notes ||= {}

class Launchvn.Views.Notes.NoteView extends Backbone.View
  tagName: 'div'
  className: 'note-draggable note'
  attributes: {position: 'absolute'}
  template: JST["backbone/templates/notes/note"]
  icontemplate: JST["backbone/templates/notes/note_icon"]

  initialize: ->
    #_.bindAll(this, 'added')
    @model.bind 'change', @update
    @model.bind 'add', @added

  events:
    'click .note-delete-btn' : 'destroy'
    'dblclick': 'changestatus'

  added: =>
    alert 'Hello'
    console.log "NoteView: added"

  changestatus: (e) ->
    console.log "changestatue: currentStatus = " + @model.get 'status'
    switch @model.get('status')
      when 1 then @model.set(status: 2)
      when 2 then @model.set(status: 1)
    @rerender()

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  render: ->
    $(@el).css({top: "#{@model.get('top')}px", left: "#{@model.get('left')}px", width: "50px", height: "50px", background: 'transparent'})
    @$el.html(@icontemplate(@model.toJSON() ))
    return this

  update: =>
    if @model.hasChanged('status')
      console.log "update: current status = "+@model.get 'status'

  rerender: ->
    if @model.get('status') == 2
      text = $(@el).find('textarea').val()
      @model.set({'content': text}, {silent: true})
      $(@el).css({top: "#{@model.get('top')}px", left: "#{@model.get('left')}px", width: "50px", height: "50px", background: 'transparent'})
      @$el.html(@icontemplate(@model.toJSON() ))
    else
      $(@el).css({top: "#{@model.get('top')}px", left: "#{@model.get('left')}px", width: "#{@model.get('width')}px", height: "#{@model.get('height')}px", "background-color": "rgba(255, 255, 0, 0.5)"})
      @$el.html(@template(@model.toJSON() ))

      return this
