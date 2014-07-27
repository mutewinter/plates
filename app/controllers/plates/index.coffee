module.exports = App.PlatesIndexController = Ember.ArrayController.extend
  sortAscending: false
  sortProperties: ['links.lastObject.createdAt']
