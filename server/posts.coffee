module.exports = (client)->

  ###
  GET all pages
  ###
  exports.all = (req, res) ->
    user = req.user

    pages = []

    client.smembers "users:#{user.id}:pages", (err, ids) ->

      return res.send err if err

      if ids.length is 0
        res.send
          pages: []
        return
      mutex = ids.length
      for id in ids
        do (id)->
          client.hgetall "pages:#{id}", (err, page) ->

            return res.send err if err

            page.id = id
            pages.push page
            if --mutex is 0
              res.send
                pages: pages


  ###
  GET a page
  ###
  exports.one = (req, res) ->
    user = req.user
    id = req.params.id
    page = req.body.page

    client.sismember "users:#{user.id}:pages", id, (err, ismember)->

      return res.send err if err

      if ismember is 1
        # page belongs to user
        # return page
        client.hmget "pages:#{id}", (err, page)->

          return res.send err if err
          
          res.send page
      else
        # forbidened
        res.send 403

  ###
  POST a new page
  ###
  exports.create = (req, res) ->
    user = req.user
    page = req.body.page
    # generate page id
    client.incr 'pages:count'
    client.get 'pages:count', (err, id)->

      return res.send err if err
      
      # add id to user's pages set
      client.sadd "users:#{user.id}:pages", id
      # store page
      client.hmset "pages:#{id}", page
      res.send id

  ###
  PUT changes to page :id
  ###
  exports.update = (req, res) ->
    user = req.user
    id = req.params.id
    page = req.body.page

    client.sismember "users:#{user.id}:pages", id, (err, ismember)->

      return res.send err if err
      
      if ismember is 1
        # page belongs to user
        # store page
        client.hmset "pages:#{id}", page
        res.send {}
      else
        # forbidened
        res.send 403


  ###
  DELETE page :id
  ###
  exports.remove = (req, res) ->
    user = req.user
    id = req.params.id
    
    client.sismember "users:#{user.id}:pages", id, (err, ismember)->

      return res.send err if err
      
      if ismember is 1
        # page belongs to user
        # delete page
        client.del "pages:#{id}"
        client.srem "users:#{user.id}:pages", id
        res.send {}
      else
        # forbidened
        res.send 403

  exports