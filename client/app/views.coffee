Em.TextSupport.reopen require 'ember-error-support'
#App.LoaderView = require 'ember-dots'

App.LoaderView = Em.View.extend()

App.EditorView = Em.View.extend require('ember-error-support'), require('ember-ckedit')
  ,isInline: true