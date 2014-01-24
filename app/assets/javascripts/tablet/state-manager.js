$(function(){
  var states = {
    history: [],
    rootElement: '#content',
    initialState: "PhotosView",
    goToState: function(name){
      if(!this.currentState || name != this.currentState.name){
        scrollTo(0,0);
        this.history.push(name);
        localStorage.setObject("history",this.history);
        _gaq.push(['_trackPageview', window.location.pathname + '/' + name]);
        this._super(name);
      }
    },
    goBack: function(){
      var currentState = this.history.pop();
      var previousState = this.history.pop();
      if(previousState) this.goToState(previousState);
    }
  };

  for(var key in App){
    if(key.match(/View/)){
      states[key] = Ember.ViewState.create({ view : App[key] })
    }
  }

  var history = localStorage.getObject("history");
  if(history && history.length > 0){
    states.history = history;
    states.initialState = history.pop();
  }

  App.stateManager = Ember.StateManager.create(states);

});

