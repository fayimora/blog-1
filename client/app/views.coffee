#App.LoaderView = require 'ember-dots'

App.LoaderView = Em.View.extend()

App.EditorView = Em.View.extend require('ember-ckedit')
  #,isInline: true