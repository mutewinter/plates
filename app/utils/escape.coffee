module.exports =
  email: (email) ->
    return false unless email and Ember.typeOf(email) is 'string'

    email = email.toLowerCase()
    # Replace '.' (not allowed in a Firebase key) with ','
    email = email.replace(/\./g, ',')
