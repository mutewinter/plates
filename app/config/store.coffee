env = require 'config/environment'

App.Store = FP.Store.extend
  firebaseRoot: env.get('firebaseUrl')
