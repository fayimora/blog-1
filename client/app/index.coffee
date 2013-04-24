require 'ember'
require 'ember-data'
require('ember-user')()

window.App = Em.Application.create
  rootElement: '#app'

require './store'
require './models'
require './controllers'
require './templates'
require './views'
require './router'

require 'post'
require 'user'
