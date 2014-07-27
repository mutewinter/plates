module.exports = App.ShareLinkComponent = Ember.Component.extend
  observesUrl: (->
    link = @get('store').createRecord('link',
      url: @get('url')
      user: @get('session.user')
    )
    link.fetchMetadata()
    @set('link', link)
  ).observes('url').on('init')

  observesSessionUser: (->
    @get('link')?.set('user', @get('session.user'))
  ).observes('session.user')
