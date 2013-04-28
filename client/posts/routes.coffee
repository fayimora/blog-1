App.PostsRoute = Em.Route.extend

  model: ->
    App.Post.find()

  events:

    cancelPostEdit: (post) ->
      post.transaction.rollback()
      @transitionTo 'posts.index'

    savePost: (post) ->

      that = @
      controller = @controllerFor 'posts'
      store = post.get 'store'

      # update content
      editor = post.get 'editor'
      post.set 'content', editor.getData()

      post.validate()
      if post.get '_isValid'
        store.commit()

        # func to be called when creating/updating post
        saveTags = ->
          input = post.get 'tagsInput'
          tags = post.get 'tags'
          names = input.values()

          tagsNames = tags.map (tag)->
            tag.get 'name'

          names = names.removeObjects tagsNames
          names.forEach (name)->
            tag = App.Tag.createRecord
              name: name
              post: post
          store.commit()

        # save tags
        if post.get 'id'
          # sync
          saveTags()

        else
          # async
          post.addObserver 'id', ->
            id = post.get 'id'
            if id
              post.removeObserver 'id'
              saveTags()

        that.transitionTo 'posts.index'

    removePost: (post)->

      controller = @controllerFor 'posts'
      store = controller.get 'store'
  
      # remove comments
      comments = post.get 'comments'
      for comment in comments
        comment.deleteRecord()

      # remove tags
      tags = post.get 'tags'
      for tag in tags
        tag.deleteRecord()

      #remove post
      post.deleteRecord()
      #
      store.commit()
      #@transitionTo 'posts.index'

App.PostsIndexRoute = Em.Route.extend()

App.PostsNewRoute = Em.Route.extend

  model: ->
    App.Post.createRecord()

App.PostRoute = Em.Route.extend

  events:

    createComment: (post)->

      controller = @controllerFor 'post'
      content = controller.get 'comment'
      user = controller.get 'user'

      # update content
      editor = post.get 'editor'
      content = editor.getData()

      comment = App.Comment.createRecord
        content: content
        post: post
        user: user
      #comment.validate()
      #if comment.get '_isValid'
      comment.transaction.commit()

      @transitionTo 'post.index'

    updateComment: (comment) ->
      #comment.validate()
      #if comment.get '_isValid'
      comment.transaction.commit()
      comment.set 'editing', false

    cancelCommentUpdate: (comment) ->
      comment.transaction.rollback()
      comment.set 'editing', false

    editComment: (comment)->
      comment.set 'editing', true
      
    removeComment: (comment)->
      console.log comment
      store = comment.get 'store'
      store.deleteRecord comment
      store.commit()

App.PostIndexRoute = Em.Route.extend()
