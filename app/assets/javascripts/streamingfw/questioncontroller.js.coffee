class QuestionController
  execute: (command, ext) ->
    switch command
      when 'add'
        el =  "<div class='questioncell'>"+\
                "<p class='questioncontent'>"+ext.messagecontent+"</p>"+\
                "<div class='votecell'>"+\
                  "<div class='vote-up'></div>"+\
                  "<div class='vote-down'></div>"+\
                "</div>"+\
              "</div>"
        $('#questions-list').append(el)
      
window.QuestionController = QuestionController

