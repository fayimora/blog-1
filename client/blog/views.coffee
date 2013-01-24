get = Em.get
set = Em.set

App.TagsView = Em.TextField.extend
  
  didInsertElement: ->
    #@_super()

    Em.run.sync ->
      console.log document.getElementById 'tags'

    controller = get @, 'controller'
    controller = controller.controllerFor 'post'
    post = get controller , 'content'

    Pillbox = require 'pillbox'
    input = Pillbox document.getElementById 'tags'
    
    tags = get post, 'tags'
    if tags
      for tag in tags
        input.add tag

    input.on 'add', (tag)->
      console.log "adding #{tag}"
      post.tags.push tag

    input.on 'remove', (tag) ->
      console.log "removing #{tag}"
      post.tags.remove tag
