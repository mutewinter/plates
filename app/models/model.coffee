aliasMany = require 'utils/alias_many'

module.exports = App.Model = FP.Model.extend App.CreatedAtMixin,
  # FIXME Find a way to inject session into all FP.Models
  session: (->
    App.__container__.lookup('session:current')
  ).property()

App.Model.reopenClass
  aliasMany: (aliasNames, targetObject) ->
    aliasMany(aliasNames, targetObject, this)
