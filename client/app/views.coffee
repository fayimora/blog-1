App.LoaderView = Em.View.extend() # require 'ember-dots'

App.EditorView = Em.View.extend require('ember-ckedit')
  ,isInline: true