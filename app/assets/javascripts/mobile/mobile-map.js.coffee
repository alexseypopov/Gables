class MobileApp.GMap
  markers = []
  places = []
  marker = null
  map = null
  zoom = 10
  center = null
  use_bounds = null
  bounds = null
  objType = null
  url = window.location.search.substr(1,window.location.search.length).split("&")

  constructor: (@element, @options) ->
    @init() if @element and google isnt undefined

  init: () ->
    center = new google.maps.LatLng(33.7856030000,-84.4090570000)
    bounds = new google.maps.LatLngBounds()
    mapOptions =
      disableDefaultUI: true
      zoom: 13
      mapTypeId: google.maps.MapTypeId.TERRAIN
      center: center

    map = new google.maps.Map(@element, mapOptions)

    @createLocations()
    @parseThisUrl()

  toggleIcon: (idx) ->
    for marker in markers
      if marker.title isnt 'map-pin-search'
        marker.setIcon('/assets/map/pin-community.svg')
        marker.setZIndex(0);

    markers[idx].setIcon('/assets/map/pin-community-selected.svg')
    markers[idx].setZIndex(999);

  createLocations: () ->
    for option in @options
      places.push(new google.maps.LatLng(option.latitude, option.longitude))
    @toggleBounce()

  parseThisUrl: () ->
    result
    for item, i in url
      if item.split("=")[0] is 'query'
      then result = item.split("=")[1]
    lat = result.split('+')[0]
    long = result.split('+')[1]
    if @isLatLong(lat, long) and @isNumber(lat)
    then @useLatLongToAddQueryMarker(lat, long)
    else @useStringToAddQueryMarker(result)
    return

  isNumber: (n) ->
    !isNaN(parseFloat(n)) && isFinite(n)

  isLatLong: (lat, long) ->
    latReg = /^(-?[1-8]?\d(?:\.\d{1,18})?|90(?:\.0{1,18})?)$/;
    longReg = /^(-?(?:1[0-7]|[1-9])?\d(?:\.\d{1,18})?|180(?:\.0{1,18})?)$/
    validLat = latReg.test(lat);
    validLon = longReg.test(long);
    if validLat and validLon
    then return true
    else return false

  useStringToAddQueryMarker: (queryString) ->
    geocoder = new google.maps.Geocoder()
    opts = {'address': queryString}
    geocoder.geocode opts , (results, status) =>
      if status is google.maps.GeocoderStatus.OK
      then @fitUserLocation(results)
      else alert("Geocode was not successful for the following reason: " + status)

  fitUserLocation: (results) ->
    @createMarker(results[0].geometry.location, false, 'search')
    map.fitBounds(bounds)

  useLatLongToAddQueryMarker: (lat, long) ->
    centerPlace = new google.maps.LatLng(lat, long)
    @createMarker(centerPlace, false, 'search')
    map.fitBounds(bounds)

  toggleBounce: () ->
    for place, i in places
      @createMarker(place, true, i)
    map.fitBounds(bounds)

  createLabel: (marker) ->
    label = new Label map: map
    label.bindTo('position', marker, 'position');
    label.bindTo('text', marker, 'position');


  createMarker: (place, useIcon=false, id) ->
    if useIcon
      if id is 0
        icon = '/assets/map/pin-community-selected.svg'
      else
        icon = '/assets/map/pin-community.svg'
    else 
      icon = '/images/map/gables-searchpin.png'
    marker = new google.maps.Marker({
      map: map
      draggable:false
      animation: google.maps.Animation.DROP
      position: place
      icon: icon
      title: 'map-pin-' + id
      optimized: false
    })
    
    if id is 0
      marker.setZIndex(999);
    # TODO: Implement after styling is completed
#    @createLabel(marker)
#    google.maps.event.addListener(marker, 'click', () ->
#      console.log marker
#    )
    markers.push(marker)
    bounds.extend(place)

# TODO: Implement after styling is completed
class Label

  if typeof google isnt 'undefined' and google.maps
    Label:: = new google.maps.OverlayView 

  constructor: (@options) ->
    @init() if @options

  init: () ->
    @.setValues(@options)
    span = @.span_ = document.createElement('span')
    span.style.cssText = 'position: relative; left: -50%; top: -8px; white-space: nowrap; border: 1px solid blue; padding: 2px; background-color: white'
    div = @.div_ = document.createElement('div')
    div.appendChild(span)
    div.style.cssText = 'position: absolute; display: none'

  onAdd: () ->
    pane = @.getPanes().overlayLayer
    pane.appendChild(@.div_);
    @listeners = [
      google.maps.event.addListener @, 'position_changed', () -> @.draw()
      google.maps.event.addListener @, 'text_changed', () -> @.draw()
    ]

  onRemove: () ->
    @.div_.parentNode.removeChild(@.div_)

    #Label is removed from the map, stop updating its position/text.
    for listener in @.listeners
      google.maps.event.removeListener(listener)

  draw: () ->
    projection = @.getProjection();
    position = projection.fromLatLngToDivPixel(@.get('position'));

    div = @.div_;
    div.style.left = position.x + 'px';
    div.style.top = position.y + 'px';
    div.style.display = 'block';

    @span_.innerHTML = @.get('text').toString()