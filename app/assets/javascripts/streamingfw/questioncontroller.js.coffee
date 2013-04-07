class QuestionController
  execute: (command, ext) ->
    switch command
      when 'add'
        el =  "<div class='questioncell' id='"+ext.qid+"' point=0>"+\
                "<p class='questioncontent'>"+ext.messagecontent+"</p>"+\
                "<div class='votecell'>"+\
                  "<a href='javascript:void(0);' class='voteup'></a>"+\
                  "<div class='votenum'>0</div>"+\
                  "<a href='javascript:void(0);' class='votedown'></a>"+\
                "</div>"+\
              "</div>"
        $('#questionslist').append(el)

      when 'voteup', 'votedown'
        votenum = JSON.parse(ext.votenum)
        qid = parseInt(ext.qid)
        diff = parseInt(votenum.up) + parseInt(votenum.down)
        cell = "#"+qid+".questioncell"
        $(cell).find(".votenum").html(diff)
        $(cell).attr("point", diff)
        this.reoreder()
        
  reoreder: ()->
    list = $('#questionslist')
    listItems = list.find('.questioncell').sort (a,b) ->
      $(b).attr('point') - $(a).attr('point')
    list.find('.questioncell').remove()
    list.hide()
    list.append(listItems)
    list.fadeIn('slow')

window.QuestionController = QuestionController

