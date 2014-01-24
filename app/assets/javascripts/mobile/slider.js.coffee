$.domReady ->
  ##
  #  initialize swipe
  ##
#  swipers = document.getElementsByClassName('swipe')
#
#  swipeOptions =
#    auto: 4000
#    continuous: false
#
#  for swipe, i in swipers
#    swipeObject = new Swipe swipe, swipeOptions


# TODO: We need to use one slider/swiper. This needs to be refactored.
  marquee = document.getElementById('marquee')
  marqueeOptions =
    continuous: false
  marqueeSwipe = new Swipe marquee, marqueeOptions

#  lifeAtGables = document.getElementById('life-at-gables')
#  lifeAtGablesOptions =
#    slidesPerSlide:'auto'
#  lifeAtGablesSwipe = new Swiper lifeAtGables, lifeAtGablesOptions

#  findBy = document.querySelector("#find-by-swiper")
#  findByOptions =
#    sliderPerSlide: 'auto'
#  findBySwipe = new Swiper findBy, findByOptions


  articles = null
  MobileApp.articlesSwipe= null

  transitionEndListener = (e)->
    MobileApp.mapInstance.toggleIcon e.realIndex

  MobileApp.createArticlesSlider = () ->
    articles = document.getElementById('serp_results')
    articleOptions =
      slidesPerSlide:'auto'
      onSlideChangeEnd: transitionEndListener
    MobileApp.articlesSwipe = new Swiper articles, articleOptions

  createPropertySlider = () ->
    properties = document.getElementById('property-swiper')
    propertyOptions =
      slidesPerSlide:'auto'
    propertySwipe = new Swiper properties, propertyOptions

  floorPlanChangeListener = (e) ->
    $('#floorplans-details .floorplan-unit').css({display: 'none'})
    floorplanUnit = $('#floorplans-details .floorplan-unit')[e.realIndex]
    $(floorplanUnit).css({display: 'block'})
    $('#community_floorplans .floorplans-index').html((e.realIndex + 1) + ' / ' + $('#floorplans-details .floorplan-unit').length)

  createFloorplanSwiper = () ->
    floorplans = document.getElementById('floorplans-swiper')
    floorplansOptions =
      slidesPerSlide:'auto'
      onSlideChangeEnd: floorPlanChangeListener
    floorplansSwipe = new Swiper floorplans, floorplansOptions
    $($('#floorplans-details .floorplan-unit')[0]).css({display: 'block'})
    $('<span class="floorplans-index">1 / ' + $('#floorplans-details .floorplan-unit').length + '</span>').appendTo($('#community_floorplans > h2')[0])
    


  if document.getElementById('serp_results')
  then MobileApp.createArticlesSlider()

  if document.getElementById('property-swiper')
  then createPropertySlider()

  if document.getElementById('floorplans-swiper') and available_floor_plans > 0
  then createFloorplanSwiper()

  return