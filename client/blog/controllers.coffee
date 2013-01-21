get = Em.get
set = Em.set

App.PostController = Em.Controller.extend()

App.PostsController = Em.ArrayController.extend

  needs: 'user'
  
  userController: Em.computed ->
    @controllerFor 'user'
