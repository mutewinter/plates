module.exports = App.PlatesController = Ember.ArrayController.extend
  actions:
    updateName: ->
      newName = Ember.$.trim(@get('newName'))
      user = @get('session.user')
      unless Ember.isEmpty(newName)
        user.set('name', newName)
        user.save()
