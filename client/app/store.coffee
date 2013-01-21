App.Store = DS.Store.extend
  revision: DS.CURRENT_API_REVISION
  adapter: require('ember-gae').create()
