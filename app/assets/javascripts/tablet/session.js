$(document).ready(function(){

  var associateMenuView, interval, lastInput, sessionModal, timeout;

  var userInfo = function(data){
    $("body").addClass("logged-in");
    if(data.guest){
      App.set("currentGuest",App.Guest.create(data.guest));
    }
    App.set("currentUser",App.User.create(data.user));
    associateMenuView = App.AssociateMenuView.create({user: App.currentUser});
    associateMenuView.replaceIn("#nav-user");
    $("#login-form").hide();
  };

  $("#login-form").live("ajax:beforeSend", function(evt, xhr, settings){
    //disable form
  }).live("ajax:error", function(evt, xhr, status, error){
    if(xhr.status == 420){
      App.set("loginError","Tablet access denied");
    }
    if(xhr.status == 421){
      App.set("loginError","Community access denied");
    }
    if(xhr.status == 422){
      App.set("loginError","Name or password incorrect");
    }
  }).live("ajax:success", function(evt, data, status, xhr){
    document.activeElement.blur();
    App.set("loginError",null);
    if(data != null){
      localStorage.setObject("user",data.user);
      localStorage.setObject("guest",data.guest);
      userInfo(data);
      lastInput = new Date();
      localStorage.setObject("lastInput",lastInput);
    }
  });

  sessionModal = App.ExpiringSessionModalView.create();

  var autoLogout = function(){
    sessionModal.appendTo("#content");
    timeout = setTimeout(function(){
      associateMenuView.logout();
      sessionModal.remove();
    },30000);
  };

  shouldLogout = function(){
    if(!lastInput){
      storedLastInput = localStorage.getObject("lastInput");
      if(storedLastInput) lastInput = new Date(storedLastInput);
      else return true;
    }
    return lastInput < new Date(new Date().getTime() - 60000 * 15);
  };

  setInterval(function(){
    if(App.currentUser && shouldLogout() && sessionModal.state != "inDOM") autoLogout();
  },5000);

  $("body").on(window.Touch ? "touchend" : "click",function(){
    if(App.currentUser){
      clearTimeout(timeout);
      lastInput = new Date();
      localStorage.setObject("lastInput",lastInput);
    }
  })

  if(!shouldLogout()){
    var userData = localStorage.getObject("user");
    var guestData = localStorage.getObject("guest");
    if(userData){
      userInfo({user: userData, guest: guestData});
    }
  }

});
