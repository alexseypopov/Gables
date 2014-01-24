var click = window.Touch ? "touchend" : "click";

$(function(){
  /*** Views ***/

  Ember.View.reopen({
    goBack: function(v,e,c){
      App.stateManager.goBack();
    }
  });

  App.HeaderView = Ember.View.extend({
    templateName: "header",
    toggleMenu: function(v,e,c){
      v.$("#nav-user,#nav-guest").find(".pop").hide();
      if($(e.target).parents(".pop").length == 0 && !$(e.target).hasClass("pop"))
        $(e.target).parents("#nav-user,#nav-guest").find(".pop").toggle();
    },
    showGuestMenu: function(){
      setTimeout(function(){this.$("#nav-guest").find(".pop").toggle()},100);
    },
    goHome: function(v,e,c){
      App.stateManager.goToState("PhotosView");
    },
    toggleLogin: function(v,e,c){
      $("#login-form").toggle();
    }
  }).create().replaceIn("header");

  App.PhotosView = Ember.View.extend({
    templateName: "photos",
    didInsertElement: function(){
      this.set("gallery",App.photoSwipeView());
    },
    prev: function(v,e,c){
      if((window.Touch && e.type == "touchend") ||
         (!window.Touch && e.type == "click")){
        this.gallery.resetTimeout();
        this.gallery.prev();
      }
    },
    next: function(v,e,c){
      if((window.Touch && e.type == "touchend") ||
         (!window.Touch && e.type == "click")){
        this.gallery.resetTimeout();
        this.gallery.next();
      }
    },
    remove: function(){
      this.gallery.destroyAll();
      this._super();
    }
  });

  App.SitePlansView = Ember.View.extend({
    templateName: "site-plans",
    mapsterOptions: {
      singleSelect: true,
      fill: false,
      stroke: true,
      strokeColor: 'ff0000',
      strokeOpacity: 1,
      strokeWidth: 4,
      onConfigured: function(status){},
      onClick: function(data){
        if(this.getAttribute('href')){
          var property = App.floorplansController.content.findProperty("gables_id",this.getAttribute('href')),
              view = App.stateManager.currentState.view;
          if(property) {
            if(view.get('currentModal')) view.get('currentModal').remove();
            view.set('currentModal',
              App.FloorplanModalView.create({
                floorplans: [property],
                removeOverlay: true,
                map: data
              }).appendTo(App.stateManager.currentState.view.$())
            );
          }
        }
        data.e.preventDefault();
      }
    },
    didInsertElement: function(){
      if(App.site_plans.length > 0){
        this.set('mainImage',App.site_plans[0].image.url);
        this.$('#siteplan-nav li:first a img').click();
        this.$('#instructions').show();
      };
      if(window.Touch)
        var myScroll = new iScroll('siteplan-images', { zoom: true, zoomMin:0.3 });
    },
    showMenu: function(){
      return App.site_plans.length > 1;
    }.property("App.site_plans"),
    select: function(v,e,c){
      this.set("mainImage",$(e.target).attr("data-src"));
      this.set('mapName', '#' + $(e.target).parents('li').find('map').attr('name'));
      this.$('#siteplan-images img').load(function(){$(this).mapster(v.mapsterOptions)});
      this.$("#siteplan-nav li").removeClass("selected");
      $(e.target).parents("li").addClass("selected");
    },
    showInstructions: function(){
      var bool = false;
      App.site_plans.forEach(function(item){
        if(item.image_map) bool = true;
      });
      return bool;
    }.property('App.site_plans'),
    click: function(){
      this.$('#instructions').hide();
    }
  });

  App.LifeAtGablesView = Ember.View.extend({
    templateName: "life-at-gables",
    classNames: ["life-at-gables"],
    click: function(e){
      if($(e.target).parents("nav#life").length == 0){
        $("#life").removeClass("show");
      }
      if(e.target.tagName == "A" && $(e.target).parents("nav#life").length > 0){
        $("#life li.active").removeClass("active");
        $(e.target).parent().addClass("active");
        this.toggleMenu();
      }
    },
    didInsertElement: function(){
      $('#life li a').anchorScroll('#primary');
    },
    toggleMenu: function(v,e,c){
      $("#life").toggleClass("show");
      return false;
    },
    viewBrochure: function(v,e,c){
      var target = e.target;
      if(e.target.tagName == "SPAN") target = e.target.parentElement;
      var source = target.getAttribute("data-source");
      if(!window.Touch){
        e.preventDefault();
        App.IframeModalView.create({
          title: target.getAttribute("data-type"),
          source: source
        }).appendTo(App.stateManager.currentState.view.$())
      } else {
        window.open(source);
      }
    },
    emailPDF: function(v,e,c){
      var target = e.target;
      if(e.target.tagName == "SPAN") target = e.target.parentElement;
      App.EmailPdfModalView.create({
        type: target.getAttribute("data-type")
      }).appendTo(App.stateManager.currentState.view.$())
    }
  });

  App.AreaMapView = Ember.View.extend({
    classNames: ["area-map"],
    templateName: "area-map"
  });

  App.IframeModalView = Ember.View.extend({
    classNames: ["modal-wrapper","iframe"],
    templateName: "iframe-modal",
    close: function(v,e,c){
      v.remove();
    }
  });

  App.ErrorMessageModalView = Ember.View.extend({
    classNames: ["modal-wrapper"],
    templateName: "error-messages-modal",
    didInsertElement: function(){
      this.$('button').focus();
    },
    close: function(v,e,c){
      v.remove();
    }
  });

  App.EmailPdfModalView = Ember.View.extend({
    classNames: ["modal-wrapper"],
    templateName: "email-modal",
    floorplanPdf: function(){return this.get('type') == 'Floorplan'}.property('name'),
    sendBrochure: function(v,e,c){
      if(v.$("#email-form").valid()){
        $.post(window.location.pathname + "/email_brochure", {
          type:  this.get("type"),
          email: this.get("emailAddress")
        }, function(resp){
          v.remove();
        });
      };
    },
    sendFloorplanPdf: function(v,e,c){
      if(v.$("#email-form").valid()){
        $('#print-only img').each(function(idx,item){
          item.setAttribute('src',item.src);
        }); //make src absolute path
        $.post(window.location.pathname + "/email_pdf", {
          name: v.get('name'),
          html:  $('#print-only').html(),
          email: this.get("emailAddress")
        }, function(resp){
          v.remove();
        });
      };
    },
    didInsertElement: function(){
      this.$("#email-form input").attr("name","email");
      this.$("#email-form").validate({rules: {email: {required: true, email: true}}});
    },
    close: function(v,e,c){
      v.remove();
    }
  });

  App.CommunityNavView = Ember.View.extend({
    templateName: "community-nav",
    isPhotos: function(){ return "PhotosView" == App.stateManager.currentState.name }.property(),
    isLife:   function(){ return "LifeAtGablesView" == App.stateManager.currentState.name }.property(),
    isSite:   function(){ return "SitePlansView" == App.stateManager.currentState.name }.property(),
    isArea:   function(){ return "AreaMapView" == App.stateManager.currentState.name }.property(),
    isFloorplans: function(){ return "FloorplansView" == App.stateManager.currentState.name }.property(),
    communityPhotos: function(v,e,c){ App.stateManager.goToState("PhotosView"); },
    floorplans:      function(v,e,c){ App.stateManager.goToState("FloorplansView"); },
    lifeAtGables:    function(v,e,c){ App.stateManager.goToState("LifeAtGablesView"); },
    sitePlans:       function(v,e,c){ App.stateManager.goToState("SitePlansView"); },
    areaMap:         function(v,e,c){ App.stateManager.goToState("AreaMapView"); }
  });

  App.CommunityNavView.create().appendTo("#home");

  App.AssociateMenuView = Ember.View.extend({
    templateName: "associate-menu",
    click: App.closeMenu,
    findGuest: function(v,e,c){
      App.set("currentGuest",null);
      App.stateManager.goToState("FindGuestView");
    },
    pendingGuests: function(v,e,c){ App.stateManager.goToState("PendingGuestsView"); },
    nearbyCommunities: function(v,e,c){ App.stateManager.goToState("NearbyCommunitiesView"); },
    availableUnits: function(v,e,c){ App.stateManager.goToState("AvailableUnitsView"); },
    availableOptions: function(v,e,c){ App.stateManager.goToState("AvailableOptionsView"); },
    sorPolicy: function(v,e,c){
      var source = e.target.getAttribute("data-source");
      if(!window.Touch){
        e.preventDefault();
        App.IframeModalView.create({
          title: "SOR Policy",
          source: source
        }).appendTo(App.stateManager.currentState.view.$())
      } else {
        window.open(source);
      }
    },
    leaseBriefs: function(v,e,c){
      var source = e.target.getAttribute("data-source");
      if(!window.Touch){
        e.preventDefault();
        App.IframeModalView.create({
          title: "Lease Briefs",
          source: source
        }).appendTo(App.stateManager.currentState.view.$())
      } else {
        window.open(source);
      }
    },
    logout: function(e){
      App.set("currentUser",null);
      App.set("currentGuest",null);
      localStorage.removeItem("user");
      localStorage.removeItem("guest");
      $("body").removeClass("logged-in");
      App.stateManager.goToState("PhotosView");
    }
  });

  App.FloorplansView = Ember.View.extend({
    classNames: ['floorplans-page'],
    templateName: "floorplans",
    selectedBedsBinding: "App.floorplansController.selectedBeds",
    selectedBathsBinding: "App.floorplansController.selectedBaths",
    contentBinding: "App.floorplansController.content",
    filter: function(obj,key,value) {
      var self = this;
      var filtered = this.get("content").filter(function(item,index){
        var beds = true, baths = true;
        if(self.get("selectedBeds"))
          var beds = item.bedrooms_count == self.get("selectedBeds").id;
        if(self.get("selectedBaths"))
          var baths = item.bathrooms_count == self.get("selectedBaths").id;
        return beds && baths;
      });
      if(filtered.length > 0){
        this.get("gallery").destroy();
        $("#floorplans-wrapper, #floorplans-nav .dot-nav").empty();
        this.set("gallery",swipeView(filtered,"#floorplans-wrapper","#floorplans-nav"));

        if(key == "selectedBaths"){
          var bedOptions = App.filterBedOptions(filtered);
          App.bedOptions.forEach(function(item){ item.set("disabled",true); });
          bedOptions.forEach(function(item){
            App.bedOptions.findProperty("id",item.id).set("disabled",false);
          });
        }
        if(key == "selectedBeds") {
          var bathOptions = App.filterBathOptions(filtered);
          App.bathOptions.forEach(function(item){ item.set("disabled",true); });
          bathOptions.forEach(function(item){
            App.bathOptions.findProperty("id",item.id).set("disabled",false);
          });
        }
      };
    }.observes('selectedBeds','selectedBaths'),
    prev: function(v,e,c){
      if((window.Touch && e.type == "touchend") ||
         (!window.Touch && e.type == "click")) this.gallery.prev();
    },
    next: function(v,e,c){
      if((window.Touch && e.type == "touchend") ||
         (!window.Touch && e.type == "click")) this.gallery.next();
    },
    didInsertElement: function(){
      App.floorplansController.set("selectedBeds",null);
      App.floorplansController.set("selectedBaths",null);
      this.set("gallery",swipeView(this.get("content"),"#floorplans-wrapper","#floorplans-nav"));
    }
  });

  App.FloorplanModalView = Ember.View.extend({
    templateName: "floorplan-modal",
    classNames: ["modal-wrapper"],
    classNameBindings: ['removeOverlay'],
    removeOverlay: false,
    print: function(v,e,c){
      App.printFloorplan(c, function(){window.print()});
    },
    email: function(v,e,c){
      App.printFloorplan(c, function(){
        App.EmailPdfModalView.create({
          type: 'Floorplan',
          name: c.name
        }).appendTo(App.stateManager.currentState.view.$())
      });
    },
    mark: function(v,e,c){
      var id = $(e.target).siblings("input").val();
      App.currentGuest.set("preferred_unit_type" + v.preference[0],id)
      v.remove();
    },
    close: function(v,e,c){
      v.remove();
      if(v.get('map')) $('area').mapster('set',false);
    }
  });

  App.FloorplanView = Ember.View.extend({
    templateName: "floorplan",
    classNames: ["floorplan","group"],
    floorplansBinding: "App.floorplansController",
    didInsertElement: function(){
      if(!this.currentPage) this.$("select").prop("disabled",true);
    },
    loadUnits: function(view, event, context){
      if(App.currentUser){
        App.stateManager.goToState("AvailableUnitsView");
        App.unitsController.populate()
      } else {
        App.stateManager.goToState("VaultwareUnitsView");
      }
    }
  });

  App.PrintFloorplanView = Ember.View.extend({
    templateName: "print-floorplan",
  })

  App.AvailableUnitsView = Ember.View.extend({
    templateName: "available-units",
    classNames: ["available-units"],
    refresh: function(){
      $.post(window.location.pathname + "/units/expire", function(resp){
        App.unitsController.set("content",[]);
        App.unitsController.populate();
      });
    },
    didInsertElement: function(){
      App.unitsController.set("selectedBeds",null);
      App.unitsController.set("selectedBaths",null);
      App.unitsController.populate();
    }
  });

  App.UnitView = Ember.View.extend({
    templateName: "units-table",
    classNames: ["units"],
    viewFloorplan: function(v,e,c){
      var fp = App.floorplansController.content.filter(function(item,index){
        return item.id == e.target.getAttribute("data-id")
      });
      App.FloorplanModalView.create({
        floorplans: fp
      }).appendTo(App.stateManager.currentState.view.$());
    },
    print: function(v,e,c){
      var fp = App.floorplansController.content.findProperty("id",parseInt(e.target.getAttribute('data-id')));
      App.printFloorplan(fp, function(){window.print()});
    }
  });

  App.VaultwareUnitsView = App.UnitView.extend({
    templateName: "vaultware-units",
    classNames: ["units", "available-units"]
  });

  App.NearbyCommunitiesView = Ember.View.extend({
    templateName: "nearby-communities",
    didInsertElement: function(){
      if(!App.nearbyCommunities){
        $.get(window.location.pathname + "/units/nearby",{
          insite_id: App.get("property_insite_id"),
          token: App.currentUser.get("token")
        }, function(resp){
          App.set("nearbyCommunities",$.map(resp, function(v,k){
            return {community:k.split(" - ")[0], units: v};
          }));
        }).error(function(xhr,status){
          if(xhr.status == 401) App.tokenExpired();
        });
      }
    },
    scrollTo: function(v,e,c){
      var target = e.target.getAttribute("data-id");
      var top = this.$("ul.communities h2[data-id='"+target+"']")[0].offsetTop;
      this.$("#primary").animate({scrollTop: top - 130}, 500);
    },
    click: function(e){
      if($(e.target).parents("nav.side").length == 0){
        $("nav.side").removeClass("show");
      }
      if(e.target.tagName == "A" && $(e.target).parents("nav.side").length > 0){
        this.toggleMenu();
      }
    },
    toggleMenu: function(v,e,c){
      $("#sidebar nav").toggleClass("show");
      return false;
    },
  });

  App.AvailableOptionsView = Ember.View.extend({
    templateName: "available-options",
    didInsertElement: function(){
      if(!App.availableOptions && !App.noAvailableOptions){
        $.get(window.location.pathname + "/options",{
          insite_id: App.get("property_insite_id"),
          token:     App.currentUser.get("token")
        }, function(resp,status,xhr){
          if(xhr.status == 204){
            App.set("noAvailableOptions","This property has no available options");
          } else {
            App.set("availableOptions",
              $.map(resp, function(v,k){
                return {name:k, options: v};
              })
            );
          }
        }).error(function(xhr,status){
          if(xhr.status == 401) App.tokenExpired();
        });
      }
    },
    scrollTo: function(v,e,c){
      var target = e.target.getAttribute("data-id");
      var top = v.$("ul.options h2[data-id='"+target+"']")[0].offsetTop;
      v.$("#primary").animate({scrollTop: top - 130}, 500);
    },
    click: function(e){
      if($(e.target).parents("nav.side").length == 0){
        $("nav.side").removeClass("show");
      }
      if(e.target.tagName == "A" && $(e.target).parents("nav.side").length > 0){
        this.toggleMenu();
      }
    },
    toggleMenu: function(v,e,c){
      $("#sidebar nav").toggleClass("show");
      return false;
    },
  });

  App.requirePhone = function(element){
      var form = $(element.form);
      return form.find(".home:filled").length < 3 &&
             form.find(".work:filled").length < 3 &&
             form.find(".cell:filled").length < 3;
  };

  App.ValidateableFormView = Ember.View.extend({
    validationOptions: {
      highlight: function(el, errorClass){
        $(el).siblings('label').addClass('error');
      },
      unhighlight: function(el, errorClass){
        $(el).siblings('label').removeClass('error');
      },
      rules: {
        first_name: "required",
        last_name:  "required",
        cell_area: { minlength: 3, required: { depends: App.requirePhone } },
        cell_exch: { minlength: 3, required: { depends: App.requirePhone } },
        cell_sln:  { minlength: 4, required: { depends: App.requirePhone } },
        work_area: { minlength: 3, required: { depends: App.requirePhone } },
        work_exch: { minlength: 3, required: { depends: App.requirePhone } },
        work_sln:  { minlength: 4, required: { depends: App.requirePhone } },
        home_area: { minlength: 3, required: { depends: App.requirePhone } },
        home_exch: { minlength: 3, required: { depends: App.requirePhone } },
        home_sln:  { minlength: 4, required: { depends: App.requirePhone } }
      },
      messages: {
        first_name: null,
        last_name:  null,
        cell_area: null,
        cell_exch: null,
        cell_sln:  null,
        work_area: null,
        work_exch: null,
        work_sln:  null,
        home_area: null,
        home_exch: null,
        home_sln: null
      },
      errorElement: 'span'
    },
    didInsertElement: function(){
      if(!window.Touch){
        this.$(".area,.exch").on("keyup",function(e){
          var code = e.keyCode;
          if( ((code > 47 && code < 58) || (code > 95 && code < 106)) &&
              this.value.length == 3 )
                $(this).next("input").focus();
        });
      }
    }
  });

  App.FindGuestView = App.ValidateableFormView.extend({
    templateName: "find-guest",
    classNames: ["guestcard","associate"],
    search: function(view, event, context){
      var self = this;
      this.validationOptions.submitHandler = function(form){
        var formData = $(form).serializeArray();
        App.set("findGuestFormData",formData);
        view.set("searching",true);
        $.get("/find-guest", {
          guest: $(form).serializeObject(),
          token: App.currentUser.token
        }, function(resp){
          if(resp.length > 0) App.guestsController.set("content",resp);
          else App.stateManager.goToState("NoGuestsFoundView");
          view.set("searching",false);
        }).error(function(xhr,status){
          view.set("searching",false);
          if(xhr.status == 401) App.tokenExpired();
        });
      }
      $("#find-guest-form").validate(this.validationOptions);
      if(!$('#find-guest-form').valid()){
        this.$('label.phone').addClass('error');
        App.ErrorMessageModalView.create().appendTo(App.stateManager.currentState.view.$());
      }
      $("#find-guest-form").submit();
    }
  });

  App.NoGuestsFoundView = Ember.View.extend({
    templateName: "no-guests-found",
    classNames: ["associate","pending-guestcards"],
    addGuest: function(e){
      App.stateManager.goToState("AddGuestView");
    }
  });

  App.PendingGuestsView = Ember.View.extend({
    templateName: "pending-guests",
    classNames: ["associate","pending-guestcards"],
    didInsertElement: function(){
      $.get("/guests",{
        key: App.currentUser.get("key"),
        insite_id: App.get("property_insite_id")
      },function(resp){
        App.set("pendingGuests",{
          all_guests:Em.ArrayController.create({content:resp.all_guests}),
          my_guests: Em.ArrayController.create({content:resp.my_guests})
        });
      });
    },
    groups: ['My Guests','All Guests'],
    dates: ['< 30 Days','30 to 60 Days','> 60 Days'],
    filtered: function(guests){
      if(!guests) return [];
      var self = this, today = new Date(), days30 = new Date(), days60 = new Date();
      days30.setDate(today.getDate() + 30);
      days60.setDate(today.getDate() + 60);
      return guests.filter(function(guest){
        var date = new Date(guest.move_in_date);
        if(!guest.move_in_date) return true;
        if(self.get('selectedDates') == '< 30 Days'){
          return date >= today && date < days30;
        } else if(self.get('selectedDates') == '30 to 60 Days'){
          return  date >= days30 && date < days60;
        } else if(self.get('selectedDates') == '> 60 Days'){
          return  date >= days60;
        } else {
          return true;
        }
      })
    },
    filteredGuests: function(){
      this.set('filteredMyGuests',this.filtered(App.getPath('pendingGuests.my_guests.content')));
      this.set('filteredAllGuests',this.filtered(App.getPath('pendingGuests.all_guests.content')));
    }.observes('selectedDates','App.pendingGuests.my_guests','App.pendingGuests.all_guests'),
    showMyGuests: function(){
      return this.get('selectedGroup') == 'My Guests'
    }.property('selectedGroup'),
    sort: function(view, event, context){
      var self = this, field = event.target.getAttribute('data-sort'),
          group = event.target.getAttribute('data-group');
      App.pendingGuests[group].contentWillChange();
      App.pendingGuests[group].set('content',
        App.pendingGuests[group].content.sort(function(a,b){
          var field_a = Object.byString(a,field),
              field_b = Object.byString(b,field);
          if(field == 'created_at' || field == 'move_in_date'){
            field_a = new Date(field_a);
            field_b = new Date(field_b);
          } else if (field == 'first_name' || field == 'insite_user.name'){
            field_a = field_a.toLowerCase();
            field_b = field_b.toLowerCase();
          }
          if(self.get(field.replace('.','_')))
            return field_a < field_b ? -1 : 1;
          else
            return field_a < field_b ? 1 : -1;
        })
      )
      field = field.replace('.','_');
      this.set(field,!this.get(field));
      App.pendingGuests[group].contentDidChange();
      this.set('filteredMyGuests',this.filtered(App.getPath('pendingGuests.my_guests.content')));
      this.set('filteredAllGuests',this.filtered(App.getPath('pendingGuests.all_guests.content')));
    },
    sortable: 'sortable',
    open: function(view, event, context){
      var group = App.pendingGuests[event.target.getAttribute('data-group')];
      var guest = group.findProperty("id", parseInt(event.target.getAttribute("data-id")));
      App.set("currentGuest",App.Guest.create(guest));
      localStorage.setObject("guest",guest);
      App.HeaderView.showGuestMenu();
    },
    removeUser: function(view, event, context){
      var target = event.target;
      var id = target.getAttribute("data-id");
      var remove = confirm("Are you sure you want to remove this guest?");
      if(remove){
        $.post("/guests/"+id, {
          guest: {inactive:true},
          _method:"put",
          authenticity_token: App.currentUser.authenticity_token
        }, function(resp){
          $.each(["my_guests","all_guests"], function(index,group){
            var idx, obj = App.pendingGuests[group].findProperty("id",resp.id);
            if(obj) idx = App.pendingGuests[group].indexOf(obj);
            if(idx !== undefined) App.pendingGuests[group].removeAt(idx);
          });
        });
      };
    }
  });

  App.SelectGuestView = Ember.View.extend({
    templateName: "select-guest",
    classNames: ["guestcard","associate"],
    select: function(view, e, context) {
      var insite_id = e.target.getAttribute("data-insite-id");
      if(insite_id){
        $.get("/guest-card", {
          id       : insite_id,
          property : App.get("property_insite_id"),
          key      : App.currentUser.key,
          token    : App.currentUser.token
        }, function(resp){
          App.set("currentGuest",App.Guest.create(resp));
          localStorage.setObject("guest",resp);
          App.HeaderView.showGuestMenu();
        });
      } else {
        var id = e.target.getAttribute("data-id");
        var guest = App.guestsController.content.findProperty("id",parseInt(id))
        App.set("currentGuest",App.Guest.create(guest));
        localStorage.setObject("guest",guest);
        App.HeaderView.showGuestMenu();
      }
    },
    addGuest: function(v,e,c){
      App.stateManager.goToState("AddGuestView")
    }
  });

  App.AddGuestView = App.ValidateableFormView.extend({
    templateName: "add-guest",
    classNames: ["guestcard","associate"],
    isDisabled: true,
    hideReferralFields: function(){
      return !this.showReferralFields;
    }.property("showReferralFields"),
    hideEscortedFields: function(){
      return !this.showEscortedFields;
    }.property("showEscortedFields"),
    didInsertElement: function(){
      if(App.get("currentGuest")){
        for(var key in App.currentGuest){
          var field = $("#add-guest-form [name='"+key+"']");
          if(field.is(":checkbox")){
            field.prop("checked",App.currentGuest.get(key));
          } else{
            field.val(App.currentGuest.get(key));
          }
        }
      } else if(App.get("findGuestFormData")) {
        $.each(App.findGuestFormData, function(idx,item){
          $("#add-guest-form input[name='"+item.name+"']").val(item.value);
        });
      }

      var view = this;
      this.$("#tablet_lead_source_id").on("change",function(e){
        view.set("showReferralFields",this.value == 4 || this.value == 10);
        view.set("showEscortedFields",this.value == 4);
      }).trigger("change");

      this.validationOptions.rules.tablet_lead_source_id = "required";
      $("#add-guest-form").validate(this.validationOptions);
      this._super();
    },
    save: function(v,e,c){
      if((window.Touch && e.type == "touchend") ||
        (!window.Touch && e.type == "click")){
        var url, method, data = $("#add-guest-form").serializeObject();
        if(App.get("currentGuest") && App.currentGuest.get("id")){
          url = "/guests/" + App.currentGuest.get("id");
          method = "put";
        } else {
          url = "/guests";
        }
        data.tablet_insite_user_id = App.currentUser.key;
        if($("#add-guest-form").valid()){
          $.post(url, {
            id: App.currentGuest && App.currentGuest.id,
            guest: data,
            _method: method,
            authenticity_token: App.currentUser.authenticity_token
          }, function(resp){
            localStorage.setObject("guest",resp);
            App.set("currentGuest", App.Guest.create(resp));
            v.set("isDisabled",!$("#add-guest-form").valid());
            alert("Guest Information Saved");
          })
        } else {
          App.ErrorMessageModalView.create().appendTo(App.stateManager.currentState.view.$());
        }
      }
    },
    complete: function(v,e,c){
      App.currentGuest.set("add_prospect_complete",true);
      App.stateManager.goToState("PhotosView");
      App.HeaderView.showGuestMenu();
    }
  });

  App.SelectApartmentView = Ember.View.extend({
    templateName: "select-apartment",
    search: function(v,e,c){
      var move_in_date = App.currentGuest.move_in_date;
      if(!(move_in_date && move_in_date.trim())){
        v.$("input[type=date]").focus().after('<label class="error" style="float: right; ">This field is required</label>');
      } else {
        App.stateManager.goToState("ApartmentPreferencesView");
        App.unitsController.populate()
      }
    },
    minRentBinding: "App.unitsController.minRent",
    maxRentBinding: "App.unitsController.maxRent",
    didInsertElement: function(){
      var self = this;
      this.$( "#rent-range" ).slider({
        range: true,
        min: 700,
        max: 5000,
        step: 100,
        values: [ this.minRent, this.maxRent ],
        slide: function( event, ui ) {
          App.unitsController.set("minRent", ui.values[0]);
          App.unitsController.set("maxRent", ui.values[1]);
        }
      }).find("a:first").append(
        this.$("output.low")
      ).end().find("a:last").append(
        this.$("output.high")
      );
    }
  });

  App.ApartmentPreferencesView = Ember.View.extend({
    templateName: "apartment-preferences",
    isDisabled: function(){
      return App.unitsController.preferred.length == 0;
    }.property("App.unitsController.preferred"),
    complete: function(v,e,c){
      App.currentGuest.setProperties({select_apartments_complete: true});
      App.stateManager.goToState("PhotosView");
      App.HeaderView.showGuestMenu();
    },
    didInsertElement: function(){
      //need this incase we're switching users and not loading units.json
      App.unitsController.populate();
      App.unitsController.updatePreferred();
    }
  });

  App.GatherLicensesView = Ember.View.extend({
    templateName: "gather-licenses",
    addGuest: function(v,e,c){
      $("#licenses fieldset:first-child").clone().
        insertBefore("#licenses .actions").find("input").val("");
      if($("#licenses fieldset").length > 7){
        $("#licenses").find("button").prop("disabled",true);
      }
    },
    didInsertElement: function(v,e,c){
      var names, guest_names = App.currentGuest.get("guest_names");
      if(guest_names) names = guest_names.split(";");
      else names = [App.currentGuest.first_name + " " + App.currentGuest.last_name];
      for(var i = 0; i < names.length - 2; i++) this.addGuest();
      $.each(names, function(index, item){
        var input = $("#licenses input").eq(index).val(item);
      });
    },
    complete: function(v,e,c){
      var names = $.map(
        $("#licenses").serializeArray(), function(item){if(item.value) return item.value}
      ).join(";");
      App.currentGuest.setProperties({guest_names: names, gather_licenses_complete: true});
      App.stateManager.goToState("PhotosView");
      App.HeaderView.showGuestMenu();
    }
  });

  App.ReturnLicensesView = Ember.View.extend({
    templateName: "return-licenses",
    checked: [],
    isDisabled: true,
    didInsertElement: function(){
      var names;
      if(App.currentGuest && App.currentGuest.guest_names)
        names = App.currentGuest.guest_names.split(";");
      else names = [App.currentGuest.first_name + " " + App.currentGuest.last_name];
      this.set("names",$.map(names, function(name){
        return {name: name, checked: false};
      }));
    },
    updateDisabled: function(){
      var bools = this.get("names").map(function(elem){return elem.checked});
      this.set("isDisabled",bools.indexOf(false) != -1);
    }.observes("names.@each.checked"),
    complete: function(v,e,c){
      App.currentGuest.set("return_licenses_complete",true);
      App.stateManager.goToState("PhotosView");
      App.HeaderView.showGuestMenu();
    }
  });

  App.GablesDifferenceView = Ember.View.extend({
    templateName: "gables-difference",
    isDisabled: true,
    didInsertElement: function(){
      this.$(".info").on(click, function(e){
        $(this).siblings(".modal-wrapper").show();
      });
      this.$(".modal .close").on(click, function(e){
        $(this).parents(".modal-wrapper").hide();
      })
      var self = this;
      this.$("input:checkbox").on("change", function(){
        self.set("isDisabled",self.$("input:checkbox").not(":checked").length != 0);
      });
    },
    complete: function(v,e,c){
      App.currentGuest.set("gables_difference_complete",true);
      App.stateManager.goToState("PhotosView");
      App.HeaderView.showGuestMenu();
    }
  });

  App.TakeHomesView = Ember.View.extend({
    isDisabled: true,
    templateName: "take-homes",
    didInsertElement: function(){
      var self = this;
      this.$("#leave-deposit").on("change", function(){
        self.set("isDisabled",!this.checked);
      });
    },
    complete: function(v,e,c){
      App.currentGuest.set("take_homes_complete",true);
      App.stateManager.goToState("PhotosView");
      App.HeaderView.showGuestMenu();
    }
  });

  App.NotesView = Ember.View.extend({
    templateName: "notes",
    complete: function(v,e,c){
      App.currentGuest.set("notes_complete",true);
      App.stateManager.goToState("PhotosView");
      App.HeaderView.showGuestMenu();
    }
  });

  App.ThankYouNoteView = Ember.View.extend({
    templateName: "thank-you-note",
    preference: function(v,e,c){
      App.FloorplanModalView.create({
        floorplans: App.floorplansController.preferredFloorplans(),
        preference: e.target.getAttribute("data-choice")
      }).appendTo(App.stateManager.currentState.view.$());
    },
    inline: 'inline',
    followUpDate: function(){if(!App.currentGuest.follow_up_date) return 'error'}.property('App.currentGuest.follow_up_date'),
    email: function(){if(!App.currentGuest.email) return 'error'}.property('App.currentGuest.email'),
    preferredUnitTypeOne: function(){if(!parseInt(App.currentGuest.preferred_unit_type1)) return 'error'}.property('App.currentGuest.preferred_unit_type1'),
    preferredUnitTypeTwo: function(){if(!parseInt(App.currentGuest.preferred_unit_type2)) return 'error'}.property('App.currentGuest.preferred_unit_type2'),
    sendCard: function(v,e,c){
      if(App.currentGuest.preferred_unit_type1 &&
         App.currentGuest.preferred_unit_type2 &&
         App.currentGuest.follow_up_date &&
         App.currentGuest.email){
        var note = v.$("#personal_note").val();
        App.stateManager.goToState("ThankYouNoteCompleteView");
        App.set("sendingThankYou",true);
        $.post("/submit-guest-card",{
          id    : App.currentGuest.id,
          key   : App.currentUser.key,
          token : App.currentUser.token,
          note  : note,
          property_insite_id : App.property_insite_id,
          send_email: true
        },function(resp){
          App.currentGuest.set("guest_card_id",resp.CONT_RecordKey);
          App.currentGuest.set("insite_id",    resp.CUST_RecordKey);
          if(resp.PROC_Error == "NONE"){
            v.complete();
          } else {
            alert(resp.PROC_Error);
          }
        }).error(function(xhr,status){
          if(xhr.status == 401) App.tokenExpired();
        }).complete(function(){
          App.set("sendingThankYou",false);
        });
      } else {
        alert("Please fill in all required fields:\n\nDate\n1st Unit Type Preference\n2nd Unit Type Preference\nEmail");
      }
    },
    complete: function(v,e,c){
      App.currentGuest.set("thank_you_note_complete",true);
    }
  });

  App.ThankYouNoteCompleteView = Ember.View.extend({
    templateName: "thank-you-note-complete",
    classNames: ["guestcard","associate","thank-you-note-complete"]
  });

  App.InviteToApplyView = Ember.View.extend({
    templateName: "invite-to-apply",
    inviteToApply: true,
    didInsertElement: function(){
      App.unitsController.populate();
    },
    select: function(v,e,c){
      var target = e.target;
      if(e.target.tagName == "SPAN") target = e.target.parentElement;
      var unit_id = target.getAttribute("data-id");

      App.stateManager.goToState("InviteToApplyCompleteView");
      App.set("submittingApplication",true);
      $.post("/submit-guest-card",{
        id      : App.currentGuest.id,
        key     : App.currentUser.key,
        token   : App.currentUser.token,
        unit_id : unit_id,
        property_insite_id : App.property_insite_id,
        send_email: true
      },function(resp){
        App.currentGuest.set("guest_card_id",resp.CONT_RecordKey);
        App.currentGuest.set("insite_id",    resp.CUST_RecordKey);
        App.currentGuest.set("unit_id",      unit_id);
        if(resp.PROC_Error == "NONE"){
          v.complete();
        } else {
          alert(resp.PROC_Error);
        }
      }).error(function(xhr,status){
        if(xhr.status == 401) App.tokenExpired();
      }).complete(function(){
        App.set("submittingApplication",false);
      });
    },
    complete: function(v,e,c){
      App.currentGuest.set("invite_to_apply_complete",true);
    }
  });

  App.SubmittingApplicationView = Ember.View.extend({
    templateName: "submitting-application",
    classNames: ["border-box"]
  });

  App.InviteToApplyCompleteView = Ember.View.extend({
    templateName: "invite-to-apply-complete",
    classNames: ["border-box"]
  });

  App.SubmitToInsiteModalView = Ember.View.extend({
    templateName: "submit-to-insite-modal",
    classNames: ["modal-wrapper"],
    isDisabled: function(){
      return !(App.currentGuest && App.currentGuest.follow_up_date);
    }.property("App.currentGuest.follow_up_date"),
    submit: function(v,e,c){
      v.remove();
      App.stateManager.goToState("SubmittingApplicationView");
      $.post("/submit-guest-card",{
        id      : App.currentGuest.id,
        key     : App.currentUser.key,
        token   : App.currentUser.token,
        property_insite_id : App.property_insite_id
      },function(resp){
        App.currentGuest.set("guest_card_id",resp.CONT_RecordKey);
        App.currentGuest.set("insite_id",    resp.CUST_RecordKey);
        if(resp.PROC_Error == "NONE"){
          App.set("currentGuest",null);
          App.stateManager.goToState("PendingGuestsView");
        } else {
          alert(resp.PROC_Error);
        }
      }).error(function(xhr,status){
        if(xhr.status == 401) App.tokenExpired();
      }).complete(function(){
      });
    },
    close: function(v,e,c){
      v.remove();
    }
  });

  App.GuestMenuView = Ember.View.extend({
    templateName: "guest-menu",
    classNames: ["guestcard","associate"],
    click: App.closeMenu,
    apartmentPreferences: function(v,e,c){ App.stateManager.goToState("ApartmentPreferencesView"); },
    inviteToApply    : function(v,e,c){ App.stateManager.goToState("InviteToApplyView"); },
    addProspect      : function(v,e,c){ App.stateManager.goToState("AddGuestView"); },
    selectApartments : function(v,e,c){ App.stateManager.goToState("SelectApartmentView"); },
    gatherLicenses   : function(v,e,c){ App.stateManager.goToState("GatherLicensesView"); },
    gablesDifference : function(v,e,c){ App.stateManager.goToState("GablesDifferenceView"); },
    returnLicenses   : function(v,e,c){ App.stateManager.goToState("ReturnLicensesView"); },
    takeHomes        : function(v,e,c){ App.stateManager.goToState("TakeHomesView"); },
    notes            : function(v,e,c){ App.stateManager.goToState("NotesView"); },
    thankYouNote     : function(v,e,c){ App.stateManager.goToState("ThankYouNoteView"); },
    saveAsPending: function(v,e,c){
      App.set("currentGuest",null);
      App.stateManager.goToState("PendingGuestsView");
    },
    submitToInsite : function(v,e,c){
      App.SubmitToInsiteModalView.create({
      }).appendTo(App.stateManager.currentState.view.$())
    }
  });

  App.GuestMenuView.create().replaceIn("#nav-guest");

  App.ExpiringSessionModalView = Ember.View.extend({
    templateName: "expiring-session-modal",
    classNames: ["modal-wrapper"],
    extendSession: function(v,e,c){ v.remove(); }
  });
});
