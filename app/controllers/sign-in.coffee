alias = Ember.computed.alias

module.exports = App.SignInController = Ember.Controller.extend
  needs: ['application']
  lastTransition: Ember.computed.alias 'controllers.application.lastTransition'
  currentPath: Ember.computed.alias 'controllers.application.currentPath'
  isSignedIn: alias 'session.isSignedIn'

  observesSignedIn: (->
    if @get('isSignedIn')
      lastTransition = @get('lastTransition')
      if lastTransition?
        @get('lastTransition').retry()
        @set('lastTransition', null)
      else if @get('currentPath') is 'sign-in'
        # On sign in page, direct to plates page since they had no destination
        @transitionToRoute('plates')
  ).observes('isSignedIn', 'currentPath').on('init')

  targetUrl: (->
    transition = @get('lastTransition')
    return '' unless transition
    router = transition.router
    routeName = transition.targetName
    router.recognizer.generate(routeName, transition.params)
  ).property('lastTransition')

  actions:
    signIn: ->
      @get('session').signIn(@get('targetUrl'))
      return false
