# module dependencies

hooks = require 'node_hooks'
express = require 'express'
RedisStore = require('connect-redis')(express)
client = require('r')(env: 'REDISCLOUD_URL')
passport = require 'passport'
GitHubStrategy = require('passport-github').Strategy
jade = require('../node_modules/node_hooks/node_modules/jade').__express

# setup passport session

ID = process.env['GITHUB_ID']
SECRET = process.env['GITHUB_SECRET']

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj

passport.use new GitHubStrategy(
    clientID: ID
    clientSecret: SECRET
    callbackURL: 'http://dev:3000/auth/github/callback'
  , (accessToken, refreshToken, profile, done) ->
    process.nextTick ->
      done null, profile
)

# create express app
app = express()

# configure app
app.engine 'jade', jade
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.session(
  cookie:
    maxAge: 7 * 24 * 60 * 60 * 1000 # a week
  key: 'express.sid'
  secret: 'keyboard cat'
  store: new RedisStore(
    client: client
  )
)
app.use passport.initialize()
app.use passport.session()
app.use express.static "#{__dirname}/../"
app.use express.static "#{__dirname}/../build"

# route middleware to ensure user is authenticated
ensureAuthenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect '/login'

# routes
app.get '/', hooks, (req, res) ->
  res.render 'index',
    user: req.user

app.get '/auth/github', passport.authenticate('github'), (req, res) ->

app.get '/auth/github/callback', passport.authenticate('github',
  failureRedirect: '/login'
), (req, res) ->
  res.redirect '/'

app.get '/login', hooks, (req, res) ->
  res.redirect '/auth/github'

app.get '/logout', hooks, (req, res) ->
  req.logout()
  res.redirect '/'

# users routes
users = require('./users')(client)
app.get  '/users/:id/', ensureAuthenticated, users.me

# post routes
posts = require('./posts')(client)
app.get  '/posts', ensureAuthenticated, posts.all
app.post '/posts', ensureAuthenticated, posts.create
app.get  '/posts/:id', ensureAuthenticated, posts.one
app.put  '/posts/:id', ensureAuthenticated, posts.update
app.del  '/posts/:id', ensureAuthenticated, posts.remove

tags = require('./tags')(client)
app.get  '/tags', ensureAuthenticated, tags.all
app.post '/tags', ensureAuthenticated, tags.create
app.get  '/tags/:id', ensureAuthenticated, tags.one
app.put  '/tags/:id', ensureAuthenticated, tags.update
app.del  '/tags/:id', ensureAuthenticated, tags.remove

comments = require('./comments')(client)
app.get  '/comments', ensureAuthenticated, comments.all
app.post '/comments', ensureAuthenticated, comments.create
app.get  '/comments/:id', ensureAuthenticated, comments.one
app.put  '/comments/:id', ensureAuthenticated, comments.update
app.del  '/comments/:id', ensureAuthenticated, comments.remove

# bind
port = process.env.PORT || 3000
app.listen port, ->
  console.log "http://dev:#{port}"
