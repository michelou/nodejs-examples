'use strict'

var bodyParser = require('body-parser')
var express = require('express')
var favicon = require('serve-favicon')
var http = require('http')
var methodOverride = require('method-override')
var path = require('path')

var routes = require('./routes')
var user = require('./routes/user')

var app = express()
var port = +process.env.PORT || 8180

// all environments
app.set('port', port)
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'jade')

app.use(favicon(path.join(__dirname, 'public', 'images', 'favicon.ico')))
// app.use(express.logger('dev'))
app.use(bodyParser.urlencoded({ extended: false }))
app.use(methodOverride())
// app.use(app.router)
app.use(express.static(path.join(__dirname, 'public')))

// development only
function errorHandler(err, req, res, next) {
  res.status(500)
  res.render('error', { error: err })
}
if (app.get('env') === 'development') {
  app.use(errorHandler)
}

app.get('/', routes.index)
app.get('/users', user.list)

http.createServer(app).listen(port, function () {
  console.log('Module search path: ' + (process.env.NODE_PATH || '(none)'))
  console.log('Server listening on port ' + port)
})
