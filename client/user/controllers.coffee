get = Em.get
set = Em.set

App.UserController = Em.Controller.extend
  init: ->
    # sideload user
    that = @
    Em.$.ajax
      url: '/users/me'
      type: 'GET'
      contentType: 'application/json'
      success: (key) ->
        if key isnt ''
          user = App.User.find key
          set that, 'content', user
