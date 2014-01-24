class MobileApp.Accordion
  keyId = null
  constructor: (dls, @iconUp, @iconDown) ->
    @dlsAll = dls
    @dls = dls[0].childNodes
    @createKeys()

  createKeys: ->
    for key, i in @dls
      @makeKey(key,i)

  makeKey: (key, i) ->
    @hideKeys()
    if key.tagName is 'DT'
    then @applyKeyOptions key, i

  hideKeys: () ->
    for k in @dls
      if k.tagName is 'DD'
      then k.style.display = 'none'
    @resetIcons()
    return

  applyKeyOptions: (key, i) ->
    key.setAttribute('data-id', i)
    Hammer(key).on 'tap', (e) =>
      @hideKeys()
      @showDDs(key)
      @toggleIcon(key)
      if keyId is key.getAttribute('data-id')
      then @resetAccordion()
      else keyId = key.getAttribute('data-id')

  resetAccordion: () ->
    @hideKeys()
    keyId = null
    return

  resetIcons: ->
    for key in @dls
      if key.tagName is 'DT' and key.getElementsByTagName('i')[0]
      then key.getElementsByTagName('i')[0].setAttribute("class", @iconDown)

  toggleIcon: (key) ->
    if key.getElementsByTagName('i')
    then $(key.getElementsByTagName('i')[0]).toggleClass('up')

  showDDs: (key) ->
    dds = []
    dd = key.nextElementSibling
    if dd isnt null and dd.tagName is 'DD' and dd.style.display isnt 'block'
    then dds.push dd,
      dd.style.display = 'block',
      @showDDs(key.nextElementSibling)
    return