get = Em.get
set = Em.set

DS.Model.reopen
  date: DS.attr 'date'
  author: DS.belongsTo 'App.User'

App.Comment = DS.Model.extend
  content: DS.attr 'string'
  validations:
    content: ['presence']

App.Tag = DS.Model.extend
  name: DS.attr 'string'
  validations:
    name: ['presence']

App.Post = DS.Model.extend
  title: DS.attr 'string'
  content: DS.attr 'string'
  comments: DS.hasMany 'App.Comment'
  tags: DS.hasMany 'App.Tag'
  validations:
    title: ['presence']
    content: ['presence']

App.Comment.reopen
  post: DS.belongsTo 'App.Post'
  editing: false

App.Tag.reopen
  post: DS.belongsTo 'App.Post'
