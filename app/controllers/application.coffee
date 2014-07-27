module.exports = App.ApplicationController = Ember.Controller.extend
  homeRouteName: (->
    if @get('session.isSignedIn') then 'plates' else 'home'
  ).property('session.isSignedIn')
