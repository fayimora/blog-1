###
App.PostsRoutes = Em.Route.extend
  
  route: '/posts'

  addPost: Em.Route.transitionTo 'posts.add'
  editPost: Em.Route.transitionTo 'posts.edit'
  deletePost: Em.Route.transitionTo 'posts.delete'

  addComment: Em.Route.transitionTo 'post.comment.add'
  editComment: Em.Route.transitionTo 'posts.comment.edit'
  deleteComment: Em.Route.transitionTo 'posts.comment.delete'

  cancelPost: (router, event) ->
    post = event.context
    post.transaction.rollback()
    router.transitionTo 'index'

  savePost: (router, event) ->
    post = event.context
    #post.validate()
    if get post, '_isValid'
      post.transaction.commit()
      router.transitionTo 'index'

  connectOutlets: (router, context)->

  index: Em.Route.extend
    route: '/'
    connectOutlets: (router, context) ->
      posts = App.store.find App.Post
      ac = get router, 'applicationController'
      ac.connectOutlet 'posts', posts

  add: Em.Route.extend
    route: '/new'
    connectOutlets: (router, context) ->
      
      post = App.store.createRecord App.Post
      ac = get router, 'applicationController'
      ac.connectOutlet 'post', post

    unroutePath: (router, path) ->
      transaction = get router, 'postController.transaction'
      transaction.rollback()
      @_super router, path

  edit: Em.Route.extend

    route: '/:post_id'
    connectOutlets: (router, post) ->
      ac = get router, 'applicationController'
      ac.connectOutlet 'post', post

    unroutePath: (router, path) ->
      transaction = get router, 'postController.transaction'
      transaction.rollback()
      @_super router, path

###


get = Em.get
set = Em.set

App.PostsRoute = Em.Route.extend

  events:

    cancel: (post) ->
      console.log post
      post.transaction.rollback()
      @transitionTo 'posts.index'

    save: (post) ->
      post.validate()
      if get post, '_isValid'
        post.transaction.commit()
        @transitionTo 'posts.index'

    removePost: (post)->
      store = get post, 'store'
      store.deleteRecord post
      store.commit()
      @transitionTo 'posts.index'


App.PostsIndexRoute = Em.Route.extend

  model: ->
    App.Post.find()

  setupController: (controller, model)->
    controller = @controllerFor 'posts'
    set controller, 'content', model

  renderTemplate: ->
    @render 'posts.index',
      controller: 'posts'

App.PostsNewRoute = Em.Route.extend
  
  model: ->
    App.Post.createRecord()

  setupController: (controller, model)->
    controller = @controllerFor 'post'
    set controller, 'content', model

  renderTemplate: ->
    @render 'posts.new',
      controller: 'post'

App.PostsPostRoute = Em.Route.extend
  
  renderTemplate: ->
    console.log @

###
  model: (id)->
    App.Post.find id

  setupController: (controller, model)->
    controller = @controllerFor 'filters'
    set controller, 'selected', model.slug

  renderTemplate: ->
    @render 'todos.list',
      controller: 'todos'
  
  serialize: (model, params)->
    slug: model.slug

  deserialize: (params)->
    params
###

App.PostIndexRoute = Em.Route.extend

  renderTemplate: ->
    console.log @
    @render 'post.index',
      controller: 'post'

App.PostEditRoute = Em.Route.extend

  renderTemplate: ->
    console.log @
    @render 'post.edit',
      controller: 'post'

