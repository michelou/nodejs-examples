'use strict'

const BodyParser = require('body-parser')
const Express = require('express')
const Passport = require('passport')

const Crypto = require('crypto')
const JSONWebToken = require('jsonwebtoken')
const LocalStrategy = require('passport-local').Strategy

const users = {
  foo: {
    username: 'foo',
    password: 'bar',
    id: 1
  },
  bar: {
    username: 'bar',
    password: 'foo',
    id: 2
  }
}

const localStrategy = new LocalStrategy({
  usernameField: 'username',
  passwordField: 'password'
},
function (username, password, done) {
  const user = users[username]
  if (user == null) {
    return done(null, false, { message: 'Invalid user' })
  }
  if (user.password !== password) {
    return done(null, false, { message: 'Invalid password' })
  }
  done(null, user)
})

Passport.use('local', localStrategy)

const generateToken = function (user) {
  // The payload just contains the id of the user
  // and their username, we can verify whether the
  // claim is correct using JSONWebToken.verify
  const payload = {
    id: user.id,
    username: user.username
  }
  // Generate a random string
  // Usually this would be an app wide constant
  // But can be done both ways
  const secret = Crypto.randomBytes(128).toString('base64')

  // Create the token with a payload and secret
  const token = JSONWebToken.sign(payload, secret)
  // The user is still referencing the same object
  // in users, so no need to set it again
  // If we were using a database, we would save
  // it here
  user.secret = secret
  return token
}

const generateTokenHandler = function (request, response) {
  const user = request.user
  // Generate our token
  const token = generateToken(user)
  // Return the user a token to use
  response.send(token)
}

const app = Express()
app.use(BodyParser.urlencoded({ extended: false }))
app.use(BodyParser.json())
app.use(Passport.initialize())

app.post(
  '/login',
  Passport.authenticate('local', { session: false }),
  generateTokenHandler
)

const port = require('../config.json').port

app.listen(port, function () {
  logInfo('Listening on port ' + port)
})

// ///////////////////////////////////////////////////////////////////////////
// Logging

const basename = require('path').basename(__filename)

const logInfo = function (msg) {
  const timestamp = require('moment')().format('YYYY-MM-DD HH:mm:ss')
  console.log('[' + timestamp + ' INFO] (' + basename + ') ' + msg)
}
