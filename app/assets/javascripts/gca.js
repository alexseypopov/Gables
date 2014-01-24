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

var mainNav = (function() {
  var that = {};
  that.container = null;
  that.clearSiblings = function() {
    $('li.top_level', that.container).removeClass('active');
  };
  that.openPanel = function(link) {
    var container = $(link).parents('li.top_level');
    if(container.hasClass('active')) {
      $('.sub_nav', container).slideUp(100, function() {
        container.removeClass('active');
        $('.sub_nav', container).attr('style', '');
        homeSearch.container.show();
      });
    } else {
      homeSearch.container.hide();
      var doSlide = function() {
        $('.sub_nav', container).slideDown('fast', function() {
          container.addClass('active');
          $('.sub_nav', container).attr('style', '');
        });
      };
      if($('li.active', that.container).length > 0) {
        $('li.active .sub_nav', that.container).slideUp('fast', function() {
          doSlide();
          that.clearSiblings();
        }); 
      } else {
        doSlide();
      }
    }
  };
  that.statesList = function() {
    var list = $('.states_list', that.container);
    var update_list = function(index) {
      var new_opts = [];
      new_opts.push('<option value="">Select</option>');
      $('li[data-state="'+index+'"] ul li', that.container).each(function() {
        var t = $(this).text();
        new_opts.push('<option value="'+t+'">'+t+'</option>');
      });
      $('#city', that.container).html(new_opts.join("\n"));
      $('#city', that.container).trigger('change');
      if(new_opts.length <= 1) {
        $('#city', that.container).attr('disabled', 'disabled');
        $('#city', that.container).parents('.selector').fadeTo(1, 0.8);
      } else {
        $('#city', that.container).removeAttr('disabled');
        $('#city', that.container).parents('.selector').fadeTo(1, 1);
      }
    }
    $('#state', that.container).change(function(e) {
      update_list(e.srcElement.value);
    });
    update_list($('#state', that.container).val());
  };
  that.init = function() {
    that.container = $('#gca_nav');
    $('li.top_level > a', that.container).click(function(e) {
      if($(this).siblings('.sub_nav').length > 0) {
        e.preventDefault();
        that.openPanel(this); 
      }
    });
    if($('.states_list', that.container).length > 0) {
      that.statesList();
    }
  };
  return that;
})();

var homeSearch = (function() {
  var that = {};
  that.container = null;
  that.statesList = function() {
    var list = $('.states_list', that.container);
    var update_list = function(index) {
      var new_opts = [];
      new_opts.push('<option value="">Select</option>');
      $('li[data-state="'+index+'"] ul li', that.container).each(function() {
        var t = $(this).text();
        new_opts.push('<option value="'+t+'">'+t+'</option>');
      });
      $('#city_s', that.container).html(new_opts.join("\n"));
      $('#city_s', that.container).trigger('change');
      if(new_opts.length <= 1) {
        $('#city_s', that.container).attr('disabled', 'disabled');
        $('#city_s', that.container).parents('.selector').fadeTo(1, 0.8);
      } else {
        $('#city_s', that.container).removeAttr('disabled');
        $('#city_s', that.container).parents('.selector').fadeTo(1, 1);
      }
    }
    $('#state_s', that.container).change(function(e) {
      update_list(e.srcElement.value);
    });
    update_list($('#state_s', that.container).val());
  };
  that.init = function() {
    that.container = $('#search_form');
    if(that.container.length > 0) {
      that.statesList();
    }
  };
  return that;
})();

var gallery = (function() {
  var that = {};
  that.container = null;
  that.main = null;
  that.thumbs = null;
  that.furnishings_visible = false;
  that.furnishings = function() {
    var furnishings_container = $('.main_content .furnishings', that.container);
    furnishings_container.hide();
    furnishings_container.after('<a class="toggle" href="#">standard furnishings +</a>');
    $('.main_content a.toggle').click(function(e) {
      e.preventDefault();
      if(that.furnishings_visible === false) {
        that.furnishings_visible = true;
        furnishings_container.slideDown('fast', function() {
          if(isIE === true) {
            $('li.active a', that.thumbs).trigger('click');
          }
        });
        $(this).text('hide furnishings -');
      } else {
        that.furnishings_visible = false;
        furnishings_container.slideUp('fast');
        $(this).text('standard furnishings +');
      }
    });
  };
  that.buildContent = function(context) {
    var data = {
      source: context.attr('data-source'),
      type: context.attr('data-type')
    };
    var html;
    if(data.type == 'image') {
      html = that.buildImage(data);
    } else if(data.type == 'youtube_video') {
      html = that.buildYoutubeVideo(data);
    }
    that.main.html(html);
  };
  that.buildImage = function(data) {
    return '<img src="'+data.source+'" alt="" />';
  };
  that.buildYoutubeVideo = function(data) {
    return '<iframe src="http://www.youtube.com/embed/'+data.source+'?modestbranding=1&autoplay=1&rel=0" height="427" width="641" frameborder="0" allowfullscreen="true"></iframe>';
  };
  that.clearSiblings = function(source) {
    source.siblings('li').removeClass('active');
  };
  that.setup = function() {
    that.main = $('#main_image');
    that.thumbs = $('.slideshow_thumbs', that.container);
    $('a', that.thumbs).click(function(e) {
      e.preventDefault();
      var parent = $(this).parents('li');
      that.clearSiblings(parent);
      parent.addClass('active');
      that.buildContent($(this));
    });
    that.furnishings();
  };
  that.init = function() {
    that.container = $('#inner_page.gallery');
    if(that.container.length > 0) {
      that.setup();
    }
  };
  return that;
})();

var searchResults = (function() {
  var that = {};
  that.container = null;
  that.map_visible = true;
  that.setupMapActions = function() {
    $('.actions .map a', that.container).click(function(e) {
      e.preventDefault();
      var link = $(this);
      if(GMap) {
        if(that.map_visible === false) {
          that.showMap($('#marquee .toggle_map'));
        }
        scroll_to($('#map_canvas'));
				GMap.triggerMarker(link.attr('data-id'));
      }
    });
    that.mapToggle();
  };
  that.hideMap = function(link, speed) {
    if(!speed) {
      speed = 300;
    }
    that.map_visible = false;
    homeMarquee.container.animate({
      height: 0,
      'margin-bottom': 0
    }, 300);
    link.addClass('closed');
  };
  that.mapToggle = function() {
    if($.cookie('show_map') && $.cookie('show_map') == '0') {
      $('#search_form').hide();
      that.hideMap($('#marquee .toggle_map'), 0);
    }
    $('#marquee .toggle_map').click(function(e) {
      e.preventDefault();
      if(that.map_visible === true) {
        $('#search_form').hide();
        that.hideMap($(this));
        $.cookie('show_map', '0');
      } else {
        $('#search_form').show();
        that.showMap($(this));
        $.cookie('show_map', '1');
      }
    });
  };
  that.showMap = function(link) {
    that.map_visible = true;
    homeMarquee.container.animate({
      height: homeMarquee.height
    }, 300, function() {
      GMap.resize();
    });
    link.removeClass('closed');
  };
  that.init = function() {
    that.container = $('#serp');
    if(that.container.length > 0) {
      that.setupMapActions();
    };
  };
  return that;
})();

var communityFloorplans = (function() {
  var that = {};
  that.active_class = 'floorplan';
  that.container = null;
  that.floorplan_list = null
  that.startPagination = function() {
    that.floorplan_list = $('.'+that.active_class, that.container);
    that.floorplansPage(1); 
  };
  that.floorplansPage = function(index, page) {
    if(!page) {
      page = 1;
    }
    var start = (index - 1) * 8;
    var end = start + 7;
    that.floorplan_list = $('.'+that.active_class, that.container);
    that.container.fadeTo('fast', 0, function() {
      that.floorplan_list.show();
      that.floorplan_list.filter(":lt("+start+"), :gt("+end+")").hide();
      that.container.fadeTo('fast', 1);
    });
    that.floorplanPagination(that.floorplan_list.length, index);
  };
  that.floorplanPagination = function(length, page) {
    if(length > 8) {
      $('.floorplan_pagination').paginate(page, Math.ceil(length / 8), function(newPage) {
        scroll_to($('#community_floorplans'));
        that.floorplansPage(newPage);
      }, {
        nextText: 'next',
        numEntries: length,
        prevText: 'prev',
        showFirst: false,
        showLast: false
      }); 
    } else {
      $('.floorplan_pagination').empty();
    }
  };  
  that.resetActive = function() {
    $('.floorplan', that.container).show();
    $('.floorplan', that.container).not('.'+that.active_class).hide();
    that.startPagination();
  };
  that.setupNav = function() {
    $('#community_floorplans .floorplan_tabs a').click(function(e) {
      e.preventDefault();
      var parent = $(this).parents('li');
      parent.siblings('li').removeClass('active');
      parent.addClass('active');
      that.active_class = $(this).attr('data-class');
      that.resetActive();
    });
  };
  that.init = function() {
    that.container = $('#community_floorplans .floorplans_container');
    if(that.container.length > 0) {
      that.resetActive();
      that.setupNav();
      that.startPagination();
    }
  };
  return that;
})();

$(function() {
  homeMarquee.init();
  mainNav.init();
  newsPanel.init();
  homeSearch.init();
  gallery.init();
  searchResults.init();
  showCommunity.init();
  walkscore.init();
  tumblrPull.init();
  communityFloorplans.init();
  $('.chat a').click(function(e) {
    e.preventDefault();
    $('#habla_beta_container_do_not_rely_on_div_classes_or_names').show();
  })
});
