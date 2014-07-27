module.exports = App.PlateIndexRoute = Ember.Route.extend
  model: -> @modelFor('plate')
