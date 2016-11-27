var express = require('express')
  , http = require('http')
  , path = require('path')
  , bodyParser = require('body-parser')
  , logger = require('morgan')
  , methodOverride = require('method-override')
  , errorHandler = require('errorhandler');

// project modules
var cleanup = require('./modules/cleanup');
var dataservice = require('./modules/contactdataservice');
var Contact = dataservice.Contact;

var app = express();
var port = process.env.PORT || 8180;

// all environments
app.set('port', port);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(methodOverride());
app.use(bodyParser.json());

// development only
if ('development' == app.get('env')) {
    app.use(errorHandler());
	app.use(logger('combined'));
}

app.get('/contacts/:number', function(request, response) {
    logInfo(request.url + ' : querying for ' + request.params.number);
    dataservice.findByNumber(Contact, request.params.number, response);
});

app.post('/contacts', function(request, response) {
    dataservice.update(Contact, request.body, response)
});

app.put('/contacts', function(request, response) {
    dataservice.create(Contact, request.body, response)
});

app.delete('/contacts/:primarycontactnumber', function(request, response) {
    dataservice.remove(Contact, request.params.primarycontactnumber, response);
});

app.get('/contacts', function(request, response) {
    logInfo('Listing all contacts with '
	    + request.params.key + '=' + request.params.value);
    dataservice.list(Contact, response);
});

cleanup.Cleanup();

http.createServer(app).listen(port, function() {
    logInfo("Module search path: " + (process.env.NODE_PATH || '(none)'));
    logInfo('Server listening on port ' + port);
});

//////////////////////////////////////////////////////////////////////////////
// Logging

var basename = require('path').basename(__filename);

var logInfo = function(msg) {
  var timestamp = require('moment')().format('YYYY-MM-DD HH:mm:ss');
  console.log('['+timestamp+' INFO] ('+basename+') ' + msg);
};
