module.exports = App.PlateIndexController = Ember.ObjectController.extend
  resetLink: ->
    @set('url', '')

  setupNewLink: (->
    return unless @get('model')
    @resetLink()
  ).observes('model')

  isLinkReady: Ember.computed.alias 'newLink.isMetadataLoaded'

  actions:
    shareNewLink: (link) ->
      newLink = @get('newLink')
      return unless newLink.get('readyToShare')
      plate = @get('model')
      plate.get('links').pushObject(newLink)
      plate.save().then =>
        @resetLink()
        plate.emailLinkToMembers(newLink)
