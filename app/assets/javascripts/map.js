var GMap = (function() {
  var that = {};
  that.map = null;
  that.center = new google.maps.LatLng(33.7856030000,-84.4090570000);
  that.map_type = google.maps.MapTypeId.TERRAIN;
  that.markers = {};
  that.windows = {};
  that.bounds = new google.maps.LatLngBounds();
  that.use_bounds = false;
  that.watch_click = false;
  that.zoom = 10;
  that.addCityMarker = function(opts) {
    that.markers[opts.id] = that.standardMarker(opts);
    var myLatlng = that.markers[opts.id].getPosition();
    google.maps.event.addListener(that.markers[opts.id], "click", function(e) {
      that.windows[opts.id] = new InfoBox({
        data: opts,
        latlng: myLatlng,
        map: that.map,
        type: 'city'
      });
    });
    google.maps.event.trigger(that.markers[opts.id], "click");
    if(that.use_bounds == true) {
      that.bounds.extend(myLatlng);
    }
  };
  that.addCityMarkers = function(data) {
    for(var i in data) {
      if(data[i]) {
        that.addCityMarker(data[i]);
      }
    }
  };
  that.addCommunityMarker = function(opts) {
    if(!that.markers[opts.data.id]) {
      that.markers[opts.data.id] = that.standardMarker(opts);
      var myLatlng = that.markers[opts.data.id].getPosition();
      google.maps.event.addListener(that.markers[opts.data.id], "click", function(e) {
        that.windows[opts.data.id] = new InfoBox({
          data: opts.data,
          latlng: myLatlng,
          map: that.map,
          type: 'community'
        });
      });
      google.maps.event.trigger(that.markers[opts.data.id], "click");
      if(that.use_bounds == true) {
        that.bounds.extend(myLatlng);
      }
    } else {
      console.log('skipped adding duplicate community window to map');
    }
  };
  that.addCommunityMarkers = function(data) {
    for(var i in data) {
      if(data[i]) {
        GMap.addCommunityMarker(data[i]);
      }
    }
  };
  that.finish = function() {
    if(that.use_bounds == true) {
     that.map.fitBounds(that.bounds); 
    }
  };
  that.standardMarker = function(opts) {
    var icon = new google.maps.MarkerImage(
      '/images/map/trans.png',
      new google.maps.Size(1,1),
      new google.maps.Point(0,0),
      new google.maps.Point(0,0)
    );
    var shadow = new google.maps.MarkerImage(
      '/images/map/trans.png',
      new google.maps.Size(1,1),
      new google.maps.Point(0,0),
      new google.maps.Point(0,0)
    );
    var marker = new google.maps.Marker({
      icon: icon,
      position: new google.maps.LatLng(opts.lat,opts.lng),
      map: that.map,
      shadow: shadow
    });
    return marker;
  }
  that.addCenterMarker = function() {
    var icon = new google.maps.MarkerImage(
      '/images/map/gables-searchpin.png',
      new google.maps.Size(52,43),
      new google.maps.Point(0,0),
      new google.maps.Point(10,43)
    );
    var marker = new google.maps.Marker({
      icon: icon,
      position: that.bounds.getCenter(),
      map: that.map
    });
    return marker;
  }
  that.triggerMarker = function(id) {
    if(that.windows[id]) {
      that.map.setCenter(that.markers[id].getPosition());
      if(!$('#info_window_'+id).hasClass('open')) {
        $('#info_window_'+id+' a.expand').trigger('click'); 
      }
    } else {
      console.log('no marker for: '+id);
    }
  };
  that.resize = function() {
    google.maps.event.trigger(that.map, 'resize');
    if(that.use_bounds == true) {
      that.map.fitBounds(that.bounds);
    } else {
      that.map.setCenter(that.center); 
    }
  };
  that.initialize = function() {
	  var latlng = that.center;
    var myOptions = {
      center: latlng,
      navigationControl: true,
      mapTypeControl: false,
      navigationControlOptions: {
        style: google.maps.NavigationControlStyle.LARGE
      },
      mapTypeId: that.map_type,
      panControlOptions: {
        position: google.maps.ControlPosition.LEFT_BOTTOM
      },
      scrollwheel: false,
      zoom: that.zoom,
      zoomControlOptions: {
        style: google.maps.ZoomControlStyle.LARGE,
        position: google.maps.ControlPosition.LEFT_BOTTOM
      }
    };
    that.map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  };
  return that;
})();

function InfoBox(opts) {
  google.maps.OverlayView.call(this);
  this.data_ = opts.data;
  this.type_ = opts.type;
  this.latlng_ = opts.latlng;
  this.map_ = opts.map;
  var me = this;
  this.setMap(this.map_);
}
 
InfoBox.prototype = new google.maps.OverlayView();
 
InfoBox.prototype.draw = function() {
  // Creates the element if it doesn't exist already.
  if(this.type_ == 'community') {
    this.createElement();
    if (!this.div_) return;
 
    var pixPosition = this.getProjection().fromLatLngToDivPixel(this.latlng_);
    if (!pixPosition) return;
 
    // Now position our DIV based on the DIV coordinates of our bounds
    if(this.div_.hasClass('open')) {
      this.div_.css('left', (pixPosition.x + -36) + "px");
      this.div_.css('top', (pixPosition.y + -158) + "px");
    } else {
      this.div_.css('left', (pixPosition.x + -36) + "px");
      this.div_.css('top', (pixPosition.y + -85) + "px");
    }
    this.div_.css('display', 'block'); 
  } else if(this.type_ == 'city') {
    this.createCityElement();
    if (!this.div_) return;
 
    var pixPosition = this.getProjection().fromLatLngToDivPixel(this.latlng_);
    if (!pixPosition) return;
 
    // Now position our DIV based on the DIV coordinates of our bounds
    this.div_.css('left', (pixPosition.x + -38) + "px");
    this.div_.css('top', (pixPosition.y + -38) + "px");
    this.div_.css('display', 'block'); 
  }
};

InfoBox.prototype.createElement = function() {
  var me = this;
  var panes = this.getPanes();
  var div = this.div_;
  var data = this.data_;
  if (!div) {
    div = this.div_ = $('<div class="map_info_window" id="info_window_'+data.id+'">'
      +'<a href="#" class="expand">Expand</a>'
      +'<div class="info_window_content">'
        +'<div class="thumb"><img src="'+data.image+'" title="'+data.title+'" /></div>'
        +'<div class="info_window_data">'
          +'<p class="title">'+data.title+'</p>'
          +'<p class="desc">'+data.floorplan_count+' Available Floorplans</p>'
          +'<a href="'+data.link+'" class="view">View Community</a>'
        +'</div>'
      +'</div>'
    +'</div>');
    $('a.expand, .thumb', div).click(function(e) {
      e.preventDefault();
      var pixPosition = me.getProjection().fromLatLngToDivPixel(me.latlng_);
      div.toggleClass('open');
      if(div.hasClass('open')) {
        div.css('top', (pixPosition.y + -158) + "px");
        div.css('z-index', 20);
        setTimeout(function() {
          $('.info_window_data', div).show('slide', {direction: 'left'}, 300);
        }, 100);
      } else {
        div.css('top', (pixPosition.y + -85) + "px");
        div.css('z-index', 10);
        $('.info_window_data', div).hide();
      }
    });

    div.css('display', 'none');
    $(panes.floatPane).append(div);
  }
}

InfoBox.prototype.createCityElement = function() {
  var me = this;
  var panes = this.getPanes();
  var div = this.div_;
  var data = this.data_;
  if (!div) {
    div = this.div_ = $('<div class="map_city_window">'
      +'<a href="/find/where?query='+data.name+'">'+data.name+'</a>'
      +'<div class="arrow">arrow</div>'
    +'</div>');
    div.css('display', 'none');
    $(panes.floatPane).append(div);
  }
};
