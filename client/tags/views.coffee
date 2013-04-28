App.TagsView = Em.TextField.extend
  
  didInsertElement: ->
    @_super()

    post = @get 'controller.controllers.post.content' #/edit
    post ?= @get 'controller.controllers.posts.content' #/new

    Pillbox = require 'pillbox'
    input = Pillbox document.getElementById 'tags'
    
    # populate input with tags
    tags = post.get 'tags'

    addTags = ->
      tags.forEach (tag)->
        name = tag.get 'name'
        input.add name

    if tags.get 'isLoaded'
      addTags()

    tags.addObserver 'isLoaded', ->
      if tags.get 'isLoaded'
        tags.removeObserver 'isLoaded'
        addTags()


    input.on 'remove', (tag) ->
      #console.log "removing #{tag}"
      name = tag
      tag = tags.filterProperty 'name', name
      if tag.get 'id'
        store = tag.get 'store'
        store.deleteRecord tag
        store.commit()

    post.set 'tagsInput', input 