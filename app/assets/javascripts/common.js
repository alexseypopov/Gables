var isIE = $.browser.msie ? true : false;
var click = window.Touch ? "touchend" : "click";

var tabs = (function() {
  var that = {};
  that.clearSiblings = function(parent) {
    parent.siblings('li').removeClass('active');
    parent.parents('ul').siblings('.tab').hide();
  };
  that.init = function() {
    $('.tab_nav li').not('.active').each(function() {
      var dest = $(this).children('a').attr('href');
      $(dest).hide();
    });
    $('.tab_nav a').bind(click,function(e) {
      e.preventDefault();
      var parent = $(this).parents('li');
      if(!parent.hasClass('active')) {
        that.clearSiblings(parent);
        parent.addClass('active');
        $($(this).attr('href')).show();
      }
    });
  };
  return that;
})();

var tumblrPull = (function() {
  var that = {};
  that.container = null;
  that.options = {};
  that.getData = function() {
    $.ajax({
      data: {num: 3},
      dataType: 'jsonp',
      url: that.options.url+'api/read/json',
      success: function(data, status) {
        if(data.posts && data.posts.length > 0) {
          var posts = [];
          for(var i in data.posts) {
            if(data.posts[i]) {
              var body = $(data.posts[i]['regular-body']).text();
              var title;
              if(data.posts[i].type == 'regular') {
                title = data.posts[i]['regular-title'];
              } else if(data.posts[i].type == 'link') {
                title = data.posts[i]['link-text'];
              }
              var html = '<div class="hentry">'
                          +'<h3 class="entry-title"><a href="'+data.posts[i].url+'">'+title+'</a></h3>'
                          +'<p class="entry-summary">'+that.truncate(body, 125)+'</p>'
                          +'<p class="more"><a href="'+data.posts[i].url+'" rel="bookmark">more &raquo;</a></p>'
                          +'</div>';
              posts.push(html);
            }
          }
          that.options.dest.html(posts.join(''));
        }
      }
    });
  };
  that.truncate = function(string, length) {
    if(string.length > length) {
      new_string = string.substring(0, length)+"…";
      return new_string;
    } else {
      return string;
    }
  };
  that.init = function() {
    that.container = $('#tumblr_feed');
    if(that.container.length > 0) {
      that.options.url = $('.blog_link a', that.container).attr('href');
      if(that.options.url.charAt(that.options.url.length-1) != '/') {
        that.options.url += '/';
      }
      that.options.dest = $('.hfeed', that.container);
      that.getData();
    }
  };
  return that;
})();

var walkscore = (function() {
  var that = {};
  that.container = null;
	that.injectWalkScore = function(id){
		$.ajax({
			url: '/find/walkscore/'+id+'.json',
			dataType: 'json',
			success: function(data) { that.displayWalkScore(data); },
			error: function() { }
		});
	};
	that.displayWalkScore = function(data) {
	  var htmlStr;
	  if($('#walkscore_tab').length > 0) {
	    htmlStr = '<a href="#" onclick="$(\'ul.tab_nav a[href=#walkscore_tab]\').trigger(\'click\'); scroll_to($(\'ul.tab_nav\')); return false;"><img src="http://www2.walkscore.com/images/api-logo.gif" /><span class="walkscore-scoretext">' + data.walkscore + '</span></a>';
	  } else {
	    htmlStr = '<img src="http://www2.walkscore.com/images/api-logo.gif" /><span class="walkscore-scoretext">' + data.walkscore + '</span>';
	  }
    var infoIconHtml = '<span id="ws_info"><a href="http://www.walkscore.com/how-it-works.shtml" target="_blank"><img src="http://cdn.walkscore.com/images/api-more-info.gif" width="13" height="13"" /></a></span>';
    that.container.html('<p>' + htmlStr + infoIconHtml + '</p>');
	};
	that.init = function() {
	  that.container = $('#walkscore_container');
	  if(that.container.length > 0) {
	    that.injectWalkScore(that.container.attr('data-id')); 
	  }
	};
	return that;
})();

var showCommunity = (function() {
  var that = {};
  that.amenities_visible = false;
  that.container = null;
  that.all_floorplan_list = null;
  that.floorplan_list = null;
  that.amenityActions = function() {
    var amenity_container = $('#community_overview .amenities', that.container);
    amenity_container.hide();
    $('#community_overview a.toggle').bind(click,function(e) {
      e.preventDefault();
      if(that.amenities_visible === false) {
        that.amenities_visible = true;
        amenity_container.slideDown('fast', function() {
          if(isIE === true) {
            $('.image_thumbs li.active').trigger('click');
          }
        });
        $(this).text('hide amenities -');
      } else {
        that.amenities_visible = false;
        amenity_container.slideUp('fast');
        $(this).text('all amenities +');
      }
    });
  };
  that.allFloorplans = function() {
    that.all_floorplan_list = $('#community_floorplans .all_floorplans .all_floorplan', that.container);
    if(that.all_floorplan_list.length > 8) {
      that.allFloorplansPage(1); 
    }
  };
  that.allFloorplansPage = function(index) {
    var start = (index - 1) * 8;
    var end = start + 7;
    $('#community_floorplans .all_floorplans', that.container).fadeTo('fast', 0, function() {
      that.all_floorplan_list.show();
      that.all_floorplan_list.filter(":lt("+start+"), :gt("+end+")").hide();
      $('#community_floorplans .all_floorplans', that.container).fadeTo('fast', 1);
    });
    that.allFloorplanPagination(that.all_floorplan_list.length, 1);
  };
  that.allFloorplanPagination = function(length, page) {
    $('.all_floorplan_pagination', that.container).paginate(page, Math.ceil(length / 8), function(newPage) {
      that.allFloorplansPage(newPage);
      scroll_to($('#community_floorplans', that.container));
      that.allFloorplanPagination(length, newPage);
    }, {
      nextText: 'next',
      numEntries: length,
      prevText: 'prev',
      showFirst: false,
      showLast: false
    });
  };
  that.floorplans = function() {
    that.floorplan_list = $('#community_floorplans .floorplans .floorplan', that.container);
    if(that.floorplan_list.length > 3) {
      that.floorplansPage(1); 
    }
  };
  that.floorplansPage = function(index) {
    var start = (index - 1) * 3;
    var end = start + 2;
    $('#community_floorplans .floorplans', that.container).fadeTo('fast', 0, function() {
      that.floorplan_list.show();
      that.floorplan_list.filter(":lt("+start+"), :gt("+end+")").hide();
      $('#community_floorplans .floorplans', that.container).fadeTo('fast', 1);
    });
    that.floorplanPagination(that.floorplan_list.length, 1);
  };
  that.floorplanPagination = function(length, page) {
    $('.floorplan_pagination', that.container).paginate(page, Math.ceil(length / 3), function(newPage) {
      that.floorplansPage(newPage);
      scroll_to($('#community_floorplans', that.container));
      that.floorplanPagination(length, newPage);
    }, {
      nextText: 'next',
      numEntries: length,
      prevText: 'prev',
      showFirst: false,
      showLast: false
    });
  };
  that.scheduleForm = function() {
    var form = $('#new_schedule', that.container);
    if($('.error_explanation', form).length > 0) {
      setTimeout(function() {
        scroll_to($('#schedule_visit'));
      }, 300);
    }
  };
  that.sectionLinks = function() {
    $('a.anchor').bind(click,function(e) {
      e.preventDefault();
      var link = $(this);
      var dest = $(link.attr('href'));
      if(!dest.is(':visible')) {
        $('#community_overview a.toggle').trigger(click);
      }
      scroll_to(dest);
    });
    if(window.location.hash && window.location.hash.search('drop_') == 1) {
      var dest = $(window.location.hash.replace('drop_', ''));
      setTimeout(function() {
        scroll_to(dest);
      }, 500);
    }
  };
  that.slideControls = function(carousel) {
    var scroller = $(carousel.container);
    $('li:first-child', scroller).addClass('active');
    $('li', scroller).bind(click, function(e) {
      e.preventDefault();
      var img        = $(this).find('img'),
          main_img   = $(this).attr('data-image'),
          main_video = img.attr('data-video'),
          index      = img.attr('jcarouselindex');
      $(this).siblings('li').removeClass('active');
      $(this).addClass('active');
      $('.main_image', that.container).find("iframe").hide();
      $('.main_image', that.container).html(
        $("<img>",{ src: main_img, "data-video": main_video })
      ).addClass(main_video ? "video" : "").removeClass(main_video ? "" : "video");
    });
    $('.main_image', that.container).bind(click, function(e){
      var $self = $(this);
      if($self.hasClass("video")){
        var img = $self.find("img"), url;
        img.replaceWith(
          $("<iframe>",{
            src: img.attr("data-video"),
            width: 640,
            height: 360
          })
        );
        $self.removeClass("video");
      }
    });
  };
  that.yelpReviews = function() {
    var $reviews = $('.reviews', that.container);
    if($reviews.length > 0) {
      $.get('/yelp/' + $reviews.attr("data-yelp-id"), function(resp){
        $reviews.find('.stars').attr("src",resp.rating_img_url);
        $reviews.find('.count').html(resp.review_count + " Reviews");
        $reviews.attr("href",resp.url).attr("target","yelp");
      });
    }
  };
  that.showChatModal = function(){
    var chat_now = $("#chat-now");
    setTimeout(function(){
      chat_now.show();
    }, 30000);
    chat_now.find(".close").bind(click, function(){
      chat_now.hide();
    });
  };
  that.init = function() {
    that.container = $('#property');
    if(that.container.length > 0) {
      that.amenityActions();
      that.floorplans();
      that.allFloorplans();
      that.sectionLinks();
      that.scheduleForm();
      that.showChatModal();
      tabs.init();
      $('.images .image_thumbs', that.container).jcarousel({
  			wrap: 'none',
        scroll: 6,
  			initCallback: that.slideControls
      }); 
      setTimeout(function() {
        that.yelpReviews();
      }, 500);
    }
  };
  return that;
})();

var homeMarquee = (function() {
  var that = {};
  that.container = null;
  that.min = 945;
  that.max = 1280;
  that.height = null;
  that.width = null;
  that.determineSize = function(){
    var win_width = $(window).width();
    switch(true) {
      case win_width >= that.max:
        that.width = that.max;
        break;
      case win_width <= that.min:
        that.width = that.min;
        break;
      default:
        that.width = win_width;
        break;
    }
    var remainder = that.width - 945;
    if($('#marquee').hasClass('inner')) {
      that.height = (that.width * 355) / that.max;
    } else {
      that.height = (that.width * 590) / that.max; 
    }
    that.container.css('height', that.height+'px');
    that.container.css('width', that.width+'px');
  };
  that.setupCycle = function() {
    that.container.cycle({
  		fx: 'fade',
  		speed: 900,
  		timeout: 6000,
  		prev: '#slide_controls .prev',
      next: '#slide_controls .next',
  		slideExpr: '.item'
  	});
  };
  that.init = function() {
    that.container = $('#marquee .wrapper');
    if(that.container.length > 0) {
      that.determineSize();
      if(that.container.children('.item').length > 0) {
        that.setupCycle();
      }
    }
  };
  return that;
})();

var newsPanel = (function() {
  var that = {};
  that.container = null;
  that.locationPanel = function() {
    $('#locations_tab ul li a').not('.active').siblings('ul, .regions').hide();
    //$('#locations_tab ul ul', that.container).hide();
    $('#locations_tab .regions').each(function() {
      var region = $(this);
      var list = $(this).children('ul');
      var li_count = list.children('li').length;
      if(li_count >= 4) {
        var group = list.find('li:lt('+Math.floor(li_count/2)+')').remove();
        $('<ul/>').append(group).prependTo(region); 
      }
    });
    $('#locations_tab a', that.container).bind(click,function(e) {
      if($(this).siblings('ul, .regions').length > 0) {
        e.preventDefault();
        $(this).parents('li').siblings('li').children('a').removeClass('active');
        $(this).parents('li').siblings('li').children('ul, .regions').hide();
        $(this).siblings('ul, .regions').hide();
        $(this).addClass('active');
        $(this).siblings('ul, .regions').show('slide', {direction: 'left'}, 300);
      }
    });
  };
  that.init = function() {
    that.container = $('#news_feed');
    tabs.init();
    that.locationPanel();
  };
  return that;
})();

var fixFooter = function() {
  var list = $('#footer_nav .double ul');
  var li_count = list.children('li').length;
  var group = list.find('li:lt('+Math.floor(li_count/2)+')').remove();
  list.before($('<ul class="first"/>').append(group)); 
}

$(function() {
  $.ajaxSetup({
    timeout: 15000
  });
  $('select').not('#query').uniform();
  $('a.iframe').fancybox({
		autoDimensions : true,
		height: 550,
		type: 'iframe',
		width: 500
	});
  if(!window.Touch){
    $('a.video_iframe').fancybox({
      autoDimensions : true,
      height: 425,
      type: 'iframe',
      width: 550
    });
  }
	$('a.bio_iframe').fancybox({
		autoDimensions : true,
		height: 475,
		type: 'iframe',
		width: 710
	});
	$('a.zoom_image').fancybox({
    type: 'image'
  });
  setTimeout('fade_notice()', 5000);
  $('#back_to_topz').bind(click,function(e) {
    e.preventDefault();
    scroll_to($('#'));
  });
  $('a[rel=external]').bind(click,function(e) {
    e.preventDefault();
		window.open($(this).attr('href'));
	});
  $('footer .ds a, footer .recent_searches a').attr('style', 'color: #eee;');
  $('.input.date input').datepicker();
  if (!Modernizr.input.placeholder){
    $('input[placeholder]').each(function() {
      title = $(this).attr('placeholder');
      $(this).attr('title', title);
      $(this).hint(); 
    });
  }
  if(!Modernizr.csscolumns) {
    fixFooter();
  }
  $('a.video_iframe').click(function(e){
    e.preventDefault();
    var video_id = e.currentTarget.getAttribute("data-video-id");
    _gaq.push(['_trackPageview', '/modal/video?video_id='+video_id]);
    if(window.Touch) window.open("http://www.youtube.com/watch?v="+video_id);
  });

});

function scroll_to(context, speed) {
  if(!speed) { speed = 300; }
  $('html, body').animate({
    scrollTop: context.offset().top
  }, speed, 'easeOutCubic');
}

function fade_notice() {
  $('.flash').fadeOut(1000,0);
}

function avg(data) {
  var av = 0;
  var cnt = 0;
  var len = data.length;
  for (var i = 0; i < len; i++) {
    var e = +data[i];
    if(!e && data[i] !== 0 && data[i] !== '0') {
      e--;
    }
    if (data[i] == e) {
      av += e;
      cnt++;
    }
  }
  return av/cnt;
}
