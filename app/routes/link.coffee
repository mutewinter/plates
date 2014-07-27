module.exports = App.LinkRoute = Ember.Route.extend
  model: (params) ->
    link = @get('store').fetch(
      'link', params.link_id, plate: @modelFor('plate')
    )
    link.catch =>
      Ember.Logger.error 'Unknown link'
      @replaceWith('plate', @modelFor('plate'))

  renderTemplate: ->
    @render('link', into: 'plate')

  actions:
    didTransition: ->
      if @get('session.isSignedIn')
        @modelFor('link').recordReadStatus(@get('session.user'))

      # Bubble
      return true
