$(function(){
  App = Ember.Application.create({customEvents: {touchend: "click"}});

  App.set("property_insite_id",property_insite_id);
  App.set("property_phone",    property_phone);
  App.set("site_plans",        site_plans);

  Handlebars.registerHelper('formattedDate', function(property) {
    var value = Ember.getPath(this, property);
    if(value){
      var dates = value.split("-");
      var date = new Date(dates[0],dates[1],dates[2]);
      var curr_date = date.getDate();
      var curr_month = date.getMonth();
      var curr_year = date.getFullYear();
      return curr_month + "/" + curr_date + "/" + curr_year;
    }
  });

  Handlebars.registerHelper('descriptionsOf', function(property) {
    var values = Ember.getPath(this, property);
    return values.map(function(elem,idx){return elem.description}).join(", ")
  });

  App.Select = Ember.Select.extend({
    template: Ember.Handlebars.compile(
      '{{#if prompt}}<option>{{prompt}}</option>{{/if}}' +
      '{{#each content}}{{view App.SelectOption contentBinding="this"}}{{/each}}'
    )
  });

  App.SelectOption = Ember.SelectOption.extend({
    attributeBindings: ['value', 'selected', 'disabled'],
    disabled: Ember.computed(function() {
      var content = Ember.get(this, 'content');
      return content.disabled;
    }).property('content','content.disabled')
  });

  App.filterBedOptions = function(content){
    return content.map(function(item){
      return item.bedrooms_count;
    }).uniq().sort().map(function(item){
      return Ember.Object.create({id: item, name: (item == 0 ? "Studio" : item)});
    });
  };

  App.filterBathOptions = function(content){
    return content.map(function(item){
      return item.bathrooms_count;
    }).uniq().sort().map(function(item){
      return Ember.Object.create({id: item});
    });
  };

  App.numberOccupants = [1,2,3,4,5,6];

  App.rentOptions = [ 700,800,900,
    1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,
    2000,2100,2200,2300,2400,2500,2600,2700,2800,2900,
    3000,3100,3200,3300,3400,3500,3600,3700,3800,3900,
    4000,4100,4200,4300,4400,4500,4600,4700,4800,4900,
    5000];

  App.showOptions = ['Available', 'All'];
  App.leaseTermOptions = ['9 mo.', '12 mo.', '15 mo.'];

  App.tokenExpired = function(){
    $("body").removeClass("logged-in");
    App.stateManager.goToState("PhotosView");
    $("#login-form").show();
    alert("Your token has expired. Please sign in again");
  };

  App.closeMenu = function(e){
    if($(e.target).parents(".pop").length > 0 && e.target.tagName == "A"){
      $(e.target).parents(".pop").hide();
    };
  };

  App.printFloorplan = function(fp,callback){
    var pricing = App.currentUser ? confirm('Include Pricing?') : false;
    App.PrintFloorplanView.create({
      floorplan: fp,
      pricing: pricing,
      didInsertElement: callback
    }).replaceIn('#print-only')
  };
});

jQuery.fn.serializeObject = function() {
  var arrayData, objectData;
  arrayData = this.serializeArray();
  objectData = {};

  $.each(arrayData, function() {
    var value;

    if (this.value != null) {
      value = this.value;
    } else {
      value = '';
    }

    if (objectData[this.name] != null) {
      if (!objectData[this.name].push) {
        objectData[this.name] = [objectData[this.name]];
      }

      objectData[this.name].push(value);
    } else {
      objectData[this.name] = value;
    }
  });

  return objectData;
};

Storage.prototype.setObject = function(key, value) {
    this.setItem(key, JSON.stringify(value));
}

Storage.prototype.getObject = function(key) {
    var value = this.getItem(key);
    try{
      return value && JSON.parse(value);
    } catch(e) { }
}

Object.byString = function(o, s) {
    s = s.replace(/\[(\w+)\]/g, '.$1'); // convert indexes to properties
    s = s.replace(/^\./, '');           // strip a leading dot
    var a = s.split('.');
    while (a.length) {
        var n = a.shift();
        if (n in o) {
            o = o[n];
        } else {
            return;
        }
    }
    return o;
}

if(navigator.userAgent.match(/iPad/i)){
  $('body').on('touchend',function(e){
    if(!e.target.tagName.match(/input|textarea|select/i))
      $('input,textarea,select').blur()
  })
  $('body').on("focus","input,textarea,select",function(e) {
    $('.page-footer').hide();
  }).on("blur","input,textarea,select",function(e) {
    $('.page-footer').show();
  });
};
