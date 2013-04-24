get = Em.get
set = Em.set

App.PostsRoute = Em.Route.extend

  events:

    cancelPostEdit: (post) ->
      post.transaction.rollback()
      @transitionTo 'posts.index'

    savePost: (post) ->

      that = @
      store = get post, 'store'
      controller = @controllerFor 'post'
      author = get controller, 'userController.content'

      post.validate()
      if get post, '_isValid'

        set post, 'author', author
        store.commit()

        # func to be called when creating/updating post
        saveTags = ->
          input = get controller, 'tagsInput'
          tags = get post, 'tags'
          names = input.values()

          tagsNames = tags.map (tag)->
            get tag, 'name'

          # console.log tagsNames
          # console.log names

          names = names.removeObjects tagsNames
          #console.log names
          names.forEach (name)->
            tag = App.Tag.createRecord
              name: name
              post: post
              author: author
          store.commit()

        # save tags
        if get post, 'id'
          # sync
          saveTags()

        else
          # async
          post.addObserver 'id', ->
            id = get post, 'id'
            if id
              post.removeObserver 'id'
              saveTags()

        that.transitionTo 'posts.index'

    removePost: (post)->

      controller = @controllerFor 'posts'
      store = get controller, 'store'
      console.log store

      # remove comments
      comments = get post, 'comments'
      console.log get comments, 'length'
      comments.forEach (comment)->
        console.log comment
        comment.deleteRecord()

      # remove tags
      tags = get post, 'tags'
      console.log get tags, 'length'
      tags.forEach (tag)->
        console.log tag
        tag.deleteRecord()

      #remove post
      post.deleteRecord()
      #
      store.commit()
      #@transitionTo 'posts.index'


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

App.PostIndexRoute = Em.Route.extend

  events:

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

      @transitionTo 'post.index'

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
    controller = @controllerFor 'post'
    set controller, 'comment', ''

  renderTemplate: ->
    @render 'post.index',
      controller: 'post'

App.PostEditRoute = Em.Route.extend

  renderTemplate: ->
    @render 'post.edit',
      controller: 'post'

