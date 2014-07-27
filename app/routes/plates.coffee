module.exports = App.PlatesRoute = Ember.Route.extend
  model: ->
    @get('session.user.plates')

  actions:
    newPlate: ->
      @transitionTo('plates.new')
