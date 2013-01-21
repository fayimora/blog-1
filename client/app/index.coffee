require 'ember'
require 'ember-data'

window.App = Em.Application.create
  rootElement: '#app'

require './models'
require './controllers'
require './views'
require './store'

require 'blog'
require 'user'

require './router'
