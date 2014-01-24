class MobileApp.FindBy
  position = 0
  constructor: (@elements) ->

    @init() if @elements

  init: () ->
    @swipe = @elements[0].querySelector('.find-by-container')
    @backbutton = @swipe.querySelectorAll('h2.header .back-button')
    @states = @elements[0].querySelector('.by-state').querySelector('ul').querySelectorAll('li')
    @cities = @elements[0].querySelector('.by-city').querySelector('ul').querySelectorAll('li')
    @properties = @elements[0].querySelector('.by-property').querySelector('ul').querySelectorAll('li')
    @state = @elements[0].querySelector('.by-state')
    @city = @elements[0].querySelector('.by-city')
    @property = @elements[0].querySelector('.by-property')
    @filterCitiesByStateListener()
    @filterPropertiesByCityListener()


  filterCitiesByStateListener: () ->
    Hammer(@backbutton[0]).on 'tap', () =>
      @tween(@state, {css:{left:0}, ease:"easeInOutQuad"})
      @tween(@city, {css:{left:@state.offsetWidth}, ease:"easeInOutQuad"})

    for li, i in @states
      a = li.querySelector('a.drilldown')
      Hammer(a).on "tap", (e) =>
        @tween(@state, {css:{left:-@state.offsetWidth}, ease:"easeInOutQuad"})
        @tween(@city, {css:{left:0}, ease:"easeInOutQuad"})
        currentState = e.currentTarget.getAttribute('data-state')
        @filterCities(currentState)

  filterCities: (currentState) ->
    for li, i in @cities
      if li.getAttribute('data-state') is currentState
      then li.style.display = 'block'
      else li.style.display = 'none'

  filterPropertiesByCityListener: () ->
    Hammer(@backbutton[1]).on 'tap', () =>
      @tween(@city, {css:{left:0}, ease:"easeInOutQuad"})
      @tween(@property, {css:{left:@city.offsetWidth}, ease:"easeInOutQuad"})

    for li, i in @cities
      a = li.querySelector('a.drilldown')
      Hammer(a).on "tap", (e) =>
        e.preventDefault()
        currentCity = e.currentTarget.getAttribute('data-city')
        @filterRegions(currentCity)
        @tween(@city, {css:{left:-@city.offsetWidth}, ease:"easeInOutQuad"})
        @tween(@property, {css:{left:0}, ease:"easeInOutQuad"})
      Hammer(li.querySelector('a')).on 'tap', (e) =>
        e.gesture.preventDefault()

  filterRegions: (currentCity) ->
    for li, i in @properties
      if li.getAttribute('data-city') is currentCity
      then li.style.display = 'block'
      else li.style.display = 'none'

  tween: (obj, css={}, pos) ->
    position = pos
    TweenLite.to(obj, .5, css )
#    TweenLite.to(state, .2, {alpha: 0, left:"-=300px"})

  next: () ->


  prev: () ->
    for button, i in @backbutton
      Hammer(button).on 'tap', (e) =>
        switch
          when position is 1 then

## may be able to use this as a faster nodelist to array conversion
  nodeListToArray: (nodes) ->
    arr = [];
    for item, i in nodes by -1
      arr.unshift nodes[item]
    arr