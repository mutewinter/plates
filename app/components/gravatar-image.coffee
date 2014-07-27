module.exports = App.GravatarImageComponent = Ember.Component.extend
  tagName: 'img'
  size: 50
  email: ''
  attributeBindings: [ 'src' ]

  src: (->
    emailMd5 = @get('user.emailMd5') or md5(@get('email'))
    size = @get('size')

    "https://secure.gravatar.com/avatar/#{emailMd5}?s=#{size}&d=mm"
  ).property('user.emailMd5', 'email', 'size')
