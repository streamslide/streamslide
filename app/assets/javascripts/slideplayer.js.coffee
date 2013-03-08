class SlidePlayer
  PRELOAD_IMAGE_COUNT = 10

  constructor: (@slidePrefixUrl, @totalPage) ->
    @currentPage = 1
    @currentSlide = $("#current-slide")
    @progress = $(".player-progress")
    @images_loaded = (false for i in [0..@totalPage])

  loadImage: (index) ->
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
        for i in [index + 1..index + PRELOAD_IMAGE_COUNT]
          @loadImage(i)
  
  loadedImg: (index) ->
    if @images_loaded?
      return @images_loaded[index]
    return false

  prev: () ->
    @gotoPage(@currentPage - 1)

  next: () ->
    @gotoPage(@currentPage + 1)

window.SlidePlayer = SlidePlayer
  
