class QuestionController
  execute: (command, ext) ->
    switch command
      when 'add'
        el = "<p><img src=''>"+\
                ext.messagecontent+\
              "</p>"
        $('#questions-list').append(el)
      
window.QuestionController = QuestionController

