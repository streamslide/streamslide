class Launchvn.Models.Question extends Backbone.Model
  constructor: ->

  

class Launchvn.Collections.QuestionCollection extends Backbone.Collection
  model: Launchvn.Models.Question
  url: ""

  update: ->
    for m in @models
      m.sync("update", m,
        success: ->
          console.log "ok"
        error: ->
          console.log "error"
      )
