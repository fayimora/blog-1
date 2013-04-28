require 'ember'
require 'ember-data'
require('ember-user')()

window.App = Em.Application.create
  rootElement: '#app'

require './store'
require './models'
require './templates'
require './views'
require './router'

require 'users'
require 'posts'
require 'tags'
require 'comments'