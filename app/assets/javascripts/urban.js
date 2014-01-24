//= require jquery.js
//= require jquery-ui.min.js
//= require modernizr.js
//= require jquery.hint.js
//= require jquery.cookie.js
//= require jquery.carousel.js
//= require jquery.cycle.js
//= require jquery.paginate.js
//= require jquery.uniform.js
//= require jquery.fancybox.pack.js
//= require common.js

$(function() {
  homeMarquee.init();
  newsPanel.init();
  showCommunity.init();
  $('#filter_city').change(function() {
    var val = $(this).val();
    if(val == '') {
      $('.property').show();
    } else {
      $('.property').hide();
      $('.property[data-city="'+val+'"]').show();
    }
  });
  $("a[href^=http]").each(function(){
    if(this.href.indexOf(location.hostname) == -1) {
      $(this).attr({
        target: "_blank",
        title: "Opens in a new window"
      });
    }
  })
});