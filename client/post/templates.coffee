compile = Em.Handlebars.compile

Em.TEMPLATES['posts'] = compile require './templates/posts'
Em.TEMPLATES['posts/index'] = compile require './templates/posts_index'
Em.TEMPLATES['posts/new'] = compile require './templates/post_form'

Em.TEMPLATES['post'] = compile require './templates/post'
Em.TEMPLATES['post/index'] = compile require './templates/post_index'
Em.TEMPLATES['post/edit'] = compile require './templates/post_form'