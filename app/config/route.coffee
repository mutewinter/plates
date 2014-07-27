Ember.Route = Ember.Route.extend
  isAuthenticated: true

  beforeModel: (transition) ->
    if @get('isAuthenticated') and !@get('session.isSignedIn')
      @controllerFor('application').set('lastTransition', transition)
      @replaceWith('sign-in')
