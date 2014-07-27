module.exports = App.PlatesNewController = Ember.Controller.extend

  reset: (->
    store = @get('store')
    @set('plate', App.Plate.createRandomPlate(store))
    @set('url', '')
    @set('emails', [''])
  ).on('init')

  actions:
    createPlate: ->
      newLink = @get('newLink')
      plate = @get('plate')

      return unless newLink.get('readyToShare')

      App.User.usersFromEmails(@get('emails'), @get('store')).then (users) =>
        members = users.compact()
        # The current user is always a member
        members.pushObject(@get('session.user'))

        newLink.set('user', @get('session.user'))
        plate.setProperties(
          owner: @get('session.user')
          members: members
          links: [newLink]
        )
        plate.saveInviteAndEmail().then (=>
          @transitionToRoute('plate', plate)
          @reset()
        ), ((error) ->
          Ember.Logger.debug 'Error saving plate', error
        )
