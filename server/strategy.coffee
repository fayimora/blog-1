User = require('./models').User

host = process.env.OPENSHIFT_APP_DNS
if not host
  host = 'dev:3000'
callbackURL = "http://#{host}/auth/dropbox/callback"

Strategy = require('passport-dropbox').Strategy
strategy = new Strategy
    consumerKey: process.env.DROPBOX_KEY
    consumerSecret: process.env.DROPBOX_SECRET
    callbackURL: callbackURL
  , (accessToken, secretToken, profile, done) ->
    #process.nextTick ->
    name = profile.displayName
    is_super_user = profile.id == 30162278
    user = new User
      name: name
      is_super_user: is_super_user
    user.save (err, user) ->
      return throw err if err
      tokens =
        access: accessToken
        secret: secretToken
      redis.hmset "user:#{profile.id}:tokens", tokens, (err)->
        return done err if err
        done null, user


passport = require 'passport'
passport.serializeUser (user, done) ->
  done null, user._id
passport.deserializeUser (id, done) ->
  User.findById id, (err, user) ->
    return done err if err
    done null, user
passport.use strategy


express = require 'express'
app = module.exports = express()
app.use passport.initialize()
app.use passport.session()

app.use (req, res, next) ->
  req.dbox = strategy._oauth
  next()

app.get '/auth/dropbox', passport.authenticate('dropbox'), (req, res) ->

app.get '/auth/dropbox/callback', passport.authenticate('dropbox',
  failureRedirect: '/login'
), (req, res) ->
  res.redirect '/'

app.get '/login', (req, res) ->
  res.redirect '/auth/dropbox'

app.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

app.get '/users/:id', (req, res)->
  id = req.params.id
  if id == 'me'
    user = req.user
    if not user
      return res.send ''
    return res.send "#{user._id}"
  User.findById id, (err, user) ->
    return res.send err if err
    res.send
      user: user
