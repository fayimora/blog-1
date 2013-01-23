get = Em.get
set = Em.set

App.PostController = Em.Controller.extend App.UserMixin

App.PostsController = Em.ArrayController.extend App.UserMixin
