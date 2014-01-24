var slider = (function() {
  var that = {};
  that.container = null;
  that.init = function() {
    that.container = $('#marquee');
    if(that.container.length > 0) {
      var ul = that.container.find('ul');
      var ulPadding = 25;
      //Get menu width
      var scrollerWidth = that.container.width();
      
      //Find last image container
      var lastLi = ul.find('li:last-child');
      if(lastLi.length > 0) {
        //When user move mouse over menu
        that.container.mousemove(function(e){
          //As images are loaded ul width increases,
          //so we recalculate it each time
          var ulWidth = lastLi[0].offsetLeft + lastLi.outerWidth() + ulPadding; 
          var left = (e.pageX - that.container.offset().left) * (ulWidth-scrollerWidth) / scrollerWidth;
          that.container.scrollLeft(left);
        });
      }
    }
  };
  return that;
})();

$(function() {
  slider.init();
});