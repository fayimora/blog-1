App.PostsRoute = Em.Route.extend

  model: ->
    App.Post.find()

  events:

    cancelPostUpdate: (post) ->
      post.transaction.rollback()
      @transitionTo 'posts.index'

    savePost: (post) ->

      store = post.get 'store'

      # update content
      editor = post.get 'editor'
      post.set 'content', editor.getData()

      post.validate()
      if post.get '_isValid'
        store.commit()

        post.onhas 'id', ->
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

        @transitionTo 'posts.index'

    removePost: (post)->
      store = post.get 'store'
      store.deleteRecord post
      store.commit()
      @transitionTo 'posts.index'

App.PostsIndexRoute = Em.Route.extend()

App.PostsNewRoute = Em.Route.extend

  model: ->
    App.Post.createRecord()

App.PostRoute = Em.Route.extend

  events:

    createComment: (post)->

      controller = @controllerFor 'post'
      content = controller.get 'comment'

      # update content
      editor = post.get 'editor'
      content = editor.getData()

      comment = App.Comment.createRecord
        content: content
        post: post

      comment.validate()
      if comment.get '_isValid'
        editor.setData ''
        comment.transaction.commit()

    cancelCommentUpdate: (comment) ->
      comment.transaction.rollback()
      comment.set 'editing', false

    startCommentUpdate: (comment)->
      comment.set 'editing', true

    updateComment: (comment) ->
      editor = comment.get 'editor'
      content = editor.getData()
      comment.set 'content', content
      comment.validate()
      if comment.get '_isValid'
        comment.transaction.commit()
        comment.set 'editing', false

    removeComment: (comment)->
      store = comment.get 'store'
      store.deleteRecord comment
      store.commit()

App.PostIndexRoute = Em.Route.extend()
