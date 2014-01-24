var swipeView = function(content, wrapper, nav){
  for(var i = 0, len = content.length; len > i++;)
    $('<a></a>').appendTo(".dot-nav", nav);
  var gallery, el, page, dots = $("a", nav);
  gallery = new SwipeView(wrapper, { numberOfPages: content.length });

  // Load initial data
  for (var i = 0; i < 3; i++) {
    page = i == 0 ? content.length-1 : i-1;
    App.FloorplanView.create({
      floorplan: content[page],
      currentPage: i == gallery.currentMasterPage
    }).appendTo(gallery.masterPages[i]);
  }

  dots[gallery.pageIndex].className = 'active';

  gallery.onFlip(function () {
    var upcoming, i, toRemove;
    for (i=0; i<3; i++) {
      upcoming = gallery.masterPages[i].dataset.upcomingPageIndex;
      if (upcoming != gallery.masterPages[i].dataset.pageIndex) {
        Ember.View.views[gallery.masterPages[i].children[0].id].remove();
        App.FloorplanView.create({floorplan: content[upcoming]}).appendTo(gallery.masterPages[i]);
      }
    }

    $(gallery.masterPages[gallery.currentMasterPage]).find("select").prop("disabled",false);

    $('.active', nav).removeClass("active");
    dots[gallery.pageIndex].className = 'active';
  });
  return gallery;
};
