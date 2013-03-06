jQuery ->
  pagecount = 0
  currentpage = 1

  $(".slide-preview").mouseover ->
    console.log "MOUSEOVER"
    pagecount = (Number) $(this).parent().attr 'slide-page-count'
    loaded =  (Number) $(this).parent().attr 'loaded-page-count'
    $(this).find(".preview-progress-container").css('visibility', 'visible')

    if loaded != pagecount
      console.log "Append img"
      thumburl = $(this).find('img').attr 'src'

      # add thumb nail
      for num in [2..pagecount]
        newurl = thumburl.substring(0, thumburl.length-5) + num + '.jpg'
        $(this).append '<img alt="Thumb_' + num + '" src="'+ newurl + '" style="visibility:hidden;"' + 'class="page-thumbnail '+ num + '">'
      $(this).parent().attr('loaded-page-count', pagecount)

  $(".slide-preview").mousemove (e) ->
    pn = Math.round(pagecount*(e.pageX - $(this).offset().left)/$(this).width())
    if pn != currentpage && pn > 0
      $(this).find('.'+currentpage).css('visibility', 'hidden')
      $(this).find('.'+pn).css('visibility', 'visible')
      currentpage = pn
      $(this).find(".preview-progress").css('width', 100*currentpage/pagecount+'%')
      console.log currentpage

  $(".slide-preview").mouseout ->
    console.log("Mouser out")
    #$(this).find(".preview-progress-container").css('visibility', 'hidden')
    #$(this).find(".preview-progress").css('width', (100/pagecount)+'%')
