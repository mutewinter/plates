Ember.Application.initializer
  name: 'clock'

  initialize: (container, application) ->
    container.register('clock:service', App.Clock)
    application.inject('controller:interval', 'clock', 'clock:service')
