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
var port = process.env.PORT || 8180

// all environments
app.set('port', port)
app.set('views', path.join(__dirname, '/views'))
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
  console.log("LevelDB connected")
})
contacts.fill(db)

// eg. http://localhost:8180/contacts/+359777123456
app.get('/contacts/:number', function (request, response) {
  console.log(request.url + ' : querying for ' + request.params.number)
  db.get(request.params.number, function (error, data) {
    if (error) {
      response.writeHead(404, { 'Content-Type': 'text/plain' })
      response.end('Not Found')
      return
    }
    response.setHeader('content-type', 'application/json')
    response.send(data)
  })
})

app.post('/contacts/:number', function (request, response) {
  console.log('Adding new contact with primary number' + request.params.number)
  db.put(request.params.number, request.body, function (error) {
    if (error) {
      response.writeHead(500, { 'Content-Type': 'text/plain' })
      response.end('Internal server error')
      return
    }
    response.send(request.params.number + ' successfully inserted')
  })
})

app.delete('/contacts/:number', function (request, response) {
  console.log('Deleting contact with primary number' + request.params.number)
  db.del(request.params.number, function (error) {
    if (error) {
      response.writeHead(500, { 'Content-Type': 'text/plain' })
      response.end('Internal server error')
      return
    }
    response.send(request.params.number + ' successfully deleted')
  })
})

app.get('/contacts', function (request, response) {
  console.log('Listing all contacts')
  var is_first = true
  response.setHeader('content-type', 'application/json')
  db.createReadStream()
    .on('data', function (data) {
      console.log(data.value)
      if (is_first === true) {
        response.write('[')
      }
      else {
        response.write(',')
      }
      response.write(JSON.stringify(data.value))
      is_first = false
    })
    .on('error', function (error) {
      console.log('Error while reading', error)
    })
    .on('close', function () {
      console.log('Closing db stream')
    })
    .on('end', function () {
      console.log('Db stream closed')
      response.end(']')
    })
})

cleanup.Cleanup(function () {
  console.log('Closing contact database (LevelDB)')
  db.close()
})

http.createServer(app).listen(port, function () {
  console.log('Running at port ' + port)
})
