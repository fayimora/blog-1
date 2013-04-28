App.User = DS.Model.extend
  name: DS.attr 'string'
  isSuperUser: DS.attr 'boolean'
