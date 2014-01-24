$.domReady ->

  initApp = () ->
    ##
    # get elements
    # exist on every page
    ##
    pageElements =
      navButton: document.querySelector('#mobile-site-nav')
      siteNav: document.querySelectorAll('.accordion')
      toggles: document.querySelectorAll('.toggle')
      gablesNavLogo: document.querySelector('#logo')
      siteNavButton: document.querySelector('#mobile-site-nav')
      findApartmentSearch: document.querySelector('#header')
      findBy: document.querySelectorAll('.find-by')
      h2Titles: document.querySelectorAll('h2.title')
      findbyContainer: document.querySelector('.find-by-container')
      cancelButton: {}

    ##
    # initialize
    ##
    MobileApp.navigationButton = new MobileApp.NavigationButton pageElements
    MobileApp.searchDropdown = new MobileApp.SearchDropdown pageElements.findApartmentSearch
    findby = new MobileApp.FindBy pageElements.findBy
    
    if $(pageElements.siteNav[0]).hasClass('no-sub') == false
    	createAccordion(pageElements.siteNav)
    

    ##
    # page defaults
    ##
    pageElements.siteNav[0].style.display = 'none'
#    pageElements.advancedSearch.style.display = 'none'
    pageElements.findBy[0].style.display = 'none'

    # Initialize Map
    if document.getElementById('map-canvas')
      MobileApp.mapInstance = new MobileApp.GMap document.getElementById('map-canvas'), properties
      google.maps.event.addDomListener window, 'load', MobileApp.mapInstance

    # Hide address bar
    window.scrollTo 0,0
    $('.toggle-map').on 'click', ->
      $('body').toggleClass('list-view')
      if $('body').hasClass('list-view')
        MobileApp.articlesSwipe.swipeTo(0)
        MobileApp.articlesSwipe.destroy()
      else
        MobileApp.createArticlesSlider()

    addToggleEventListener = () ->
      for h2, i in pageElements.toggles
        if h2.nextElementSibling is null then return
        h2.nextElementSibling.style.display = 'none'
        $(h2).on 'click', () ->
          if @.nextElementSibling.style.display is 'none'
          then toggleOn(h2, @.nextElementSibling)
          else toggleOff(h2, @.nextElementSibling)

    toggleOn = (h2,container) ->
      addClass(h2, 'on')
      removeClass(h2, 'off')
      container.style.display = 'block'

    toggleOff = (h2, container) ->
      addClass(h2, 'off')
      removeClass(h2, 'on')
      container.style.display = 'none'

    hasClass = (ele,cls) ->
      return ele.className.match(new RegExp('(\\s|^)'+cls+'(\\s|$)'))

    addClass = (ele,cls) ->
      if not hasClass(ele,cls)
      then ele.className += " "+cls

    removeClass = (ele,cls) ->
      if hasClass(ele,cls)
      then ele.className = ele.className.replace(new RegExp('(\\s|^)'+cls+'(\\s|$)'),' ')


    if pageElements.toggles isnt null
    then addToggleEventListener()

    success = (position) ->
      searchField = document.querySelector('#query')
      searchField.value = position.coords.latitude+ ' ' + position.coords.longitude
      document.querySelector('#apartment_search').submit()

    error = (msg) ->
      console.log msg

    $('#toggle-map-button').on 'click', () ->
      MobileApp.articlesSwipe.destroy()
      $('#map-canvas').hide()
      $('#serp_results').addClass('off')

#    for h2, i in pageElements.h2Titles
#      h2.nextElementSibling.style.display = 'none'
#      Hammer(h2).on 'tap', () ->
#        if @.nextElementSibling.style.display is 'none'
#        then @.nextElementSibling.style.display = 'block'
#        else @.nextElementSibling.style.display = 'none'
#
#    return

  ##
  # create accordions
  ##
  createAccordion = (pageElements) ->
    dls = pageElements

    for dl, i in dls
      theDL = dl.getElementsByTagName('dl')
      newAccordion = new MobileApp.Accordion theDL, "icon-chevron-up",'icon-chevron-down'
    return

  # TODO: move this to a proper location
  $("#share-icons select").on 'change', (e) ->
    if e.currentTarget.selectedIndex isnt 0
    then window.location = @.value
  $("#brochures select").on 'change', (e) ->
    if e.currentTarget.selectedIndex isnt 0
    then window.location = @.value

  addSeeMoreEventListener = () ->
    $('#see-more').on 'click', () =>
      if $('#community-description p').attr('class') is 'hidden'
      then hideSeeMore()
      else showSeeMore()

  showSeeMore = () ->
    $('#see-more').text('see less')
    toggleSeeMore()
    return

  hideSeeMore = () ->
    $('#see-more').text('see more')
    toggleSeeMore()
    return

  toggleSeeMore = () ->
    $('#see-more').toggleClass('off')
    $('#see-more').toggleClass('on')
    $('#community-description p').toggleClass('hidden')
    $('#community-amenities').toggleClass('hidden')

  if document.querySelector('#see-more')
  then addSeeMoreEventListener()

  ##
  # start app
  ##
#  if Modernizr.touch
#  then initApp()
  initApp()

