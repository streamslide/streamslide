class ReceiverDomController
  execute: (command) ->
    switch command
      when 'on'
        this.synchronize_with_host()
        $("#streaming-gif").show()
        $("#pause-gif").hide()
        $("#offline-gif").hide()
      when 'stop'
        $("#streaming-gif").hide()
        $("#pause-gif").show()
        $("#offline-gif").hide()
      when 'off'
        $("#streaming-gif").hide()
        $("#pause-gif").hide()
        $("#offline-gif").show()
        if window.receiver?
          window.receiver = null
  
  synchronize_with_host: () ->
    loaded = false

    tryLoadingImg = (page) ->
      if page?
        idx = parseInt(page)
        player.loadImage(idx)
        if player.isImgloaded(idx)
          player.gotoPage(idx)
          loaded = true

    callback = (response) ->
      window.gotopage_loop = setInterval =>
        if (loaded)
          clearInterval(gotopage_loop)
        else
          tryLoadingImg(response.page)
        true
      , 1000
      true
    
    $.get 'streamsessions/get_page', {}, callback, 'json'

window.ReceiverDomController = ReceiverDomController
