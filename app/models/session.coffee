env = require 'config/environment'

module.exports = App.Session = Ember.Object.extend Ember.Evented,
  isSignedIn: Ember.computed.notEmpty 'user.id'

  signIn: (returnTo = '', signedInCallback = Ember.K) ->
    if Ember.typeOf(returnTo) is 'string'
      returnTo = returnTo.replace(/^\//, '')
      returnTo = "/#/#{returnTo}"
    else
      returnTo = ''

    # Fake watch so Persona allows us to call request
    navigator.id.watch(
      loggedInUser: null
      onlogin: Ember.K
      onlogout: Ember.K
    )

    options =
      backgroundColor: '#85BCB1'
      returnTo: returnTo
      siteName: 'Plates'
      oncancel: ->
        # TODO handle this in the UI if necessary
        Ember.Logger.debug 'Cancelled Persona login'

    # TODO Uncomment this if our production environment gets SSL support
    #  if env.get('isProduction')
    #    options.siteLogo = '/img/logo-for-persona.svg'

    # HACK no callback from Persona we can listen to, instead we just listen
    # once to the next state chance of isSignedIn.
    @addObserver('isSignedIn', this, (value) =>
      @removeObserver('isSignedIn', this)
      signedInCallback() if @get('isSignedIn')
    )

    # Call request manually so we can present our logo and site name for Persona
    navigator.id.request(options)
    # We still must call Firebase's login so it listens to the watch callback
    @get('auth').login('persona', rememberMe: true)

  signOut: ->
    @set('user', null)
    @get('auth').logout()

  # TODO Inject store
  store: (->
    App.__container__.lookup('store:main')
  ).property()

  trackPlateInvites: (->
    return unless @get('user')
    @get('user').trackPlateInvites()
  ).observes('user')

  watchAuth: (->
    ref = @get('ref')
    store = @get('store')

    auth = new FirebaseSimpleLogin ref, (error, authUser) =>
      if authUser
        userProperties =
          id: authUser.id
          email: authUser.email

        store.fetch('user', authUser.id).then(((user) =>
          # User exists
          user.setProperties(userProperties)
          user.save()
          # Update user to latest from auth
          @set('user', user)
          @trigger('existingSessionLoaded')
        ), (error) =>
          if error is 'not found'
            # User does not exist, create it
            user = store.createRecord('user', userProperties)
            user.save()
            @set('user', user)
            @trigger('existingSessionLoaded')
          else
            Ember.RSVP.reject(error)
            @trigger('existingSessionLoaded')
        )
      else
        # No user, clear the user so our UI reflects it if this was a sign out
        @set('user', null)
        @trigger('existingSessionLoaded')
    @set('auth', auth)
  ).on('init').observes('ref')
