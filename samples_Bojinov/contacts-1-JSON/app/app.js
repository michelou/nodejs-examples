'use strict'

const express = require('express')
const bodyParser = require('body-parser')
const http = require('http')
const methodOverride = require('method-override')
const path = require('path')
const querystring = require('querystring')
const url = require('url')

// project modules
const contacts = require('./modules/contacts')

const app = express()
const port = process.env.PORT || 8180

// all environments
app.set('port', port)
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'pug')

// app.use(express.favicon())
// app.use(express.logger('dev'))
app.use(bodyParser.urlencoded({ extended: false }))
app.use(methodOverride())
// app.use(app.router)

// eg. http://127.0.0.1:8180/contacts?firstname=Joe
app.get('/contacts', function (request, response) {
  console.log('GET ' + request.url)
  var get_params = request.query
  if (Object.keys(get_params).length === 0) {
    response.setHeader('content-type', 'application/json')
    response.end(JSON.stringify(contacts.list()))
  }
  else {
    var arg = Object.keys(get_params)[0]
    response.setHeader('content-type', 'application/json')
    response.end(JSON.stringify(
      contacts.query_by_arg(arg, get_params[arg])
    ))
  }
})

// eg. http://127.0.0.1:8180/contacts/+359777123456
app.get('/contacts/:number', function (request, response) {
  const number = request.params.number
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
      response.setHeader('content-type', 'text/xml')
      response.end(contacts.list_groups_from_xml(true))
    },
    'application/json': function () {
      response.setHeader('content-type', 'application/json')
      response.end(JSON.stringify(contacts.list_groups_from_xml(false)))
    },
    default: function () {
      response.status(406).send('No Acceptable')
    }
  })
})

// eg. http://127.0.0.1:8180/groups/Family
app.get('/groups/:name', function (request, response) {
  const name = request.params.name
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
