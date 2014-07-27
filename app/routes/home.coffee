module.exports = App.HomeRoute = Ember.Route.extend
  isAuthenticated: false

  beforeModel: ->
    applicationController = @controllerFor('application')
    session = @get('session')

    if session.get('isSignedIn') and session.get('user.hasPlates') and
    !applicationController.get('redirectedFromHome')
      applicationController.set('redirectedFromHome', true)
      @replaceWith('plates')
