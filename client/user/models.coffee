get = Em.get
set = Em.set

App.User = DS.Model.extend

  #owner: DS.attr 'string'
  email: DS.attr 'string'

  #_posts: DS.hasMany 'App.Post'
  #_comments: DS.hasMany 'App.Comment'

  isAdmin: DS.attr 'boolean'
