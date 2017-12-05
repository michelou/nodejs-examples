'use strict'

var express = require('express')
var bodyParser = require('body-parser')
var http = require('http')
var methodOverride = require('method-override')
var path = require('path')
var url = require('url')

// project modules
var contacts = require('./modules/contacts')

var app = express()
var port = process.env.PORT || 8180

// all environments
app.set('port', port)
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'jade')

// app.use(express.favicon())
// app.use(express.logger('dev'))
app.use(bodyParser.urlencoded({ extended: false }))
app.use(methodOverride())
// app.use(app.router)

// eg. http://127.0.0.1:8180/contacts?firstname=Joe
app.get('/contacts', function (request, response) {
  console.log('GET /contacts')
  var get_params = url.parse(request.url, true).query
  if (Object.keys(get_params).length === 0) {
    response.setHeader('content-type', 'application/json')
    response.end(JSON.stringify(contacts.list()))
  }
  else {
    response.setHeader('content-type', 'application/json')
    response.end(JSON.stringify(
      contacts.query_by_arg(get_params.arg, get_params.value)
    ))
  }
})

// eg. http://127.0.0.1:8180/contacts/+359777123456
app.get('/contacts/:number', function (request, response) {
  var number = request.params.number
  console.log('GET /contacts/' + number)
  response.setHeader('content-type', 'application/json')
  response.end(JSON.stringify(contacts.query(number)))
})

app.get('/groups', function (request, response) {
  console.log('GET /groups')
  response.setHeader('content-type', 'application/json')
  response.end(JSON.stringify(contacts.list_groups()))
})

// See p.51
app.get('/groups1', function (request, response) {
  console.log('GET /groups1')
  response.format({
    'text/xml': function () {
      response.end(contacts.list_groups_from_xml(true))
    },
    'application/json': function () {
      response.end(JSON.stringify(contacts.list_groups_from_xml(false)))
    },
    'default': function () {
      response.status(406).send('No Acceptable')
    }
  })
})

// eg. http://127.0.0.1:8180/groups/Family
app.get('/groups/:name', function (request, response) {
  var name = request.params.name
  console.log('GET /groups/' + name)
  response.setHeader('content-type', 'application/json')
  response.end(JSON.stringify(contacts.get_members(name)))
})

// development only
function errorHandler(err, req, res, next) {
  res.status(500)
  res.render('error', { error: err })
}
if (app.get('env') === 'development') {
  app.use(errorHandler)
}

http.createServer(app).listen(port, function () {
  console.log('Module search path: ' + (process.env.NODE_PATH || '(none)'))
  console.log('Server listening on port ' + port)
})
