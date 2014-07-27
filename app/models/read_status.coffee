hasOne = FP.hasOne

module.exports = App.ReadStatus = App.Model.extend
  user: hasOne('user', embedded: false)

  readAt: Ember.computed.alias 'createdAt'
