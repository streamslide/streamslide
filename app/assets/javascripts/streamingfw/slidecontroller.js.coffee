class SlideController
  execute: (command) ->
    switch command
      when 'prev'
        if window.player?
          window.player.prev()
      when 'next'
          window.player.next()

window.SlideController = SlideController
