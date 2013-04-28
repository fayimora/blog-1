compile = Em.Handlebars.compile

Em.TEMPLATES['posts'] = compile '{{outlet}}'
Em.TEMPLATES['posts/index'] = compile require './templates/list'
Em.TEMPLATES['posts/new'] = compile require './templates/form'

Em.TEMPLATES['post'] = compile '{{outlet}}'
Em.TEMPLATES['post/index'] = compile require './templates/show'
Em.TEMPLATES['post/edit'] = compile require './templates/form'