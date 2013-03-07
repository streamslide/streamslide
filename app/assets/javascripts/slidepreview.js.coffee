jQuery ->
  pagecount = 0
  currentpage = 1

  gotopage = (preview, pagenum) ->
    if currentpage == pagenum || pagenum < 1
      return
    $(preview).find('.'+currentpage).hide()
    $(preview).find('.'+pagenum).show()
    currentpage = pagenum
    $(preview).find(".preview-progress").css('width', 100*currentpage/pagecount+'%')

  $(".slide-preview").mouseenter ->
    pagecount = (Number) $(this).parent().attr 'slide-page-count'
    loaded =  (Number) $(this).parent().attr 'loaded-page-count'
    $(this).find(".preview-progress-container").css('visibility', 'visible')

    if loaded != pagecount
      thumburl = $(this).find('img').attr 'src'
      for num in [2..pagecount]
        newurl = thumburl.substring(0, thumburl.length-5) + num + '.jpg'
        $(this).append '<img alt="Thumb_' + num + '" src="'+ newurl + '" style="display:none;"' + 'class="page-thumbnail '+ num + '">'
      $(this).parent().attr('loaded-page-count', pagecount)

  $(".slide-preview").mousemove (e) ->
    pn = Math.round(pagecount*(e.pageX - $(this).offset().left)/$(this).width())
    gotopage(this, pn)

  $(".slide-preview").mouseleave (e) ->
    gotopage(this, 1)
    $(this).find(".preview-progress-container").css('visibility', 'hidden')
