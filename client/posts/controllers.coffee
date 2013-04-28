
App.PostsController = Em.ArrayController.extend()
App.PostController = Em.ObjectController.extend()

App.PostsIndexController = Em.Controller.extend
  needs: ['posts']
App.PostsNewController = Em.Controller.extend
  needs: ['posts']
App.PostIndexController = Em.Controller.extend
  needs: ['post']
App.PostEditController = Em.Controller.extend
  needs: ['post']
