App.Tag = DS.Model.extend
  date: DS.attr 'date'
  name: DS.attr 'string'
  post: DS.belongsTo 'App.Post'
  user: DS.belongsTo 'App.User'
  validations:
    name: ['presence']
