class QuestionController
  execute: (command, ext) ->
    switch command
      when 'add'
        el =  "<div class='questioncell' id='"+ext.qid+"'>"+\
                "<p class='questioncontent'>"+ext.messagecontent+"</p>"+\
                "<div class='votecell'>"+\
                  "<a href='javascript:void(0);' class='voteup'></a>"+\
                  "<a href='javascript:void(0);' class='votedown'></a>"+\
                "</div>"+\
              "</div>"
        $('#questions-list').append(el)
      
window.QuestionController = QuestionController

