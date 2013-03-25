class ChatController
  execute: (command, ext) ->
    switch command
      when 'add'
        el = "<div>\
                <div id='chat-avatar'>\
                  <img src='"+ext.avatar+"' style='width:30px; height:30px;'>\
                </div>"+\
                "<p>"+ext.messagecontent+"</p>"+\
              "</div>"
        $('#message-area').append(el)
      
window.ChatController = ChatController

