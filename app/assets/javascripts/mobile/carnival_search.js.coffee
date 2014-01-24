## requires liquidmetal.js

class MobileApp.SearchDropdown
  KEY_ENTER = 13

  constructor: (@element, @options) ->
    @init() if @element

  init: () ->
    @currentValue = ''
    @searchContainer = @element.querySelector('#apartment_search')
    @queryTextField = @searchContainer.querySelector('#query')
    @findby = @searchContainer.parentNode.parentNode.parentNode.querySelector('.find-by')
    @queryResultContainer = @searchContainer.querySelector('#live_search')
    @fieldset = @searchContainer.querySelector('fieldset')
    @clearButton = document.querySelector('#search-clear-button')
    @searchIcon = document.querySelector('#search-icon')
    @cancelButton = document.querySelector('#cancel-button')
    @siteNavButton = document.querySelector('#mobile-site-nav')

    @getLeftAndRightCells()
    @setPlaceHolder()
    @buildSearchContainer()
    @textFieldEvents()
    @setupActions()
    @watchPageLoad()


  setupActions: () ->
    
    success = (position) ->
      searchField = document.querySelector('#query')
      searchField.value = position.coords.latitude+ ' ' + position.coords.longitude
      document.querySelector('#apartment_search').submit()

    error= (msg) ->
      console.log msg

    Hammer(document.querySelector("#find-near-me")).on 'tap', () ->
      if navigator.geolocation
      then navigator.geolocation.getCurrentPosition(success, error)

    Hammer(document.querySelector('#advanced-search')).on 'tap', () =>
      MobileApp.toggle(document.querySelector('#apartment-search-form'))

    Hammer(@clearButton,{stop_browser_behavior: false}).on 'tap', (e) =>
      if @queryTextField.value == ""
        @hideSearchDropdown() 
      else
        @clearButton.style.display = 'none'
        @searchIcon.style.display = 'block'
        @queryResultContainer.style.display = 'none'

        setTimeout () =>
          @queryTextField.value = ""
          @queryTextField.focus()

    Hammer(@queryTextField,{stop_browser_behavior: false}).on 'tap', () =>
      unless @isVisible
        MobileApp.navigationButton.hideSiteNav()
        @fieldset.style.padding = '0 0 0 10px'
        @hideCells()
        @scrollToTop(500)
        @toggleSearchCancelIcons() if @searchIcon.style.display isnt 'none'
        @findby.style.height = window.innerHeight + 'px'
        @showCancelButton()
        setTimeout () =>
          @enableTextField()
          document.activeElement.blur()
        , 500
        @isVisible = true

    $(@cancelButton).on 'click', () =>
      @hideClearButton()
      @hideSearchDropdown()
      @hideCancelButton()

  setPlaceHolder: () ->
    @queryTextField.setAttribute('placeholder', 'Find an Apartment')

  watchPageLoad: () ->
    @queryTextField.addEventListener 'load', () =>
      @emptyText()

  buildSearchContainer: () ->
    @queryTextField.addEventListener 'keyup', (e) =>
      if @queryTextField.value is '' then return
      value = @queryTextField.value
      if value isnt @currentValue and value.length > 1
      then @showAndFilterList(value)
      else @hideAndResetList()

#    @queryTextField.addEventListener 'keydown', (e) =>
#      switch e.which
#        when @KEY_ESC then @hideAndResetList()
#        else

  showAndFilterList: (value) =>
    MobileApp.toggle(@queryResultContainer) if @queryResultContainer.style.display is 'none'
    for li, i in @queryResultContainer.querySelector('ul').getElementsByTagName('li')
      score = LiquidMetal.score li.textContent.trim(), value
      if score > 0.6 or li.textContent.trim().match(new RegExp(value, 'i'))
      then @assignListItemAction(li)
      else @unassignListItem(li)

  hideAndResetList: () ->
    MobileApp.toggle(@queryResultContainer)

  assignListItemAction: (li) ->
    li.style.display = 'block'
    Hammer(li).on 'tap', () =>
      @queryTextField.value = li.textContent.trim()
      MobileApp.toggle(@queryResultContainer)
      @element.querySelector('#apartment_search').submit()

  unassignListItem: (li) ->
    li.style.display = 'none'

  enableTextField: ->
    @queryTextField.removeAttribute('disabled')

  textFieldEvents: ->
    @queryTextField.addEventListener 'blur', () =>
      @element.style.position = 'fixed'

    @queryTextField.addEventListener 'focus', () =>
      @toggleClearButton()

    @queryTextField.addEventListener 'keyup', (e) =>
      if e.which is KEY_ENTER
      then @element.querySelector('#apartment_search').submit()

      @toggleClearButton()

  toggleClearButton: ->
    if @queryTextField.value != ""
      @showClearButton()
    else
      @hideClearButton()

  showClearButton: ->
    @clearButton.style.display = 'block'
    @searchIcon.style.display = 'none'

  hideClearButton: ->
    @clearButton.style.display = 'none'
    @searchIcon.style.display = 'block'

  showCancelButton: ->
    @cancelButton.style.display = 'block'
    @siteNavButton.style.display = 'none'

  hideCancelButton: ->
    @cancelButton.style.display = 'none'
    @siteNavButton.style.display = 'block'

  scrollToTop: (time) ->
    setTimeout () =>
      window.scrollTo(0, 1)
      @element.style.position = 'absolute'
    , time

  getLeftAndRightCells: () ->
    @nodeArray = []
    nodes = @element.querySelector('.row').childNodes
    for node, i in nodes
      if node.className is 'cell'
      then @nodeArray.push node

  hideCells: ->
    @nodeArray[0].style.display = 'none'

  showCells: ->
    @nodeArray[0].style.display = 'block'

  toggleSearchCancelIcons: () ->
    MobileApp.toggle(@findby)

  emptyText: () ->
    @queryTextField.value = ''

  hideSearchDropdown: () ->
    @queryTextField.setAttribute('disabled','disabled')
    @emptyText()
    @showCells()
    @toggleSearchCancelIcons()
    @fieldset.style.padding = '0'
    document.activeElement.blur()
    @queryTextField.blur()
    @searchIcon.focus()
    if @queryResultContainer.style.display is 'block'
    then MobileApp.toggle(@queryResultContainer)
    @isVisible = false
