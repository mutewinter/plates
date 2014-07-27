module.exports = App.PlatesNewRoute = Ember.Route.extend
  renderTemplate: ->
    @render('plates/new', into: 'plates')
