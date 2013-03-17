//= require jquery.ui.draggable
//= require jquery.ui.resizable

jQuery ->

#=====================================================
# NoteModel
#=====================================================
  class NoteModel extends Backbone.Model
    defaults:
      top: 0
      left: 0
      width: 10
      height: 10
      status: 0     #0: creating, 1: editting, 2: icon
      content: ""

    url: ->
      '/notes'
#=====================================================
# NoteList : Collection
#=====================================================
  class NoteList extends Backbone.Collection
    model: NoteModel

#=====================================================
# NoteView
#=====================================================
  class NoteView extends Backbone.View
    tagName: 'div'
    className: 'note-draggable note'
    attributes: {position: 'absolute'}

    initialize: ->
      _.bindAll @
      @model.bind 'add', @render
      @model.bind 'change', @update
      @model.bind 'remove', @unrender

    render: =>
      @rerender()

    update: =>
      if @model.hasChanged('status')
        console.log "status has changed to : "+@model.get 'status'
        if @model.previous('status') != 0
          @rerender()
      else
        $(@el).css({top: "#{@model.get('top')}px", left: "#{@model.get('left')}px", width: "#{@model.get('width')}px", height: "#{@model.get('height')}px"})

    rerender: ->
      if @model.get('status') == 2
        text = $(@el).find('textarea').val()
        @model.set({'content': text}, {silent: true})
        $(@el).css({top: "#{@model.get('top')}px", left: "#{@model.get('left')}px", width: "50px", height: "50px", background: 'transparent'})
        $(@el).html """
          <img class="note-icon" src="/assets/note-icon.png">
        """
        @
      else
         $(@el).css({top: "#{@model.get('top')}px", left: "#{@model.get('left')}px", width: "#{@model.get('width')}px", height: "#{@model.get('height')}px", "background-color": "rgba(255, 255, 0, 0.5)"})
         $(@el).html """
          <img class="note-delete-btn" src="/assets/note-delete.png">
          <textarea class="note-content" placeholder="new note..."></textarea>
        """
        $(@el).find('textarea').val(@model.get('content'))
        @

    unrender: =>
      $(@el).remove()

    events:
      'click .note-delete-btn': 'remove'
      'dblclick': 'changestatus'

    remove: ->
      @model.destroy()

    changestatus: (e) ->
      console.log "Click me"
      switch @model.get('status')
        when 1 then @model.set(status: 2)
        when 2 then @model.set(status: 1)

#=====================================================
# NoteListView Class
#=====================================================
  class NoteListView extends Backbone.View

    initialize: ->
      _.bindAll @
      @collection = new NoteList
      @collection.bind 'add', @appendNote
      @counter = 0

    addNote: ->
      @counter++
      newnote = new NoteModel(top: @locationOnMouseDown.y, left: @locationOnMouseDown.x)
      @collection.add newnote

    appendNote: (note) ->
      noteview = new NoteView(model: note, id: "note-#{@counter}")
      $(@el).append noteview.render().el

    events:
      'mousedown': 'mousedown'
      'mousemove': 'mousemove'
      'mouseup': 'mouseup'

    mousedown: (e) ->
      if($(e.target).hasClass('note-content') || $(e.target).hasClass('note') || $(e.target).hasClass('note-icon'))
        return
      @mouseFlag = true
      @locationOnMouseDown = {x: e.pageX - $(@el).offset().left, y: e.pageY - $(@el).offset().top}
      console.log "mouse down"

    mousemove: (e) ->
      if !@mouseFlag
        return
      w = e.pageX - $(@el).offset().left - @locationOnMouseDown.x
      h = e.pageY - $(@el).offset().top - @locationOnMouseDown.y
      if @newNoteCreated
        @collection.at(@collection.length-1).set({width: w, height: h})
      else
        @addNote()
        @newNoteCreated = true

    mouseup: (e) ->
      @mouseFlag = false
      if @newNoteCreated
        @newNoteCreated = false
        @collection.at(@collection.length-1).set(status: 1)
      console.log "mouse up"

    reset: ->
      @collection.remove(@collection.models)

    getNotes: ->
      @collection.url = '/notes'
      @collection.fetch()

  Backbone.sync = (method, model, success, error) ->
   switch(method)
     when 'create' then console.log "Create"
     when 'read' then console.log "Read"

#=====================================================
# NoteHandler
#=====================================================
  class NoteHandler
    constructor: (notearea) ->
      @noteListView = new NoteListView(el: notearea)

    getNotes: (slide_id, pagenum) ->
      @noteListView.reset()
      console.log "Get Notes"
      @noteListView.getNotes()

    syncNotes: (slide_id, pagenum) ->
      console.log "Sync notes: slide_id = #{slide_id}, pagenum = #{pagenum}"


  #window.NoteHandler = NoteHandler
