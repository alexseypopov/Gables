window.MobileApp =
  toggle: (element) ->
    if element.style.display is 'block'
    then element.style.display = 'none'
    else element.style.display = 'block'


  addClass: (element, value) ->
    if not element.className
    then element.className = value
    else
      newClassName = element.className
      newClassName+= " "
      newClassName+= value
      element.className = newClassName

  addGestures: (element) ->
    startPosition = 0
    delta = 0

    singleTouch = (fn, preventDefault) ->
      (e) ->
        if (preventDefault)
        then e.preventDefault()
        e.touches.length is 1 && fn(e.touches[0].pageX)


    touchstart = singleTouch (position) ->
      startPosition = position
      delta = 0


    touchmove = singleTouch (position) ->
      delta = position - startPosition
    , true

    touchend = () ->

      if (Math.abs(delta) < 50)
      then return

      if delta > 0
      then deck.prev()
      else deck.next()

    element.addEventListener('touchstart', touchstart);
    element.addEventListener('touchmove', touchmove);
    element.addEventListener('touchend', touchend);