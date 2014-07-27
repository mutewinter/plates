Ember.Handlebars.helper 'pluralize', (number, options) ->
  single = options.hash['s']
  return unless single
  Ember.assert('pluralize requires a singular string (s)', single)
  plural = options.hash['p'] || single + 's'
  if (number == 1) then single else plural
