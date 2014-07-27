module.exports = App.ApplicationRoute = Ember.Route.extend
  isAuthenticated: false

  actions:
    signIn: (target) ->
      @get('session').signIn(target, =>
        @transitionTo(target) if Ember.typeOf(target) is 'string'
      )

    signOut: ->
      @get('session').signOut()
      @transitionTo('home')

    error: (error) ->
      if error is 'permission denied'
        @transitionTo('home')
      else
        Ember.Logger.error 'Unknown error', error

    didTransition: ->
      if env.get('isProduction') and !Ember.isNone(_gauges)
        Ember.run.scheduleOnce 'afterRender', -> _gauges.push(['track'])
