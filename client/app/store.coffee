App.Adapter = require 'ember-nosql'
App.Store = DS.Store.extend
  revision: DS.CURRENT_API_REVISION
  adapter: 'App.Adapter'
