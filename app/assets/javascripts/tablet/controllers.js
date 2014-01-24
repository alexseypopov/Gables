
$(function(){
  /*** Controllers ***/

  App.floorplansController = Ember.ArrayProxy.create({
    content: floorplans.map(function(f){return App.Floorplan.create(f)}),
    optionObserver: function(){
      var self = this;
      this.set('filteredContent', this.get('content').filter(function(item){
        var available = true;
        if(self.get('showOption') == 'Available'){
          available = false;
          if(item.units.length) available = true;
        }
        return available;
      }))
    }.observes('content','showOption'),
    preferredFloorplans: function(){
      if(App.currentGuest && App.currentGuest.get("preferred_floorplans")){
        return this.get("content").filter(function(item,index){
          return App.currentGuest.get("preferred_floorplans").indexOf(item.id.toString()) != -1;
        });
      }
    },
    setPreferred: function(){
      if(App.currentGuest && App.currentGuest.preferred_floorplans){
        this.get("content").forEach(function(item,index){
          item.set('preferred',App.currentGuest.preferred_floorplans.indexOf(item.id.toString()) != -1)
        });
      }
    }.observes('content','App.currentGuest.preferred_floorplans'),
    contentDidChange: function(){
      App.set("bedOptions", App.filterBedOptions(this.content));
      App.set("bathOptions",App.filterBathOptions(this.content));
    }
  });

  App.unitsController = Ember.ArrayProxy.create({
    content: [],
    url: window.location.pathname + "/units.json",
    populate: function() {
      if(this.content.length == 0){
        var self = this;
        this.set("searching",true);
        jQuery.get(this.get("url"),{token: App.currentUser.get("token")}, function(data) {
          var units = $.map(data, function(item){return App.Unit.create(item)});
          self.set('content', units);
          self.set('allUnits', units);
        }).error(function(xhr,status){
          if(xhr.status == 401) App.tokenExpired();
        }).complete(function(){
          self.set("searching",null);
        });
      };
    },
    updatePreferred: function(){
      if(this.content.length > 0 && App.currentGuest){
        $.each(this.content, function(index,item){
          if(App.currentGuest.get("preferred_floorplans").indexOf(item.id.toString()) != -1)
            item.set("preferred",true);
          else item.set("preferred", false);
        });
        var putype1 = App.currentGuest.get("preferred_unit_type1"),
            putype2 = App.currentGuest.get("preferred_unit_type2");
        if(putype1 || putype2){
          this.get("content").filter(function(item,index,self){
            if(item.units.length > 0 && [putype1,putype2].indexOf(item.units[0].PUTYPE_RecordKey) != -1)
              item.set("preferred",true);
          });
        }
      }
    },
    contentDidChange: function() {
      var leaseTermOption = false;
      this.content.forEach(function(item){
        item.units.forEach(function(unit){
          if(unit.LRO == "Y") leaseTermOption = true;
        });
      });
      this.set('leaseTermOption',leaseTermOption);
      if(this.content.length > 0 && App.get("currentGuest")){
        this.updatePreferred();
      }
      this._super();
    },

    selectedBeds: null,
    selectedBaths: null,
    minRent: 700,
    maxRent: 5000,

    filter: function(){
      var self = this;
      if(this.get("content").length > 0){
        this.set('filtered',this.get("content").filter(function(item,index){
          var beds = true, baths = true, minRent = true, maxRent = true, moveInDate = true, available = true, leaseTerm = true;
          if(self.get("selectedBeds"))
            beds = item.bedrooms_count == self.get("selectedBeds").id;
          if(self.get("selectedBaths"))
            baths = item.bathrooms_count == self.get("selectedBaths").id;
          if(self.get("minRent"))
            minRent = item.rent_min >= self.get("minRent");
          if(self.get("minRent"))
            maxRent = item.rent_max <= self.get("maxRent");
          if(self.get('leaseTerm')){
            leaseTerm = false;
            item.units.forEach(function(item){
              if(item.LRO == 'Y') leaseTerm = true;
            });
          }
          if(self.get('showOption') == 'Available'){
            available = false;
            if(item.units.length) available = true;
            if(App.currentGuest && App.currentGuest.get("move_in_date") && App.stateManager.currentState.name == 'ApartmentPreferencesView'){
              moveInDate = false;
              var move_in_date = new Date(App.currentGuest.get("move_in_date").replace(/-/g,"/"));
              item.units.forEach(function(item,index){
                var date = new Date(item.Available_x0020_Date);
                if(date <= move_in_date) moveInDate = true;
              });
            }
          }
          return beds && baths && minRent && maxRent && moveInDate && available && leaseTerm;
        }));
      }
    }.observes('content','selectedBeds','selectedBaths','minRent','maxRent','showOption','App.currentGuest.move_in_date','leaseTerm'),

    setPreferred: function(){
      if(App.currentGuest && App.currentGuest.preferred_floorplans){
        this.set("preferred",this.get("content").filter(function(item,index){
          return App.currentGuest.preferred_floorplans.indexOf(item.id.toString()) != -1
        }));
      }
    }.observes('content','App.currentGuest.preferred_floorplans')
  });

  App.guestsController = Ember.ArrayProxy.create({
    content: [],
    contentDidChange: function() {
      if(this.content.length > 0){
        App.stateManager.goToState("SelectGuestView");
      }
    }
  });
});
