env = require 'config/environment'

Ember.Application.initializer
  name: 'session'

  initialize: (container, application) ->
    # Wait for the Firebase user to load (or not)
    application.deferReadiness()

    ref = new Firebase(env.get('firebaseUrl'))

    session = App.Session.create(ref: ref)
    application.register(
      'session:current', session, instantiate: false, singleton: true
    )
    ['controller', 'route', 'view', 'component'].forEach (type) ->
      application.inject(type, 'session', 'session:current')
    session.one('existingSessionLoaded', ->
      application.advanceReadiness()
    )
