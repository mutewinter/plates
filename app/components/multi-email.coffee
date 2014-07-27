Email = Ember.Object.extend
  value: null
  first: false

module.exports = App.MultiEmailComponent = Ember.Component.extend
  emails: ((key, value) ->
    if arguments.length > 1 and value?
      # Setter
      emailObjects = value?.map (email, index) ->
        Email.create(value: email, first: index is 0)

      @set('emailObjects', emailObjects)

    @get('emailObjects').mapBy('value')
  ).property('emailObjects.@each.value')

  emailObjects: ((key, value) ->
    if arguments.length > 1
      # Setter
      @set('_emails', value)

    @getWithDefault('_emails', [Email.create(value: '', first: true)])
  ).property('')

  actions:
    addEmail: ->
      @get('emailObjects').pushObject(Email.create())

    removeEmail: (email) ->
      @get('emailObjects').removeObject(email)
