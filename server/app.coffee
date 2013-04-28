hooks = require 'node_hooks'
jade = require('node_hooks/node_modules/jade').__express

embermongoose = require 'ember-mongoose'
global.mongo = require './mongo'
global.redis = require './redis'
models = require './models'

express = require 'express'
app = module.exports = express()

app.engine 'jade', jade
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'

app.use express.favicon()
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()
app.use require './session'
app.use require './strategy'
app.use express.static "#{__dirname}/../build"
app.use embermongoose [
  models.Tag
  models.User
  models.Post
  models.Comment
]

app.get '/', hooks, (req, res) ->
  res.render 'index'
