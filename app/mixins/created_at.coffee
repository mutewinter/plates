module.exports = App.CreatedAtMixin = Ember.Mixin.create
  createdAt: FP.attr('date', default: -> new Date())

  setupClock: (->
    clock = App.__container__.lookup('clock:service')
    @set('_clock', clock)
  ).on('init')

  createdAtRelative: (->
    moment(@get('createdAt')).fromNow()
  ).property('createdAt', '_clock.seconds')
