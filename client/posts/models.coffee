App.Post = DS.Model.extend
  date: DS.attr 'date'
  title: DS.attr 'string'
  content: DS.attr 'string'
  comments: DS.hasMany 'App.Comment'
  tags: DS.hasMany 'App.Tag'
  validations:
    title: ['presence']
    content: ['presence']
