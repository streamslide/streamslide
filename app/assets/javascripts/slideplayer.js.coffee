class SlidePlayer
  PRELOAD_IMAGE_COUNT = 10

  constructor: (@slidePrefixUrl, @totalPage) ->
    @currentPage = 1
    @currentSlide = $("#current-slide")
    @progress = $(".player-progress")
    @images_loaded = (false for i in [0..@totalPage])

  loadImage: (index) ->
    if index > @totalPage
      return
    unless @images_loaded[index]
      klass = this
      image = new Image
      image.onload = ->
        klass.images_loaded[index] = true
      image.src = "#{@slidePrefixUrl}/slide_#{index}.jpg"

  preload: ->
    for i in [1..PRELOAD_IMAGE_COUNT]
      @loadImage(i)

  gotoPage: (index) ->
    if index >= 1 and index <= @totalPage
      if @images_loaded[index]
        percent = Math.round(index  * 100 / @totalPage)
        @progress.css("width", "#{percent}%")
        @currentPage = index
        @currentSlide.attr("src", "#{@slidePrefixUrl}/slide_#{index}.jpg")
        for i in [1..index + PRELOAD_IMAGE_COUNT]
          @loadImage(i)
  
  isImgloaded: (index) ->
    if @images_loaded?
      return @images_loaded[index]
    return false

  prev: () ->
    @gotoPage(@currentPage - 1)
    if window.publisher?
      mes = controller: 'slide', command: 'prev', type: 'pubcommand'
      window.publisher.publish mes
      $.post '/streamsessions/set_page',
        from: 'host'
        page: this.currentPage
        (data) ->

  next: () ->
    @gotoPage(@currentPage + 1)
    if window.publisher?
      mes = controller: 'slide', command: 'next', type: 'pubcommand'
      window.publisher.publish mes
      $.post '/streamsessions/set_page',
        from: 'host'
        page: this.currentPage
        (data) ->

window.SlidePlayer = SlidePlayer
