# modernizr.js (http://modernizr.com/docs/)
# domReady.js (https://github.com/ded/domready)
# radio.js (http://radio.uxder.com/documentation.html)

class MobileApp.Slide

  @TRANSITION = "all 0.2s ease-out"
  @CACHE      = {}

  constructor: (slide) ->

    @element = slide

    console.log @element.getBoundingClientRect().width
    styles = window.getComputedStyle(@element, null)
    console.log styles

#    @element.style.position = 'absolute'
#    @element.style.top = 0
#    @element.style.left = 0

    @focus   = false
    @current  = false


  isCurrent: -> @current

  isFocused: -> @focus

  focus: ->

  unFocus: ->

  enableTransition: ->
    @element.style[Modernizr.prefixed('transition')] = Slide.TRANSITION
    this

  disableTransition: ->
    @element.style[Modernizr.prefixed('transition')] = ""
    this

  # Note: We use 3D transforms when possible to support hardware
  # acceleration in webkit.
  translate: (xPos) ->
    if Modernizr.csstransforms3d
      @element.style[Modernizr.prefixed('transform')] = "translate3d(#{xPos}px, 0, 0)"
    else if Modernizr.csstransforms
      @element.style[Modernizr.prefixed('transform')] = "translate(#{xPos}px, 0)"
    this


class MobileApp.Slider

  @DIRECTION_CHANGE   = "PageSlideDirectionChangeEvent"
  @DIRECTION_FINISHED = "PageSlideDirectionChangeFinished"
  @DIRECTION_UNKNOWN  = 0
  @DIRECTION_LEFT     = 1
  @DIRECTION_RIGHT    = 2

  constructor: (@container, @params={}) ->

    if @container.length
    then @styleManyContainers()
    else @styleOneContainer()

#    @container.setAttribute('style', 'relative')
#
#    container = @container.querySelectorAll('.container')


#    console.log @container
#    @styleContainer()
#    container.setAttribute('style', params.containerHeight + 'px')
#    @touchTarget  = params['touchTarget'] || document.body
#
#    if Modernizr.touch and @slide? and @touchTarget?
#      @touchTarget.addEventListener("touchstart",   ((event) => @touchStart(event)),  false)
#      @touchTarget.addEventListener("touchmove",    ((event) => @touchMove(event)),   false)
#      @touchTarget.addEventListener("touchend",     ((event) => @touchEnd(event)),    false)
#      @touchTarget.addEventListener("touchcancel",  ((event) => @touchCancel(event)), false)



  styleManyContainers: ->
    for item, i in @container
#      item.setAttribute('style', 'position:relative')
#      item.setAttribute('style', "height:" + @params.containerHeight + "px")
#      item.setAttribute('style', 'border: 1px solid blue;')
      item.style.position = 'relative'
      item.style.height = @params.containerHeight + "px"
      item.style.border = '1px solid blue'
      divs = item.querySelectorAll('.container>div')
      @setSlide(divs)

  styleOneContainer: ->


  setSlide: (slides) ->
    @createSlide slide for slide in slides

#    @slideTo = 0
#    @slide.translate(@slideTo)
  createSlide: (slide) ->
    new MobileApp.Slide slide

  touchStart: (event) ->
    @slide.disableTransition()
    if event.touches.length == 1
      @direction    = PageSlider.DIRECTION_UNKNOWN
      @slideStartX  = event.touches[0].pageX
      @slideStartY  = event.touches[0].pageY

  touchMove: (event) ->
    # If they're using more than one finger we're just not going to count
    # that. Sorry, one finger swipes only.
    if event.touches.length == 1

      # Grab the absolute value of the X and Y offset so that we can get an
      # idea of whether or not the user is trying to scroll or swipe.
      xOffset = Math.abs(event.touches[0].pageX - @slideStartX)
      yOffset = Math.abs(event.touches[0].pageY - @slideStartY)

      # Some minor attempt to prevent swiping from disabling scrolling.
      # Oh how much easier it is to control this when you write native
      # apps in obj-c.
      event.preventDefault() if xOffset > 10
      if xOffset > yOffset

        # The first thing to do is determine where we're going by getting the
        # actual offset.
        @slideTo = event.touches[0].pageX - @slideStartX

        # Set direction to right and broadcast the event if it's happened.
        # We want to ensure we only do this once as the resulting listeners
        # may or may not write to the DOM which get's expensive during
        # transitions.
        if @slideTo > 0 and @direction != PageSlider.DIRECTION_RIGHT
          @direction = PageSlider.DIRECTION_RIGHT
          radio(PageSlider.DIRECTION_CHANGE).broadcast(@direction)

          # If they're moving to the left we'll do the same thing.
        else if @slideTo < 0 and @direction != PageSlider.DIRECTION_LEFT
          @direction = PageSlider.DIRECTION_LEFT
          radio(PageSlider.DIRECTION_CHANGE).broadcast(@direction)
    else
      @slideTo = 0

    @slide.translate(@slideTo)

  touchEnd: (event) ->
    limit = window.innerWidth/3
    if @slideTo > 0 and Math.abs(@slideTo) >= limit
      @moveTo(window.innerWidth)
    else if @slideTo < 0 and Math.abs(@slideTo) >= limit
      @moveTo(-window.innerWidth)
    else
      @moveTo(0)

  touchCancel: (event) ->
    @moveTo(0)

  moveTo: (@slideTo) ->
    @slide.enableTransition()

    # Wonder why this isn't just built into Modernizr.prefixed()...
    # http://modernizr.com/docs/#prefixed
    transEndEventNames =
      'WebkitTransition' : 'webkitTransitionEnd'
      'MozTransition'    : 'transitionend'
      'OTransition'      : 'oTransitionEnd'
      'msTransition'     : 'MSTransitionEnd'
      'transition'       : 'transitionend'

    @slide.element.addEventListener(transEndEventNames[ Modernizr.prefixed('transition') ], =>
      radio(PageSlider.DIRECTION_FINISHED).broadcast((@slideTo != 0))
    )

    @slide.translate(@slideTo)

  moveForwardAnimated: (animated=true)->
    @direction = PageSlider.DIRECTION_LEFT
    radio(PageSlider.DIRECTION_CHANGE).broadcast(@direction)
    if animated
      @moveTo(window.innerWidth)
    else
      radio(PageSlider.DIRECTION_FINISHED).broadcast(true)

  moveBackwardAnimated: (animated=true) ->
    @direction = PageSlider.DIRECTION_RIGHT
    radio(PageSlider.DIRECTION_CHANGE).broadcast(@direction)
    if animated
      @moveTo(-window.innerWidth)
    else
      radio(PageSlider.DIRECTION_FINISHED).broadcast(true)

  type: (obj) ->
    if obj == undefined or obj == null
      return String obj
    classToType = new Object
    for name in "Boolean Number String Function Array Date RegExp".split(" ")
      classToType["[object " + name + "]"] = name.toLowerCase()
    myClass = Object.prototype.toString.call obj
    if myClass of classToType
      return classToType[myClass]
    return "object"

  typeIsArray: ( value ) ->
    value and
    typeof value is 'object' and
    value instanceof Array and
    typeof value.length is 'number' and
    typeof value.splice is 'function' and
    not ( value.propertyIsEnumerable 'length' )
