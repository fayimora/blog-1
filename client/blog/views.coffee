get = Em.get
set = Em.set

App.TagsView = Em.TextField.extend
  
  didInsertElement: ->
    @_super()

    controller = get @, 'controller'
    controller = controller.controllerFor 'post'
    post = get controller , 'content'
    author = get controller, 'userController.content'

    Pillbox = require 'pillbox'
    input = Pillbox document.getElementById 'tags'
    
    # populate input with tags
    tags = get post, 'tags'

    addTags = ->
      #console.log get tags, 'isLoaded'
      #console.log get tags, 'length'
      tags.forEach (tag)->
        name = get tag, 'name'
        input.add name

    if get tags, 'isLoaded'
      addTags()

    tags.addObserver 'isLoaded', ->
      if get tags, 'isLoaded'
        tags.removeObserver 'isLoaded'
        addTags()


    input.on 'remove', (tag) ->
      #console.log "removing #{tag}"
      name = tag
      tag = tags.filterProperty 'name', name
      if get tag, 'id'
        store = get tag, 'store'
        store.deleteRecord tag
        store.commit()

    set controller, 'tagsInput', input 