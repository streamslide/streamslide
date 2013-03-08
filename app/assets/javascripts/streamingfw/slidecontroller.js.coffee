class SlideController
  execute: (command) ->
    press  = $.Event("keypress")
    switch command
      when 'left'
        press.which = 37
        $('.prev').click()
        $('body').trigger(press)
      when 'right'
        press.which = 39
        $('.next').click()
        $('body').trigger(press)

window.SlideController = SlideController
