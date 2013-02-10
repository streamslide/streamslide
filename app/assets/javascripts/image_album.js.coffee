window.ImageAlbum = (images) ->
  this.images_loaded = (false for i in [0..images.length])

  klass = this

  klass.load_image = (index) ->
    unless klass.is_loaded(index)
      image = new Image
      image.onload = ->
        klass.images_loaded[index] = true
        console.log "loaded image " + images[index]
      image.src = images[index]

  klass.pre_load = (num) ->
    for i in [0..num]
      klass.load_image(i)

  klass.is_loaded = (index) ->
    klass.images_loaded[index]

  klass
