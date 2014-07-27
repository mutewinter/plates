module.exports = (aliasNames, targetObject, type) ->
  aliases = aliasNames.reduce((memo, property) ->
    memo[property] = Ember.computed.alias "#{targetObject}.#{property}"
    memo
  , {})
  type.reopen(aliases)
