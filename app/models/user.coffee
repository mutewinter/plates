escape = require 'utils/escape'

{ attr, hasMany } = FP

module.exports = App.User = App.Model.extend
  name: attr('string')
  email: attr('string')

  friends: hasMany('user', embedded: false)
  plates: hasMany('plate', embedded: false)

  hasPlates: Ember.computed.notEmpty 'plates.[]'
  hasNoName: Ember.computed.empty 'name'

  nameOrEmail: (->
    @get('name') or @get('email')
  ).property('name', 'email')

  emailMd5: (->
    md5(@get('email'))
  ).property('email')

  observesPlateInvites: (->
    @collectPlateInvites()
  ).observes('plateInvites.@each')

  trackPlateInvites: ->
    @get('store').fetch('plateInvite', toUser: this).then (plateInvites) =>
      @set('plateInvites', plateInvites)

  collectPlateInvites: ->
    plateInvites = @get('plateInvites')
    return unless plateInvites
    plateIds = @get('plates').mapBy('id')

    plateInvites.forEach (plateInvite) =>
      plate = plateInvite.get('plate')
      # FIXME Object comparison won't work here
      unless plateIds.contains(plate.get('id'))
        @get('plates').pushObject(plate)

    # TODO Now that we've processed the invites, delete them
    # plateInvites.invoke('delete')
    @save()


App.User.reopenClass
  usersFromEmails: (emails, store) ->
    return Ember.RSVP.reject('No emails supplied') unless emails
    promises = emails.map (email) =>
      userId = escape.email(email)
      new Ember.RSVP.Promise (resolve, reject) ->
        store.fetch('user', userId).then(((user)->
          resolve(user)
        ), (error) ->
          if error is 'not found'
            if !Ember.isEmpty(email)
              newUser = store.createRecord('user',
                id: userId
                email: email
              )
              resolve(newUser.save())
            else
              resolve()
          else
            reject(error)
        )

    Ember.RSVP.all(promises)
