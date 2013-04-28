App.Comment = DS.Model.extend
  date: DS.attr 'date'
  content: DS.attr 'string'
  post: DS.belongsTo 'App.Post'
  user: DS.belongsTo 'App.User'
  editing: false
  validations:
    content: ['presence']
