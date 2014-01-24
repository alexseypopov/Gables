$(document).ready(function(){
  App.photoSwipeView = function(){
    for(var i = 0, len = photos.length; len > i++;)
      $('<a></a>').appendTo("#photo-nav");
    var gallery, el, i, page, dots = document.querySelectorAll('#photo-nav a');

    gallery = new SwipeView('#photos-wrapper', { numberOfPages: photos.length });

    var updateDescription = function(page, index){
      var desc = photos[index].description || "Taking care of the way people live";
      $(page).empty().append(
        '<div class="description">'+
          '<p>Experience the Gables Difference at ' + property_name + '</p>' +
          '<p class="emph">'+ desc + '</p></div>'
      );
    };

    // Load initial data
    for (i=0; i<3; i++) {
      page = i==0 ? photos.length-1 : i-1;
      gallery.masterPages[i].style.backgroundImage = "url(" + photos[page].image.url + ")";
      updateDescription(gallery.masterPages[i], page);
    }

    dots[gallery.pageIndex].className = 'active';

    gallery.onFlip(function () {
      var el, upcoming, i;

      for (i=0; i<3; i++) {
        upcoming = gallery.masterPages[i].dataset.upcomingPageIndex;

        if (upcoming != gallery.masterPages[i].dataset.pageIndex) {
          gallery.masterPages[i].style.backgroundImage = "url(" + photos[upcoming].image.url + ")";
          updateDescription(gallery.masterPages[i], upcoming);
        }
      }

      document.querySelector('#photo-nav .active').className = '';
      dots[gallery.pageIndex].className = 'active';
    });

    var autoRun = function(){
      gallery.next();
    };

    var timeout, interval = setInterval(autoRun, 10000);

    gallery.resetTimeout = function(){
      clearInterval(interval);
      clearTimeout(timeout);
      timeout = setTimeout(function(){ //restart after 60s
        interval = setInterval(autoRun, 10000);
      },60000);
    };

    gallery.onTouchStart(gallery.resetTimeout);

    gallery.destroyAll = function(){
      clearInterval(interval);
      clearTimeout(timeout);
      this.destroy();
    };

    gallery.onMoveOut(function () {
      gallery.masterPages[gallery.currentMasterPage].className = gallery.masterPages[gallery.currentMasterPage].className.replace(/(^|\s)swipeview-active(\s|$)/, '');
    });

    gallery.onMoveIn(function () {
      var className = gallery.masterPages[gallery.currentMasterPage].className;
      /(^|\s)swipeview-active(\s|$)/.test(className) || (gallery.masterPages[gallery.currentMasterPage].className = !className ? 'swipeview-active' : className + ' swipeview-active');
    });
    return gallery;
  };
});

$(function () {
  window.addEventListener('load', function(e) {
    if (window.applicationCache) {
      window.applicationCache.addEventListener('updateready', function(e) {
          if (window.applicationCache.status == window.applicationCache.UPDATEREADY) {
            // Browser downloaded a new app cache.
            // Swap it in and reload the page to get the new hotness.
            window.applicationCache.swapCache();
            // if (confirm('A new version of this site is available. Load it?')) {
            //   window.location.reload();
            // }
          } else {
            // Manifest didn't changed. Nothing new to server.
          }
      }, false);
    }
  }, false);

  $(window.applicationCache.onerror = function () {
    console.log('There was an error when loading the cache manifest.');
  });
  $(window.applicationCache.onupdateready = function () {
    console.log('There is a new version of the app.');
  });
  if(window.Touch){
    $("a[href]").on(click, function (event) {
      event.preventDefault();
      window.location = $(this).attr("href");
    });
  }
  if(window.location.search.match("kiosk")){
    $("body").addClass("kiosk");
  }
  if(navigator.userAgent.match(/iPad/i)){
    $("body").addClass("ipad");
  }

})
