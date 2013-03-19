class Launchvn.Models.Note extends Backbone.Model
  paramRoot: 'note'

  defaults:
    slide_id: 0
    pagenum: 0
    top: 0
    left: 0
    width: 10
    height: 10
    status: 2     #0: creating, 1: editting, 2: icon
    content: ""

class Launchvn.Collections.NotesCollection extends Backbone.Collection
  model: Launchvn.Models.Note
  url: "/notes"

  update: ->
    for m in @models
      m.sync("update", m,
        success: ->
          console.log "ok"
        error: ->
          console.log "error"
      )
