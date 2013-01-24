get = Em.get
set = Em.set

App.PostsRoute = Em.Route.extend

  events:

    cancelPostEdit: (post) ->
      post.transaction.rollback()
      @transitionTo 'posts.index'

    savePost: (post) ->

      controller = @controllerFor 'post'
      author = get controller, 'userController.content'

      set post, 'author', author
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

    newComment: ->

      controller = @controllerFor 'post'
      set controller, 'comment', ''

    createComment: (post)->

      controller = @controllerFor 'post'
      content = get controller, 'comment'

      author = get controller, 'userController.content'

      comment = App.Comment.createRecord
        content: content
        post: post
        author: author
      #comment.validate()
      #if get comment, '_isValid'
      comment.transaction.commit()

      @send 'newComment'

    updateComment: (comment) ->
      #comment.validate()
      #if get comment, '_isValid'
      comment.transaction.commit()
      set comment, 'editing', false

    cancelCommentUpdate: (comment) ->
      comment.transaction.rollback()
      set comment, 'editing', false

    editComment: (comment)->
      set comment, 'editing', true
      
    removeComment: (comment)->
      console.log comment
      store = get comment, 'store'
      store.deleteRecord comment
      store.commit()

  setupController: (controller, model)->
    @_super controller, model
    @send 'newComment'
  
  renderTemplate: ->
    @render 'post.index',
      controller: 'post'

App.PostEditRoute = Em.Route.extend

  renderTemplate: ->
    @render 'post.edit',
      controller: 'post'

