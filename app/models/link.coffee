require 'models/model'

alias = Ember.computed.alias

{ attr, hasMany, hasOne } = FP

module.exports = App.Link = App.Model.extend
  url: attr('string')

  user: hasOne('user', embedded: false)
  metadata: hasOne('metadata')
  comments: hasMany('comment')
  readStatuses: hasMany('readStatus')

  isMetadataLoaded: Ember.computed.notEmpty 'metadata'
  imageUrl: alias 'image.url'

  recordReadStatus: (user) ->
    readStatuses = @get('readStatuses')
    return if readStatuses.findBy('user.id', user.get('id'))
    readStatus = @get('store').createRecord('readStatus', user: user)
    readStatuses.pushObject(readStatus)
    @save()

  title: (->
    if @get('metadata.title')
      @get('metadata.title')
    else if @get('provider.name')
      "Link from #{@get('provider.name')}"
    else if @get('provider.domain')
      "Link from #{@get('provider.domain')}"
    else
      'Some Random Link'
  ).property('metadata.title', 'metadata.provider.name',
    'metadata.provider.domain')

  style: (->
    "border-left: 5px solid #{@get('primaryFaviconColor')}"
  ).property('primaryFaviconColor')

  primaryFaviconColor: (->
    return unless @get('favicon.colors')
    colors = @get('favicon.colors')
    color = colors[0].color
    "rgb(#{color.join(',')})"
  ).property('favicon.colors')

  readyToShare: (->
    url = Ember.$.trim(@get('url'))
    !Ember.isEmpty(url) and
    !@get('metadata.isPending') and !@get('metadata.isRejected')
  ).property('url', 'metadata.isPending', 'metadata.isRejected')

  fetchMetadata: ->
    return if Ember.isEmpty(@get('url'))
    metadata = @get('store').createRecord('metadata')
    @set('metadata', metadata)

    promise = $.embedly.extract(@get('url')).progress (data) =>
      if data.error or data.invalid
        if data.invalid
          message = "Invalid URL #{@get('url')}"
        else
          message = "Error loading Embed.ly for #{@get('url')}"
        Ember.Logger.error message, data
        @get('metadata').set('promise', Ember.RSVP.reject(message))
      else
        Ember.run =>
          if Ember.typeOf(data.images) is 'array' and data.images.length > 0
            image = data.images[0]

          @get('metadata').setProperties(
            title: data.title
            description: data.description
            type: data.type
            cleanUrl: data.url
            originalUrl: data.originalUrl
            provider:
              name: data.provider_name
              domain: data.provider_display
              url: data.provider_url
            media: data.media
            image: image
            favicon:
              url: data.favicon_url
              colors: data.favicon_colors
          )

    @get('metadata').set('promise', promise)

METADATA_ALIASES =  ['cleanUrl', 'originalUrl', 'description', 'type',
'provider', 'media', 'image', 'favicon']
App.Link.aliasMany METADATA_ALIASES, 'metadata'

App.Link.reopenClass
  firebasePath: (options) ->
    if options.get('plate')
      # Link with plate, use absolute path
      "plates/#{options.get('plate.id')}/links"
    else
      # New link, just use relative path
      'links'

App.Metadata = App.Model.extend Ember.PromiseProxyMixin,
  cleanUrl: attr('string')
  originalUrl: attr('string')
  title: attr('string')
  description: attr('string')
  type: attr('string')

  provider: attr('hash')
  media: attr('hash')
  image: attr('hash')
  favicon: attr('hash')
