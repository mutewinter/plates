sysPath = require 'path'

environment = process.env.BRUNCH_ENV ? 'development'

console.log "Running Brunch in #{environment} environment"

exports.config =
  paths:
    watched: ['app', 'test', 'vendor', 'config']
  files:
    javascripts:
      joinTo:
        'scripts/app.js':
          new RegExp("^(app|config/environments/#{environment}\.coffee)")
        'scripts/vendor.js':
          new RegExp("^(vendor/(scripts|ember/#{environment})|bower_components)")
      order:
        before: [
          'vendor/scripts/console-polyfill.js'
          'vendor/scripts/jquery.js'
          'vendor/scripts/handlebars.js'
          "vendor/ember/#{environment}/ember.js"
          "vendor/ember/#{environment}/ember-inflector.js"
          "vendor/ember/#{environment}/fireplace.js"
          'vendor/scripts/jquery.embedly.js'
          # Anything else that depends on Ember
        ]

    stylesheets:
      joinTo:
        'styles/app.css': /^(app|vendor)/
      order:
        before: ['vendor/styles/reset.css']

    templates:
      precompile: true
      root: 'templates'
      joinTo: 'scripts/app.js' : /^app/

  # allow _ prefixed templates so partials work
  conventions:
    ignored: (path) ->
      startsWith = (string, substring) ->
        string.indexOf(substring, 0) is 0
      sep = sysPath.sep
      if path.indexOf("app#{sep}templates#{sep}") is 0
        false
      else
        startsWith sysPath.basename(path), '_'

  server: port: 1338

  plugins: sass: mode: 'ruby'

  overrides:
    production:
      optimize: true
      sourceMaps: false
      plugins: autoReload: enabled: false
