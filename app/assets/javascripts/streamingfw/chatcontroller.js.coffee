class ChatController
  execute: (command, ext) ->
    switch command
      when 'add'
        el = "<p><img src=''>"+\
                ext.messagecontent+\
              "</p>"
        $('#message-area').append(el)
      
window.ChatController = ChatController

