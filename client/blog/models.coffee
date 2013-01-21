get = Em.get
set = Em.set

App.Comment = DS.Model.extend
  date: DS.attr 'date'
  title: DS.attr 'string'
  author: DS.belongsTo 'App.User'

App.Tag = DS.Model.extend
  date: DS.attr 'date'
  name: DS.attr 'string'

App.Post = DS.Model.extend
  _date: DS.attr 'date'
  title: DS.attr 'string'
  content: DS.attr 'string'
  ###
  _author: DS.belongsTo 'App.User'  
  _comments: DS.hasMany 'App.Comment'
  _tags: DS.hasMany 'App.Tags'
  ###
  validations:
    title: ['presence']
    content: ['presence']

App.Comment.reopen
  post: DS.belongsTo 'App.Post'

App.Tag.reopen
  post: DS.belongsTo 'App.Post'
