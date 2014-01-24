$(function(){
  App.User = Ember.Object.extend({
    isAdmin: function(){
      return this.get("admin") == "Y"
    }.property("admin"),
    updatePendingGuests: function(){
      if(App.pendingGuests)
        this.set("pendingGuests",App.pendingGuests.my_guests.content.length);
    }.observes("App.pendingGuests.my_guests")
  });

  App.Guest = Ember.Object.extend({
    name: function(){
      return (this.get('first_name') + ' ' + this.get('last_name')).toLowerCase();
    }.property('first_name', 'last_name'),

    home_area: function(){if(this.get("home_phone")) return this.get("home_phone").slice(0,3) }.property("home_phone"),
    home_exch: function(){if(this.get("home_phone")) return this.get("home_phone").slice(3,6) }.property("home_phone"),
    home_sln: function(){ if(this.get("home_phone")) return this.get("home_phone").slice(6,10)}.property("home_phone"),
    work_area: function(){if(this.get("work_phone")) return this.get("work_phone").slice(0,3) }.property("work_phone"),
    work_exch: function(){if(this.get("work_phone")) return this.get("work_phone").slice(3,6) }.property("work_phone"),
    work_sln: function(){ if(this.get("work_phone")) return this.get("work_phone").slice(6,10)}.property("work_phone"),
    cell_area: function(){if(this.get("cell_phone")) return this.get("cell_phone").slice(0,3) }.property("cell_phone"),
    cell_exch: function(){if(this.get("cell_phone")) return this.get("cell_phone").slice(3,6) }.property("cell_phone"),
    cell_sln: function(){ if(this.get("cell_phone")) return this.get("cell_phone").slice(6,10)}.property("cell_phone"),

    preferredUnitTypeOne: function(){
      return this.preferredUnitType(1);
    }.property('preferred_unit_type1'),

    preferredUnitTypeTwo: function(){
      return this.preferredUnitType(2);
    }.property('preferred_unit_type2'),

    preferredUnitType: function(num){
      var gables_id = this.get("preferred_unit_type" + num);
      if(gables_id){
        var property = App.floorplansController.content.findProperty("gables_id",gables_id);
        if(property) return property.name;
      }
      return "Select One";
    },

    tablet_property_idBinding: "App.property_insite_id",

    no_follow_up_requiredBinding: Ember.Binding.not("follow_up_required"),
    follow_up_requiredBinding: Ember.Binding.not("no_follow_up_required"),

    max_rentBinding: "App.unitsController.maxRent",

    invitationCode: function(){
      return ("00000000" + this.get("insite_id")).slice(-8) + "-" +
             ("00000000" + this.get("unit_id")  ).slice(-8);
    }.property('insite_id','unit_id'),

    set_tablet_not_leasing_reason_id: function(){
      if(App.NotLeasingReasons.reason)
        this.set('tablet_not_leasing_reason_id',App.NotLeasingReasons.reason.id);
    }.observes('App.NotLeasingReasons.reason'),

    sync: function(obj,key,value){
      $.post("/guests/"+this.get("id"),{
          _method:"put",
          key: App.currentUser.get("key"),
          authenticity_token: App.currentUser.authenticity_token,
          guest: this.getProperties(key)
      }, function(resp){
        localStorage.setObject("guest",resp);
      });
    }.observes(
      'guest_names'                , 'preferred_floorplans'       , 'email_optin'                  ,
      'tablet_property_id'         , 'follow_up_required'         , 'follow_up_date'               ,
      'insite_id'                  , 'preferred_unit_type1'       , 'preferred_unit_type2'         ,
      'num_occupants'              , 'move_in_date'               , 'tablet_not_leasing_reason_id' ,
      'community_brochure'         , 'floorplan_brochure'         , 'building_specifications'      ,
      'notes_likes'                , 'notes_dislikes'             , 'notes_remarks'                ,
      'notes_hotbuttons'           , 'guest_card_id'              , 'unit_id'                      ,
      'add_prospect_complete'      , 'select_apartments_complete' , 'gather_licenses_complete'     ,
      'gables_difference_complete' , 'return_licenses_complete'   , 'take_homes_complete'          ,
      'notes_complete'             , 'thank_you_note_complete'    , 'invite_to_apply_complete'     ,
      'max_rent'                   , 'email'
    ),

    preferred_floorplans: []
  });

  App.Unit = Ember.Object.extend({
    updateGuest: function(){
      var pfp = App.currentGuest.get("preferred_floorplans").copy();
      if(this.get("preferred"))
        pfp.pushObject(this.get("id").toString());
      else
        pfp.removeObject(this.get("id").toString());
      pfp = pfp.uniq();
      if(pfp.length != App.currentGuest.get("preferred_floorplans").length)
        App.currentGuest.set("preferred_floorplans", pfp);
    }.observes("preferred")
  });

  App.Floorplan = App.Unit.extend({})

  App.NotLeasingReasons = Ember.ArrayProxy.create({
    content: not_leasing_reasons,
    set_reason: function(){
      if(App.currentGuest)
        this.set('reason',this.get("content").findProperty('id',App.currentGuest.tablet_not_leasing_reason_id));
    }.observes('App.currentGuest.tablet_not_leasing_reason_id')
  });

});
