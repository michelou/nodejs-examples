'use strict'

var express = require('express')
var http = require('http')
var path = require('path')
var bodyParser = require('body-parser')
var logger = require('morgan')
var methodOverride = require('method-override')
var errorHandler = require('errorhandler')
var levelup = require('levelup')

// project modules
var cleanup = require('./modules/cleanup')
var contacts = require('./modules/contacts')

var app = express()
var port = process.env.PORT || 8180

// all environments
app.set('port', port)
app.set('views', path.join(__dirname, 'views')
app.set('view engine', 'jade')
app.use(methodOverride())
app.use(bodyParser.json())

// development only
if ('development' == app.get('env')) {
  app.use(errorHandler())
  app.use(logger('combined'))
}

var db = levelup('./contact', {valueEncoding: 'json'})
contacts.fill(db)

// eg. http://localhost:8180/contacts/%2B359777123456
app.get('/contacts/:number', function(request, response) {
  console.log('[app.js] ' + request.url + ' : querying for ' + request.params.number);
  db.get(request.params.number, function(error, data) {
    if (error) {
      response.writeHead(404, {'Content-Type' : 'text/plain'});
      response.end('Not Found');
      return;
    }
    response.setHeader('content-type', 'application/json');
    response.send(data);
  });
});

cleanup.Cleanup(function() {
  console.log('[app.js] Closing contact database (LevelDB)');
  db.close();
});

http.createServer(app).listen(port, function() {
  console.log('[app.js] Server listening on port ' + port);
});
