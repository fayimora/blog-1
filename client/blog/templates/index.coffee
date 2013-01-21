compile = Em.Handlebars.compile
Em.TEMPLATES['posts/index'] = compile require './posts/index'
Em.TEMPLATES['posts/new'] = compile require './posts/new'
Em.TEMPLATES['post/index'] = compile require './post/index'
Em.TEMPLATES['post/edit'] = compile require './post/edit'