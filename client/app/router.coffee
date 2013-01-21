App.Router.map ->

  @resource 'posts'
  , path: '/'
  , ->
    @route 'new'
    @resource 'post'
    , path: ':post_id'
    , ->
      @route 'edit'