App.TagsView = Em.TextField.extend
  
  didInsertElement: ->
    @_super()

    controller = @get 'controller.controllers.post' #/edit
    controller ?= @get 'controller' #/new
    post = controller.get 'content'

    Pillbox = require 'pillbox'
    input = Pillbox document.getElementById 'tags'
    
    # populate input with tags
    
    post.onhas 'tags.isLoaded', ->

      tags = post.get 'tags'
      tags.forEach (tag)->
        name = tag.get 'name'
        input.add name

      input.on 'remove', (tag) ->
        name = tag
        tag = tags.filterProperty 'name', name
        if tag.get 'id'
          store = tag.get 'store'
          store.deleteRecord tag
          store.commit()

      post.set 'tagsInput', input