escape = require 'utils/escape'

PLATE_PROPERTIES = ['name', 'color1', 'color2']
PLATE_KEY = 'home_plate_form'
EMAIL_KEY = 'home_emails_form'
URL_KEY = 'home_url_form'

module.exports =
  App.HomeController = Ember.Controller.extend Ember.TargetActionSupport,
  isSignedIn: Ember.computed.alias 'session.isSignedIn'

  saveToLocalStorage: ->
    return unless localStorage?

    plateProperties = @get('plate').getProperties(PLATE_PROPERTIES)
    localStorage.setItem(PLATE_KEY, JSON.stringify(plateProperties))
    localStorage.setItem(EMAIL_KEY, JSON.stringify(@get('emails')))
    localStorage.setItem(URL_KEY, @get('url'))

  clearForm: ->
    return unless localStorage?
    localStorage.removeItem(PLATE_KEY)
    localStorage.removeItem(EMAIL_KEY)
    localStorage.removeItem(URL_KEY)
    @setupPlate()
    @setupEmails()
    @setupUrl()

  setupPlate: (->
    Ember.run.next =>
      plate = App.Plate.createRandomPlate(@get('store'))

      if localStorage?
        try
          plateProperties = JSON.parse(localStorage.getItem(PLATE_KEY))
          plate.setProperties(plateProperties) if plateProperties

      @set('plate', plate)
  ).on('init')

  setupEmails: (->
    return unless localStorage?
    try
      emails = JSON.parse(localStorage.getItem(EMAIL_KEY))
    catch error
      emails = null

    @set('emails', emails)
  ).on('init')

  setupUrl: (->
    @set('url', localStorage.getItem(URL_KEY)) if localStorage?
  ).on('init')

  readyToShare: (->
    @get('isSignedIn') and @get('newLink.readyToShare') and
    Ember.get(this, 'emails.length') >= 0
  ).property('isSignedIn', 'newLink.readyToShare', 'emails.@each')

  plateWithLinkAndMembers: ->
    store = @get('store')
    { plate, newLink, emails } = @getProperties('plate', 'newLink', 'emails')


    if !@get('isSignedIn') or !newLink.get('readyToShare') or
    Ember.get(emails, 'length') <= 0
      return alert('Please fill in a valid URL and at least one email')

    new Ember.RSVP.Promise (resolve, reject) =>
      App.User.usersFromEmails(emails, store).then (users) =>
        members = users.compact()
        # The current user is always a member
        members.pushObject(@get('session.user'))

        plate.setProperties(
          owner: @get('session.user')
          members: members
          links: [newLink]
        )
        resolve(plate)

  createPlate: ->
    store = @get('store')

    @plateWithLinkAndMembers().then (plate) =>
      plate.saveInviteAndEmail().then (=>
        @clearForm()
        @transitionToRoute('plate', plate)
      ), ((error) ->
        Ember.Logger.debug 'Error saving plate', error
      )


  actions:
    signInOrSend: ->
      @saveToLocalStorage()
      if @get('isSignedIn')
        @createPlate()
      else
        @triggerAction(action: 'signIn', actionContext: undefined)

      # No bubble
      return false
