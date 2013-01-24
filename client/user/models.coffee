get = Em.get
set = Em.set

App.User = DS.Model.extend

  #email: DS.attr 'string'
  is_admin: DS.attr 'boolean'

  #posts: DS.hasMany 'App.Post'
  #comments: DS.hasMany 'App.Comment'
