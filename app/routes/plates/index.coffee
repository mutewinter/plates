module.exports = App.PlatesIndexRoute = Ember.Route.extend
  model: -> @modelFor('plates')
