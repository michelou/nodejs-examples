'use strict'

var express = require('express')
var http = require('http')
var path = require('path')
var bodyParser = require('body-parser')
var logger = require('morgan')
var methodOverride = require('method-override')
var errorHandler = require('errorhandler')
var leveldown = require('leveldown')
var levelup = require('levelup')

// project modules
var cleanup = require('./modules/cleanup')
var contacts = require('./modules/contacts')

var app = express()
var port = +process.env.PORT || 8180

// all environments
app.set('port', port)
app.set('views', path.join(__dirname, 'views'))
// see https://expressjs.com/en/resources/template-engines.html
app.set('view engine', 'pug')
app.use(methodOverride())
app.use(bodyParser.json())

// development only
if (app.get('env') === 'development') {
  app.use(errorHandler())
  app.use(logger('combined'))
}

var db = levelup(leveldown('./contact'), { valueEncoding: 'json' }, function (err, db) {
  if (err) throw err
  console.log('[app.js] LevelDB connected')
})
contacts.fill(db)

// eg. http://localhost:8180/contacts/+359777123456
app.get('/contacts/:number', function (request, response) {
  var number = request.params.number
  console.log('[app.js] ' + request.url + ' : querying for ' + number)
  db.get(number, function (err, value) {
    if (err) {
      response.writeHead(404, { 'Content-Type': 'text/plain' })
      response.end('Not Found')
      return
    }
    response.setHeader('content-type', 'application/json')
    response.send('value=' + value.toString('utf8'))
  })
})

cleanup.Cleanup(function () {
  console.log('[app.js] Closing contact database (LevelDB)')
  db.close()
})

http.createServer(app).listen(port, function () {
  console.log('[app.js] Server listening on port ' + port)
})
