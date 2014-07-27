require 'models/model'

attr = FP.attr

module.exports = App.Email = App.Model.extend
  to: attr('string')
  from: attr('string')
  fromName: attr('string')
  subject: attr('string')
  template: attr('string')
  data: attr('hash')
