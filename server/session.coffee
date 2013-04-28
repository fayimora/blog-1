express = require 'express'

RedisStore = require('connect-redis')(express)

app = module.exports = express()
app.use express.session(
  cookie:
    maxAge: 7 * 24 * 60 * 60 * 1000 # a week
  key: 'express.sid'
  secret: 'development secret'
  store: new RedisStore(
    client: redis
  )
)