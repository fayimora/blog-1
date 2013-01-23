get = Em.get
set = Em.set

App.Comment = DS.Model.extend
  content: DS.attr 'string'
  #
  #_date: DS.attr 'date'
  #_author: DS.belongsTo 'App.User'
  #
  validations:
    title: ['presence']

App.Tag = DS.Model.extend
  name: DS.attr 'string'
  #
  #_date: DS.attr 'date'
  #
  validations:
    name: ['presence']

App.Post = DS.Model.extend
  title: DS.attr 'string'
  content: DS.attr 'string'
  #
  #_date: DS.attr 'date'
  #_author: DS.belongsTo 'App.User'  
  _comments: DS.hasMany 'App.Comment'
  #_tags: DS.hasMany 'App.Tags'
  #
  validations:
    title: ['presence']
    content: ['presence']

App.Comment.reopen
  post: DS.belongsTo 'App.Post'

App.Tag.reopen
  post: DS.belongsTo 'App.Post'
