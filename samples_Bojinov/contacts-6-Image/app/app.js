var express = require('express')
  , http = require('http')
  , path = require('path')
  , bodyParser = require('body-parser')
  , logger = require('morgan')
  , methodOverride = require('method-override')
  , errorHandler = require('errorhandler')
  , mongoose = require('mongoose')
  , gridStream = require('gridfs-stream');

// project modules
var cleanup = require('./modules/cleanup');
var _v1 = require('./modules/contactdataservice');
var _v2 = require('./modules/contactdataservice_v2');

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

var db = require('./db.js');
var con = mongoose.connect(db.uri);

var gfs = gridStream(mongoose.connection.db, mongoose.mongo);

var contactSchema = new mongoose.Schema({
    primarycontactnumber: {type: String, index: {unique: true}},
    firstname: String,
    lastname: String,
    title: String,
    company: String,
    jobtitle: String,
    othercontactnumbers: [String],
    primaryemailaddress: String,
    emailaddresses: [String],
    groups: [String]
});
var Contact = mongoose.model('Contact', contactSchema);

app.get('/contacts/:number', function(request, response) {
    console.log(request.url + ' : querying for ' + request.params.number);
    _v1.findByNumber(Contact, request.params.number, response);
});

app.post('/contacts', function(request, response) {
    _v1.update(Contact, request.body, response)
});

app.put('/contacts', function(request, response) {
    _v1.create(Contact, request.body, response)
});

// eg. http://localhost:8180/contacts/+359777223345
app.delete('/contacts/:primarycontactnumber', function(request, response) {
    _v1.remove(Contact, request.params.primarycontactnumber, response);
});

app.get('/contacts', function(request, response) {
    console.log('Listing all contacts with '
	    + request.params.key + '=' + request.params.value);
    _v1.list(Contact, response);
});

app.get('/v2/contacts/:primarycontactnumber/image', function(request, response){
    _v2.getImage(gfs, request.params.primarycontactnumber, response);
})

app.get('/contacts/:primarycontactnumber/image', function(request, response){
    _v2.getImage(gfs, request.params.primarycontactnumber, response);
})

app.post('/v2/contacts/:primarycontactnumber/image', function(request, response){
    _v2.updateImage(gfs, request, response);
})

app.post('/contacts/:primarycontactnumber/image', function(request, response){
    _v2.updateImage(gfs, request, response);
})

app.put('/v2/contacts/:primarycontactnumber/image', function(request, response){
    _v2.updateImage(gfs, request, response);
})

app.put('/contacts/:primarycontactnumber/image', function(request, response){
    _v2.updateImage(gfs, request, response);
})

app.delete('/v2/contacts/:primarycontactnumber/image', function(request, response){
    _v2.deleteImage(gfs, mongodb.db, request.params.primarycontactnumber, response);
})

app.delete('/contacts/:primarycontactnumber/image', function(request, response){
    _v2.deleteImage(gfs, mongodb.db, request.params.primarycontactnumber, response);
})

cleanup.Cleanup();

http.createServer(app).listen(port, function() {
    console.log("Module search path: " + (process.env.NODE_PATH || '(none)'));
    console.log('Server listening on port ' + port);
});
