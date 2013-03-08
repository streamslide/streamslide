$(document).ready ()->
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

    prev: () ->
      @gotoPage(@currentPage - 1)

    next: () ->
      @gotoPage(@currentPage + 1)

  player = new SlidePlayer(slidePrefixUrl, totalPage)
  player.preload()

  $(".prev").click (e) ->
    player.prev()

  $(".next").click (e) ->
    player.next()

  event_server = $("#event-server").html()

  $(document).keydown (e) ->
    switch e.keyCode
      when 37 # left key
        player.prev()
        publisher.publish 'slide', 'left' if publisher?
      when 39 # right key
        player.next()
        publisher.publish 'slide', 'right' if publisher?
  
  $('#start-session').click ->
    slug_name = $("#slug-name").html()
    callback = (response) ->
      alert "subscribing!"
      window.channel = response.channel
      publisher = new Publisher(event_server, response.channel)
      window.publisher = publisher #export
      $showurl = $("#stream-url-name")
      $showurl.find("input").attr("value", response.url)
      $showurl.show()

    $.get '/streamsessions/generate', {slug_name}, callback, 'json'

  launchFullscreen = (element) ->
    if element.requestFullScreen
      element.requestFullScreen()
    else if element.mozRequestFullScreen
      element.mozRequestFullScreen()
    else if element.webkitRequestFullScreen
      element.webkitRequestFullScreen()


  $("#fullscreen-btn").click (e) ->
    launchFullscreen($("#current-slide")[0])
  
  return true
