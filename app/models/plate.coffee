{ attr, hasMany, hasOne } = FP

env = require 'config/environment'

module.exports = App.Plate = App.Model.extend
  name: attr('string', default: -> 'Blubbary Pankakes')
  color1: attr('string')
  color2: attr('string')

  owner: hasOne('user', embedded: false)
  activities: hasMany('activity')
  links: hasMany('link')
  members: hasMany('user', embedded: false)

  membersWithoutYou: (->
    return @get('members') unless @get('session.isSignedIn')
    @get('members').rejectBy('id', @get('session.user.id'))
  ).property('session.isSignedIn', 'members.@each')

  saveInviteAndEmail: ->
    promise = @save()
    promise.then =>
      @inviteMembers()
      @emailLinkToMembers(@get('links.firstObject'))
    promise

  inviteMembers: ->
    @get('members').forEach (user) =>
      invite = @get('store').createRecord('plateInvite',
        toUser: user
        fromUser: @get('session.user')
        plate: this
      )
      invite.save()

  emailLinkToMembers: (link) ->
    return Ember.Logger.error 'No link' unless link

    plateId = @get('id')
    linkId = link.get('id')
    domain = link.get('provider.domain')

    to = @get('members')
      .rejectBy('id', @get('session.user.id'))
      .mapBy('email')
      .join(', ')

    return Ember.Logger.error 'No To for email, skipping' if Ember.isEmpty(to)

    linkUrl = "#{env.get('domain')}/#/plates/#{plateId}/link/#{linkId}"
    linkTitle = link.get('title')
    subject = "[Plates] #{linkTitle}"

    email = @get('store').createRecord('email',
      to: to
      from: @get('session.user.email')
      fromName: @get('session.user.nameOrEmail')
      subject: subject
      template: 'new-link'
      data:
        title: linkTitle or ''
        url: linkUrl
        imageUrl: link.get('imageUrl') or ''
        originalUrl: link.get('cleanUrl') or link.get('url')
        domain: domain or 'Original'
    )

    email.save().then (=>
      Ember.Logger.debug 'Email queued', email.get('to')
    ), (error) =>
      Ember.Logger.error 'Error queing email', error

  randomizeColorsAndName: ->
    color1 = chance.pick(COLORS_TO_NAMES)
    color2 = chance.pick(COLORS_TO_NAMES)
    if color1.color is color2.color
      [name1, name2] = chance.pick(color1.names, 2)
    else
      name1 = chance.pick(color1.names)
      name2 = chance.pick(color2.names)

    name = "#{name1} #{name2} Plate"

    @setProperties(
      name: name
      color1: color1.color
      color2: color2.color
    )

COLORS_TO_NAMES = [
  color: '#525252'
  names: [
    'Pepper'
    'Licorice'
    'Bean'
    'Astronaut Food'
  ]
,
  color: '#6DB9D1'
  names: [
    'Blueberry'
    'Sea Salt'
    'Cornflower'
    'Macaroon'
  ]
,
  color: '#85BCB1'
  names: [
    'Pine'
    'Asparagus'
    'Pea'
    'Watermelon'
  ]
,
  color: '#E2927F'
  names: [
    'Apricot'
    'Peach'
    'Grapefruit'
    'Mango'
  ]
,
  color: '#F9CF6C'
  names: [
    'Yolk'
    'Custard'
    'Banana'
    'Lemon'
  ]
,
  color: '#B1B0AB'
  names: [
    'Mushroom'
    'Shallot'
    'Egg'
    'Blubber'
  ]
,
  color: '#D86C53'
  names: [
    'Salmon'
    'Apple'
    'Chestnut'
    'Chilli'
  ]
]

App.Plate.reopenClass
  createRandomPlate: (store) ->
    plate = store.createRecord('plate')
    plate.randomizeColorsAndName()
    plate
