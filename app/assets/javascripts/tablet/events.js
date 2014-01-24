(function($){
  var click = window.Touch ? "touchend" : "click";

  $.fn.anchorScroll = function(container){
    this.on(click,function(event){
      event.preventDefault();
      var parts = this.href.split("#"),
         target = parts[1],
            top = $('#'+target)[0].offsetTop;

      $(container).animate({scrollTop: top - 134}, 500);
    });
  };

  //close popups on click-outside
  $("body").on(click, function(e){
    if($(e.target).parents(".pop,#nav-user,#nav-guest,#nav-login").length == 0 && !$(e.target).hasClass("pop"))
      $(".pop").hide();
  });
})($)
