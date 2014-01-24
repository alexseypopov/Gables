//= require jquery
//= require jquery-ui.min
//= require modernizr
//= require jquery.hint
//= require jquery.cookie
//= require jquery.json.js
//= require jquery.carousel
//= require jquery.cycle
//= require jquery.paginate
//= require jquery.uniform
//= require jquery.fancybox.pack
//= require liquidmetal
//= require common


var click = window.Touch ? "touchend" : "click";

var mainNav = (function() {
  var that = {};
  that.container = null;
  that.liveSearch = function() {
    var current_value = '';
    var list_container = $('#live_search');
    var KEY_UP = 38,
        KEY_DOWN = 40,
        KEY_ENTER = 13,
        KEY_ESC = 27,
        KEY_F4 = 115;
        selected_index = -1;
    $('li', list_container).live(click, function(e) {
      e.preventDefault();
      var current_value = $(this).text();
      $('#query').val(current_value);
      $('li', list_container).removeClass('focus');
      $('#query').focus();
      selected_index = -1;
      list_container.hide();
      $('#apartment_search, #apartment_search_results_form').trigger('submit');
    });
    list_container.show();
    $('#query').bind('keyup change', function(e) {
      var val = $('#query').val();
      if(val != current_value && val.length > 1 && e.which != KEY_ENTER) {
        //current_value = val.toLowerCase();
        $('li', list_container).hide();
        $('li', list_container).each(function() {
          var score = LiquidMetal.score($(this).text(),  val);
          if(score > 0.5) {
            $(this).show();
          }
        });
        list_container.show();
      }
    });
    if(list_container.hasClass('did_you_mean')) {
      current_value = list_container.attr('data-query');
      if(current_value != '') {
        $('li', list_container).removeClass('focus');
        $('li', list_container).each(function() {
          var score = LiquidMetal.score($(this).text(),  current_value);
          if(score > 0.8) {
            $(this).show();
          }
        });
      }
    }
    
    function change_selection() {
      $('li', list_container).removeClass('focus');
      $('li:visible:eq('+selected_index+')', list_container).addClass('focus');
    } 
    function close_list() {
      $('li', list_container).hide();
      $('li', list_container).removeClass('focus');
    }
    
    $('#query').bind('keydown', function(e) {
      switch(e.which) {
        case KEY_ESC:
        	close_list();
        	break;
        case KEY_UP:
          selected_index--;
          if(selected_index < -1) {
            selected_index = -1;
          } else {
            change_selection(); 
          }
        	break;
        case KEY_DOWN:
          selected_index++;
          change_selection();
        	break;
        case KEY_ENTER:
        	if(selected_index > -1) {
        	  var selected_li = $('li.focus:visible');
        	  if(selected_li.length > 0) {
        	    e.preventDefault();
              selected_li.trigger('click');
              selected_index = -1;
            } else {
              e.preventDefault();
              close_list();
              selected_index = -1;
            } 
          }
          break;
        default:
        	break;
  		}
    })
  };
  that.clearSiblings = function() {
    $('li.top_level', that.container).removeClass('active');
  };
  that.closePanel = function(context) {
    $('.sub_nav', context).slideUp(100, function() {
      context.removeClass('active');
      $('.sub_nav', context).attr('style', '');
    });
  };
  that.closeToggle = function() {
    var button = '<a href="#" class="close_panel">close</a>';
    $('#main_nav .sub_nav').not('.not_search').each(function() {
      $(this).append(button);
      $('a.close_panel', this).live('click', function(e) {
        e.preventDefault();
        that.closePanel($(this).parents('.sub_nav').parents('li.top_level'));
      });
    })
  };
  that.openPanel = function(link) {
    var container = $(link).parents('li.top_level');
    if(container.hasClass('active')) {
      that.closePanel(container);
    } else {
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
    }
    $('#state', that.container).change(function(e) {
      update_list(e.srcElement.value);
    });
    var update_city = function(e) {
      var val = $(this).val();
      if(val != '') {
        var url = '/find/where?utf8=%E2%9C%93&state='+$('#state', that.container).val()+'&city='+$('#city', that.container).val();
        window.location = url; 
      }
    };
    update_list($('#state', that.container).val());
    var params = searchResults.convertToObj();
    if(params.city && params.city != '') {
      $('#city option[value="'+params.city+'"]', that.container).attr('selected', 'selected');
      $('#city', that.container).trigger('change');
      $('#city', that.container).change(update_city); 
    } else {
      $('#city', that.container).change(update_city); 
    }
  };
  that.init = function() {
    that.container = $('#main_nav');
    $('li.top_level > a', that.container).bind(click,function(e) {
      e.preventDefault();
      that.openPanel(this);
    });
    if($('.states_list', that.container).length > 0) {
      that.statesList();
    }
    that.closeToggle();
    that.liveSearch();
  };
  return that;
})();

var simpleSearch = (function() {
  var that = {};
  that.container = null;
  that.setupForm = function() {
    $('.advanced', that.container).hide();
    $('.simple .submit', that.container).append('<a href="#" class="toggle">toggle form</a>');
    $(that.container).prepend('<div class="nav_border"></div>');
    $('.simple .submit a', that.container).click(function(e) {
      e.preventDefault();
      $(e.srcElement).toggleClass('open');
      var first = '.nav_border';
      var second = '.advanced';
      if(!$(e.srcElement).hasClass('open')) {
        var first = '.advanced';
        var second = '.nav_border';
      }
      $('fieldset', that.container).toggleClass('focus');
      $(first, that.container).slideToggle(100, function() {
        $(second, that.container).slideToggle(100);
      });
    });
  };
  that.init = function() {
    that.container = $('#apartment_search');
    if(that.container.length > 0) {
      that.setupForm();
    }
  }
  return that;
})();

var searchResults = (function() {
  var that = {};
  that.container = null;
  that.map_visible = true;
  that.comparisons = $.cookie('comparisons') ? $.evalJSON($.cookie('comparisons')) : {
    communities: {},
    units: {}
  };
  that.comparisons_count = 0;
  that.marquee_margin = 0;
  that.convertToObj = function() {
    var url = window.location.toString();
    url.match(/\?(.+)$/);
    var params = RegExp.$1;
    var params = params.split("&");
    var queryStringList = {};
    for(var i=0;i<params.length;i++) {
      var tmp = params[i].split("=");
      queryStringList[tmp[0]] = unescape(tmp[1]);
    }
    return queryStringList;
  };
  that.convertToQuery = function(obj) {
    var pieces = [];
    for(var i in obj) {
      if(obj[i]) {
        if(typeof obj[i] == 'string' || typeof obj[i] == 'number') {
          pieces.push(i+"="+obj[i]);  
        } else if(typeof obj[i] == 'object') {
          var a;
          for(a in obj[i]) {
            if(obj[i][a]) {
              pieces.push(i+"[]="+obj[i][a]); 
            }
          }
        }
      }
    }
    return "?"+pieces.join('&');
  };
  that.rebuildUrl = function(new_params) {
    new_params.utf8 = '%E2%9C%93';
    new_params.page = '1';
    var queryStringList = that.convertToObj();
    for(var z in new_params) {
      if(new_params[z]) {
        queryStringList[z] = new_params[z];
      }
    }
    return that.convertToQuery(queryStringList);
  };
  that.setupComparisonActions = function() {
    var comparison_list = $('.comparisons .list ul', that.container);
    //Input change event listener
    $('.community_result .compare input[type=checkbox], table input[type=checkbox]', that.container).live('change', function(e) {
      var id = $(this).attr('value');
      var title = $(this).attr('title');
      var isCommunity = $(this).hasClass('community');
      if($(this).is(':checked')) {
        if(that.comparisons_count >= 5) {
          alert('Please limit the number of comparisons to 5.');
          $(this).removeAttr('checked');
        } else {
          comparison_list.append('<li id="comparing_'+id+'">'+title+'</li>');
          if(isCommunity) {
            that.comparisons.communities[id] = id;
          } else {
            that.comparisons.units[id] = id;
          }
          that.comparisons_count++; 
        }
      } else {
        $('#comparing_'+id).remove();
        if(isCommunity) {
          delete that.comparisons.communities[id];
        } else {
          delete that.comparisons.units[id];
        }
        that.comparisons_count--;
      }
      $.cookie('comparisons', $.toJSON(that.comparisons));
    });
    //Check current community selections in cookie
    for(var y in that.comparisons.communities) {
      if(that.comparisons.communities[y]) {
        $('input.community[value='+that.comparisons.communities[y]+']', that.container).trigger('click');
        that.comparisons_count++;
      }
    }
    //Check current unit selections
    for(var z in that.comparisons.units) {
      if(that.comparisons.units[z]) {
        $('input.unit[value='+that.comparisons.units[z]+']', that.container).trigger('click');
        that.comparisons_count++;
      }
    }
    //Send to comparisons page if number of comparisons is between 1 and 5
    $('.comparisons .submit button', that.container).click(function(e) {
      e.preventDefault();
      if(that.comparisons_count <= 0) {
        alert('Please select communities and units to compare.');
      } else if(that.comparisons_count >=6) {
        alert('Please limit the number of comparisons to 5.');
      } else {
        window.location = '/find/comparison'; 
      }
    });
  };
  that.setupFilterActions = function() {
    $('.filters .grouping select', that.container).change(function(e) {
      var url = '/find/where'+that.rebuildUrl({group: $(this).val()});
      window.location = url;
    });
    $('.filters .ordering select', that.container).change(function(e) {
      var url = '/find/where'+that.rebuildUrl({order: $(this).val()});
      window.location = url;
    });
  };
  that.setupFloorplanActions = function() {
    $('.community_result .floorplans', that.container).hide();
    $('.community_result .summary', that.container).append('<a href="#" class="toggle">view floorplans +</a>');
    $('.community_result .summary a.toggle', that.container).live('click', function(e) {
      e.preventDefault();
      var link = $(this);
      var floorplans = link.parents('.summary').siblings('.floorplans');
      var toggle = function() {
        if(floorplans.is(':visible')) {
          link.text('view floorplans +');
          floorplans.slideUp('fast');
        } else {
          link.text('hide floorplans -');
          floorplans.slideDown('fast', function() {
            if(isIE === true) {
              var checker = floorplans.siblings('.actions').find('input[type=checkbox]');
              checker.trigger('click');
              checker.trigger('click'); 
            }
          });
        }
      }
      if(floorplans.is(':empty')) {
        link.addClass('loading');
        var params = that.convertToObj();
        params.property_id = floorplans.parents('.community_result').attr('id').replace('property_', '');
        $.get('/find/floorplans_serp'+that.rebuildUrl(params), function(data) {
          floorplans.html(data);
          toggle();
          link.removeClass('loading');
        });
      } else {
        toggle();
      }
    });
    
    $('.floorplan_result .thumb a', that.container).fancybox({
      type: 'image'
    });
  };
  that.setupMapActions = function() {
    homeMarquee.determineSize();
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
      that.hideMap($('#marquee .toggle_map'), 0);
    }
    $('#marquee .toggle_map').click(function(e) {
      e.preventDefault();
      if(that.map_visible === true) {
        that.hideMap($(this));
        $.cookie('show_map', '0');
      } else {
        that.showMap($(this));
        $.cookie('show_map', '1');
      }
    });
  };
  that.showMap = function(link) {
    that.map_visible = true;
    homeMarquee.container.animate({
      height: homeMarquee.height,
      'margin-bottom': that.marquee_margin
    }, 300, function() {
      GMap.resize();
    });
    link.removeClass('closed');
  };
  that.init = function() {
    that.container = $('#serp');
    if(that.container.length > 0) {
      that.setupMapActions();
      that.setupFloorplanActions();
      that.setupComparisonActions();
      that.setupFilterActions();
      $('select.multiselect').multiselect();
    };
  };
  return that;
})();

var comparisonResults = (function() {
  var that = {};
  that.comparisons = $.evalJSON($.cookie('comparisons'));
  that.container = null;
  that.marquee_margin = 0;
  that.filterActions = function() {
    $('.options a', that.container).click(function(e) {
      e.preventDefault();
      var set = $(this).attr('rel');
      var cells = $('tr.details, tr.features, tr.amenities');
      cells.show();
      if(set != 'all') {
        cells.not('.'+set).hide();
      }
      var li = $(this).parents('li');
      li.siblings('li').removeClass('active');
      li.addClass('active');
    });
  };
  that.makeColumn = function() {
    var column = $('<div class="tr"><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td details">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td amenities">&nbsp;</div><div class="td links">&nbsp;</div></div>');
    return column;
  };
  that.populateColumns = function() {
    $('table tr', that.container).each(function() {
      var row = $(this);
      if($('td', row).length <=4) {
        var remainder = 5-$('td', row).length;
        for(var i = 1; i <= remainder; i++) {
          row.append('<td></td>');
        }
      }
    });
  };
  that.removeActions = function() {
    $('.item a.remove', that.container).click(function(e) {
      e.preventDefault();
      var parent = $(this).parents('.item');
      var id = parent.attr('id').replace(/unit_|property_/g, '');
      var isCommunity = parent.hasClass('property');
      parent.remove();
      $('table tbody td[data-id='+$(this).attr('data-id')+']').remove();
      that.populateColumns();
      
      if(isCommunity) {
        delete that.comparisons.communities[id];
      } else {
        delete that.comparisons.units[id];
      }
      $.cookie('comparisons', $.toJSON(that.comparisons));
    });
  };
  that.init = function() {
    that.container = $("#comparison_results");
    if(that.container.length > 0) {
      that.filterActions();
      that.removeActions();
      that.populateColumns();
      searchResults.mapToggle();
      $('.summary a', that.container).click(function(e) {
        e.preventDefault();
        history.go(-1);
      });
    }
  };
  return that;
})();

var slider = (function() {
  var that = {};
  that.container = null;
  that.init = function() {
    that.container = $('#life_marquee .slider');
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

var communityContacts = (function() {
  var that = {};
  that.container = null;
  that.init = function() {
    that.container = $('#community_contacts');
    if(that.container.length > 0) {
      $('.top_level:first-child', that.container).addClass('active');
      $('.top_level > a', that.container).click(function(e) {
        e.preventDefault();
        var li = $(this).parents('li.top_level');
        li.siblings('li').removeClass('active');
        li.siblings('li').children('.properties').hide();
        $(this).siblings('.properties').show('slide', {direction: 'left'}, 300, function() {
          li.addClass('active');
        });
      })
    }
  };
  return that;
})();

$(function() {
  mainNav.init();
  simpleSearch.init();
  homeMarquee.init();
  newsPanel.init();
  searchResults.init();
  comparisonResults.init();
  showCommunity.init();
  slider.init();
  tumblrPull.init();
  if($('.full_width .associate_slider').length > 0) {
    $('.full_width .associate_slider').jcarousel({
			wrap: 'none',
      scroll: 4
    });
  }
  walkscore.init();
  communityContacts.init();
});

(function($) {
  $.multiselect = function(select) { this.init(select); };
  
  $.extend($.multiselect.prototype, {
    input: null,
    list: null,
    parent: null,
    results: null,
    select: null,
    init: function(select) {
      this.select = $(select);
      this.parent = this.select.parents('div.input');
      this.input = $('<input type="text" name="multi_'+this.select.attr('id')+'" autocomplete="off" placeholder="Search" />');
      this.wrapper = $('<div class="multi_wrapper"></div>');

      var li = [];
      var current = [];
      $('option', this.select).each(function() {
        li.push('<li>'+$(this).text()+'</li>');
        if($(this).is(':selected')) {
          current.push('<li onclick="javascript: $(this).remove();">'+$(this).text()+'</li>');
        }
      });

      this.results = $('<div class="multi_search"><ul>'+li.join('')+'</ul></div>');
      this.list = $('<ul class="multi_list">'+current.join('')+'</ul>');
      this.parent.append(this.list);
      this.parent.append(this.wrapper);
      this.wrapper.append(this.input);
      this.wrapper.append(this.results);
      this.parent.addClass('multiselect_parent');
      this.liveSearch();
      this.showAll();
      this.submitClean();
    },
    showAll: function() {
      var input = this.input;
      var list = this.results;
      input.focus(function() {
        if($(this).val() == '') {
          list.show();
          $('li', list).show();
        }
      });
      var parent = this.parent;
      $('body').click(function(e) {
        if(!$(e.target).closest('div.input').length) {
          list.hide();
          $('li', list).hide();
        }
      });
      // input.blur(function(e) {
      //         //list.hide();
      //         //$('li', list).hide();
      //       });
    },
    submitClean: function() {
      var form = this.select.parents('form');
      var input = this.input;
      var select = this.select;
      var list = this.list;
      form.submit(function(e) {
        $('option:selected', select).removeAttr('selected');
        $('li', list).each(function() {
          $('option[value="'+$(this).text()+'"]', select).attr('selected', 'selected');
        });
        input.attr('disabled', 'disabled');
      });
    },
    liveSearch: function() {
      var current_value = '',
          KEY_UP = 38,
          KEY_DOWN = 40,
          KEY_ENTER = 13,
          KEY_ESC = 27,
          KEY_F4 = 115,
          list_container = this.results,
          query_container = this.input,
          selected_container = this.list,
          selected_index = -1;

      $('li', list_container).bind(click,function(e) {
        e.preventDefault();
        query_container.val('');
        $('li', list_container).removeClass('focus');
        query_container.focus();
        selected_container.append('<li onclick="javascript: $(this).remove();">'+$(this).text()+'</li>');
        //list_container.hide();
      });
      list_container.show();
      query_container.bind('keyup change', function(e) {
        var val = query_container.val();
        if(val != current_value && val.length > 1) {
          current_value = val.toLowerCase();
          $('li', list_container).hide();
          $('li', list_container).each(function() {
            var score = LiquidMetal.score($(this).text(),  val);
            if(score > 0.6) {
              $(this).show();
            }
          });
          selected_index = -1;
          list_container.show();
        }
      });

      function change_selection() {
        $('li', list_container).removeClass('focus');
        $('li:visible:eq('+selected_index+')', list_container).addClass('focus');
      } 
      function close_list() {
        $('li', list_container).hide();
        $('li', list_container).removeClass('focus');
      }
    
      query_container.bind('keydown', function(e) {
        switch(e.which) {
    			case KEY_ESC:
    				close_list();
    				break;
    			case KEY_UP:
    			  selected_index--;
    			  if(selected_index < -1) {
    			    selected_index = -1;
    			  } else {
    			    change_selection(); 
    			  }
    				break;
    			case KEY_DOWN:
    			  selected_index++;
    			  change_selection();
    				break;
    			case KEY_ENTER:
    			  e.preventDefault();
    				if(selected_index > -1) {
    				  var selected_li = $('li:visible:eq('+selected_index+')', list_container);
    				  if(selected_li.length > 0) {
      				  selected_li.trigger('click');
      				  selected_index = -1;
      				} else {
      				  close_list();
      				  selected_index = -1;
      				} 
    				}
    				break;
    			default:
    				break;
    		}
      })
    }
  });
  
  $.fn.multiselect = function() {
    this.each(function() {
      if (this.tagName == "SELECT") new $.multiselect(this);
    });
    return this;
  };
})(jQuery);

$(function(){
  $(".office-hours").bind(click, function(){
    var oh = $("#grouped-office-hours");
    if(oh.is(":hidden")){ oh.slideDown(500); }
    else { oh.slideUp(500); }
    $(this).toggleClass("open");
  });

  $("#toggle-share").bind(click, function(e){
    e.preventDefault();
    var sl = $("#share-icons");
    if(sl.is(":hidden")){ sl.slideDown(0); }
    else { sl.slideUp(0); }
    sl.toggleClass("open");
    sl.click(function(e) { sl.slideUp(0).removeClass("open"); });
  });

  $("#chat84152841,#chat84152841 img").bind(click, function(e){
    e.preventDefault();
    var property = this.getAttribute("data-property");
    lpButtonCTTUrl = "http://server.iad.liveperson.net/hc/84152841/?cmd=file&file=visitorWantsToChat&site=84152841&SESSIONVAR!skill=Gables&SESSIONVAR!Management%20Company=Gables%20Residential&SESSIONVAR!Community="+property+"&SESSIONVAR!Ad%20Source=Gables.com&imageUrl=http://gables.com/images/&referrer="+escape(document.location);
    lpButtonCTTUrl = (typeof(lpAppendVisitorCookies) != 'undefined' ? lpAppendVisitorCookies(lpButtonCTTUrl) : lpButtonCTTUrl);
    lpButtonCTTUrl = ((typeof(lpMTag)!='undefined' && typeof(lpMTag.addFirstPartyCookies)!='undefined') ? lpMTag.addFirstPartyCookies(lpButtonCTTUrl) : lpButtonCTTUrl);
    window.open(lpButtonCTTUrl,'chat84152841','width=475,height=400,resizable=yes');
    _gaq.push(['_trackPageview', '/open_chat']);
  });
/*
  $.get("/language", function(resp){
    if(resp.match("es")){
      $.getScript("//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit",function(){
        setTimeout(function(){
          new google.translate.TranslateElement({
            pageLanguage: 'en',
            includedLanguages: 'es',
            autoDisplay: false,
            floatPosition: google.translate.TranslateElement.FloatPosition.BOTTOM_RIGHT
          });
        },1000);
      });
    }
  });
*/ 
});
