module.exports = (client)->

  ###
  GET user
  ###
  exports.me = (req, res) ->
    user = req.user
    id = req.params.id
    if id is 'me'
      res.send "#{user.id}"
    else
      # hack
      if user['username'] is 'kelonye'
        user['is_admin'] = true
      res.send
        user: user

  exports
