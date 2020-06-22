'use strict'

var BodyParser = require('body-parser')
var Express = require('express')
var Passport = require('passport')
var LocalStrategy = require('passport-local').Strategy

var localStrategy = new LocalStrategy({
    usernameField: 'username',
    passwordField: 'password'
  },
  function (username, password, done) {
    var user = users[username]
    if (user == null) {
      return done(null, false, { message: 'Invalid user' })
    }
    if (user.password !== password) {
      return done(null, false, { message: 'Invalid password' })
    }
    done(null, user)
  }
)

var users = {
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

Passport.use('local', localStrategy)

var app = Express()
app.use(BodyParser.urlencoded({ extended: false }))
app.use(BodyParser.json())
app.use(Passport.initialize())

app.get('/', function (request, response) {
  logInfo('Requested URL: ' + request.url)
  response.send(request.url)
})

app.post('/login',
  // passport.authenticate('local', { session: false }),
  function (request, response) {
    logInfo(request)
    response.send('User Id ' + request.user.id)
  }
)

var port = require('../config.json').port

app.listen(port, function () {
  logInfo('Listening on port ' + port)
})

// ///////////////////////////////////////////////////////////////////////////
// Logging

const basename = require('path').basename(__filename)

var logInfo = function (msg) {
  var timestamp = require('moment')().format('YYYY-MM-DD HH:mm:ss')
  console.log('[' + timestamp + ' INFO] (' + basename + ') ' + msg)
}
