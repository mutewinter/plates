require 'models/model'

{ attr, hasOne } = FP

module.exports = App.Comment = App.Model.extend
  text: attr('string')

  user: hasOne('user', embedded: false)

  isEmpty: (->
    Ember.isEmpty(Ember.$.trim(@get('text')))
  ).property('text')

  placeholder: (->
    chance.pick(RANDOM_TEXT)
  ).property()

RANDOM_TEXT = [
  'FIRST!'
  'The book was better.'
  'Tayne is my spirit animal.'
  '1 star. Add more filters.'
  'I am overwhelmed.'
  'TO THE MOON!'
  'Speaking as a mother...'
  'You just wrinkled my brain!'
  'Fools gold!'
  'A+++++ Would buy again'
  'Just what I was looking for.'
]
