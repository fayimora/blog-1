get = Em.get
set = Em.set

App.User = DS.Model.extend

  _email: DS.attr 'string'
  _is_admin: DS.attr 'boolean'

  #_posts: DS.hasMany 'App.Post'
  #_comments: DS.hasMany 'App.Comment'
