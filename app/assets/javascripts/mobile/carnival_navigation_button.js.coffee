class MobileApp.NavigationButton
  constructor: (@elements) ->
    @init() if @elements

  init: () ->
    @attachEventListeners()

  attachEventListeners: () ->
    Hammer(@elements.siteNavButton).on 'tap', =>

      body = document.getElementsByTagName('body')[0]

      if body.scrollTop > 50 and @elements.siteNav[0].style.display is 'block'

        body.scrollTop = 0

      else

        if @elements.siteNav[0].style.display is 'none'
          @elements.siteNav[0].style.display = 'block'
          if MobileApp.searchDropdown.isVisible
            MobileApp.searchDropdown.hideSearchDropdown() 
        else 
          @hideSiteNav()

        if body.scrollTop > 50
        then body.scrollTop = 0 and @elements.siteNav[0].style.display = 'block'

  hideSiteNav: ->
    @elements.siteNav[0].style.display = 'none'

