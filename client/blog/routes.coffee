get = Em.get
set = Em.set

App.PostsRoute = Em.Route.extend

  events:

    cancelPostEdit: (post) ->
      post.transaction.rollback()
      @transitionTo 'posts.index'

    savePost: (post) ->
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

App.PostsPostRoute = Em.Route.extend()

App.PostIndexRoute = Em.Route.extend

  events:

    newComment: (post)->

      comment = App.Comment.createRecord()
      controller = @controllerFor 'post'
      set controller, 'comment', comment

    saveComment: (post)->

      controller = @controllerFor 'post'
      comment = get controller, 'comment'
      #comment.validate()
      #if get comment, '_isValid'
      set comment, 'post', post
      comment.transaction.commit()
      @send 'newComment'

  setupController: (controller, model)->
    @_super()
    @send 'newComment'
  
  renderTemplate: ->
    @render 'post.index',
      controller: 'post'

App.PostEditRoute = Em.Route.extend

  renderTemplate: ->
    @render 'post.edit',
      controller: 'post'

