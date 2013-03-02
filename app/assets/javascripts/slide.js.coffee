# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#= require image_album
$(document).ready ()->
  class SlidePlayer
    constructor: (@slidePrefixUrl, @totalPage) ->
      @currentPage = 1
      @currentSlide = $("#current-slide")
      @progress = $(".player-progress")

    gotoPage: (index) ->
      if index > 1 and index < @totalPage
        percent = Math.round(index  * 100 / @totalPage)
        @progress.css("width", "#{percent}%")
        @currentPage = index
        @currentSlide.attr("src", "#{@slidePrefixUrl}/slide_#{index}.jpg")

    prev: () ->
      @gotoPage(@currentPage - 1)

    next: () ->
      @gotoPage(@currentPage + 1)

  player = new SlidePlayer(slidePrefixUrl, totalPage)
  player.gotoPage(1)

  $(".prev").click (e) ->
    player.prev()

  $(".next").click (e) ->
    player.next()
