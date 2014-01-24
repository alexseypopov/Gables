class MobileApp.Touch

  horizontal_sensitivity: 22
  vertical_sensitivity: 6
  touchDX: 0
  touchDY: 0
  touchStartX: 0
  touchStartY: 0

  constructor: (elements) ->
    @bind(elements)

  bind: (elements...) ->
    for elem in elements
      elem.addEventListener "touchstart", (event) =>
        @handleStart(event, elem)
      elem.addEventListener "touchmove", (event) =>
        @handleMove(event, elem)
      elem.addEventListener "touchend", (event) =>
        @handleEnd(event, elem)

  emitSlideLeft: -> @emit 'swipe:left'
  emitSlideRight: -> @emit 'swipe:right'
  emitSlideUp: -> @emit 'swipe:up'
  emitSlideDown: -> @emit 'swipe:down'

  handleStart: (event, elem) ->
    if event.touches.length is 1
      @touchDX = 0
      @touchDY = 0
      @touchStartX = event.touches[0].pageX
      @touchStartY = event.touches[0].pageY

  handleMove: (event, elem) ->
    if event.touches.length > 1
      @cancelTouch(elem)
    return false

    @touchDX = event.touches[0].pageX - @touchStartX
    @touchDY = event.touches[0].pageY - @touchStartY

  handleEnd: (event,elem) ->
    dx = Math.abs(@touchDX)
    dy = Math.abs(@touchDY)

    if (dx > @horizontal_sensitivity) and (dy < (dx * 2 / 3))
      if @touchDX > 0 then @emitSlideRight() else @emitSlideLeft()

    if (dy > @vertical_sensitivity) and (dx < (dy * 2 / 3))
      if @touchDY > 0 then @emitSlideDown() else @emitSlideUp()

    @cancelTouch(event, elem)
    false

  cancelTouch: (event, elem) ->
    elem.removeEventListener('touchmove', @handleTouchMove, false)
    elem.removeEventListener('touchend', @handleTouchEnd, false)
    true

for key, value of new EventEmitter()
  Touch[key] = value
