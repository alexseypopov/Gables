class MobileApp.Swipe
  element =
  width = 0
  slides =
  width =
  length =
  slidePos = 0

  options = @options || {}
#  options.continuous = if options.continuous not undefined then options.continuous else true
  slideIndex = parseInt(options.startSlide, 10) or 0
  speed = 300
  delay = options.auto || 0

  noop = ->

  offloadFn = (fn) ->
    setTimeout(fn || @noop, 0)

  constructor: (@elements, @options) ->
    @init() if @elements

  init: () ->
    element = @elements.children[0]
    slides = element.children
    length = slides.length
    if (slides.length < 2)
    then options.continuous = false

    if Modernizr.csstransitions and slides.length < 3
    then element.appendChild(slides[0].cloneNode(true)) and
    element.appendChild(element.children[1].cloneNode(true)) slides = element.children

    slidePos = new Array(slides.length)

    width = @elements.getBoundingClientRect().width || @elements.offsetWidth

    element.style.width = (slides.length * width) + 'px'

    pos = slides.length

    while(pos--)

      slide = slides[pos]
      slide.style.width = (width) + 'px'
      slide.setAttribute 'data-index', pos
      if Modernizr.csstransitions
      then slide.style.left = (pos * -width) + 'px' and
      @move(pos, @getValue(slideIndex, pos, width), 0)

    if Modernizr.csstransitions
    then @move(@circle(slideIndex-1), -width, 0) and
    @move(@circle(slideIndex+1), width, 0)

    @elements.style.visibility = 'visible'
    @attachEvents() if Modernizr.touch

  attachEvents: ->
    element.addEventListener('touchstart', events, false)

  getValue: (slideIndex, pos, width) ->
    if slideIndex > pos
    then (-width)
    else (if slideIndex < pos then width else 0)

  move: (index, dist, speed) ->

    @translate(index, dist, 300)
    slidePos[index] = dist

  translate: (index, dist, speed) ->
    console.log index, dist, speed
    slide = slides[index]
    style = slide and slide.style

    if not style then return

    style.webkitTransitionDuration =
      style.MozTransitionDuration =
        style.msTransitionDuration =
          style.OTransitionDuration =
            style.transitionDuration = speed + 'ms'

    style.webkitTransform = 'translate(' + dist + 'px,0)' + 'translateZ(0)'
    style.msTransform =
      style.MozTransform =
        style.OTransform = 'translateX(' + dist + 'px)'
    return

  slide: (to, slideSpeed) ->
    console.log slideIndex, to
    if slideIndex is to then return

    if Modernizr.csstransitions
    then @setDirection(to, slideSpeed)
    else @resetSwiper(to, slideSpeed)

    slideIndex = to
#    offloadFn(options.callback && options.callback(index, slides[index]));

  resetSwiper: (to, slideSpeed) ->
    @animate(slideIndex * -width, to * -width, slideSpeed || @speed)

  setDirection: (to, slideSpeed) ->
    direction = Math.abs(slideIndex - to) / (slideIndex - to)
    diff = Math.abs(slideIndex - to) - 1
    while(diff--)
      @move(@circle((if to > slideIndex then to else slideIndex) - diff - 1) , @width * direction, 0)

    to = @circle(to)

    @move(slideIndex, width * direction, slideSpeed || @speed)
    @move(to, 0, slideSpeed || @speed)
    return

  animate: (from, to, speed) ->
    element.style.left = to +'px' if not speed

    start = +new Date
    timer = setInterval () ->
      timeElap = +new Date - start
      if timeElap > speed
      then element.style.left = to + 'px' and
        if delay then begin()
      clearInterval(timer)

      element.style.left = (( (to - from) * (Math.floor((timeElap / speed) * 100) / 100) ) + from) + 'px'
    , 4

  circle: () ->
    (slides.length + (slideIndex % slides.length)) % slides.length

  next: () ->
    @slide(slideIndex+1) if slideIndex < slides.length - 1

  prev: () ->
    @slide(slideIndex-1)

  start = {}
  delta = {}
  isScrolling =
  events =
    handleEvent: (event) ->
      switch
        when 'touchstart' then this.start(event)
        when 'touchmove' then this.move(event)
        when 'touchend' then offloadFn(this.end(event))
        when 'webkitTransitionEnd' then ''
        when 'msTransitionEnd' then ''
        when 'oTransitionEnd' then ''
        when 'oTransitionEnd' then ''
        when 'transitionend' then offloadFn(@.transitionEnd(event))
        else

    start: (event) ->
      touches = event.touches[0]
      start =
        x: touches.pageX if touches
        y: touches.pageY if touches
        time: +new Date
      isScrolling = undefined
      delta = {}

      element.addEventListener 'touchmove', this, false
      element.addEventListener 'touchend', this, false
      return
    move: (event) ->
      console.log event
      if event.touches.length > 1 or event.scale and event.scale not 1
      then return

      touches = event.touches[0]
      delta =
        x: (touches.pageX - start.x) if touches
        x: (touches.pageY - start.y) if touches

      if typeof isScrolling is undefined
      then isScrolling = !!(isScrolling or Math.abs(delta.x)<Math.abs(delta.y))

      delta.x = delta.x / ( if (!slideIndex and delta.x > 0 || slideIndex is slides.length - 1 && delta.x < 0 ) then ( Math.abs(delta.x) / width + 1 ) else 1 )
      console.log 'boo in move'
      @translate(slideIndex-1, delta.x + slidePos[slideIndex-1], 0)
      @translate(slideIndex, delta.x + slidePos[slideIndex], 0)
      @translate(slideIndex+1, delta.x + slidePos[slideIndex+1], 0)
      return

    end: () ->
    transitionEnd: () ->