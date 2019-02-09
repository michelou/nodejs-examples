var bodyParser = require('body-parser')
var express = require('express')
var http = require('http')
var path = require('path')
var logger = require('morgan')
var methodOverride = require('method-override')
var errorHandler = require('errorhandler')
var mongoose = require('mongoose')
var gridStream = require('gridfs-stream')
var mongoosePaginate = require('mongoose-paginate')
var expressPaginate = require('express-paginate')
var url = require('url')

mongoose.Promise = global.Promise // native promises
// mongoose.Promise = require('bluebird');

// project modules
var cleanup = require('./modules/cleanup')
var _v1 = require('./modules/contactdataservice')
var _v2 = require('./modules/contactdataservice_v2')

var app = express()
var port = process.env.PORT || 8180

// all environments
app.set('port', port)
app.set('views', path.join(__dirname, '/views'))
app.set('view engine', 'jade')
app.use(methodOverride())
app.use(bodyParser.json())
app.use(expressPaginate.middleware()) // defaults: limit=10, maxLimit=50

// development only
if (app.get('env') === 'development') {
  app.use(errorHandler())
  app.use(logger('combined'))
}

var db = require('./db.js')
var con = mongoose.connect(db.uri)

var gfs = gridStream(mongoose.connection.db, mongoose.mongo)

var contactSchema = new mongoose.Schema({
  primarycontactnumber: { type: String, index: { unique: true } },
  firstname: String,
  lastname: String,
  title: String,
  company: String,
  jobtitle: String,
  othercontactnumbers: [String],
  primaryemailaddress: String,
  emailaddresses: [String],
  groups: [String]
})
contactSchema.plugin(mongoosePaginate)
var Contact = mongoose.model('Contact', contactSchema)

app.get('/contacts/:number', function (request, response) {
  console.log(request.url + ' : querying for ' + request.params.number)
  _v1.findByNumber(Contact, request.params.number, response)
})

app.post('/contacts', function (request, response) {
  _v1.update(Contact, request.body, response)
})

app.put('/contacts', function (request, response) {
  _v1.create(Contact, request.body, response)
})

// eg. http://localhost:8180/contacts/+359777223345
app.delete('/contacts/:primarycontactnumber', function (request, response) {
  _v1.remove(Contact, request.params.primarycontactnumber, response)
})

app.get('/contacts', function (request, response) {
  /*
  console.log('Listing all contacts with '
    + request.params.key + '=' + request.params.value);
  _v1.list(Contact, response);
  */
  var get_params = url.parse(request.url, true).query
  logInfo('redirecting to /v2/contacts')
  response.writeHead(302, { 'Location': '/v2/contacts/' })
  response.end('Version 2 is found at URI /v2/contacts/ ')
})

app.get('/v2/contacts', function (request, response) {
  var get_params = url.parse(request.url, true).query
  if (Object.keys(get_params).length === 0) {
    _v2.paginate(Contact, request, response)
  }
  else {
    if (get_params['limit'] != null || get_params['page'] != null) {
      _v2.paginate(Contact, request, response)
    }
    else {
      var key = Object.keys(get_params)[0]
      var value = get_params[key]
      _v2.query_by_arg(Contact, key, value, response)
    }
  }
})

app.get('/v2/contacts/:primarycontactnumber/image', function (request, response) {
  _v2.getImage(gfs, request.params.primarycontactnumber, response)
})

app.get('/contacts/:primarycontactnumber/image', function (request, response) {
  _v2.getImage(gfs, request.params.primarycontactnumber, response)
})

app.post('/v2/contacts/:primarycontactnumber/image', function (request, response) {
  _v2.updateImage(gfs, request, response)
})

app.post('/contacts/:primarycontactnumber/image', function (request, response) {
  _v2.updateImage(gfs, request, response)
})

app.put('/v2/contacts/:primarycontactnumber/image', function (request, response) {
  _v2.updateImage(gfs, request, response)
})

app.put('/contacts/:primarycontactnumber/image', function (request, response) {
  _v2.updateImage(gfs, request, response)
})

app.delete('/v2/contacts/:primarycontactnumber/image', function (request, response) {
  _v2.deleteImage(gfs, mongodb.db, request.params.primarycontactnumber, response)
})

app.delete('/contacts/:primarycontactnumber/image', function (request, response) {
  _v2.deleteImage(gfs, mongodb.db, request.params.primarycontactnumber, response)
})

cleanup.Cleanup()

http.createServer(app).listen(port, function () {
  logInfo('Server listening on port ' + port)
})

// ///////////////////////////////////////////////////////////////////////////
// Logging

var basename = require('path').basename(__filename)

var logInfo = function (msg) {
  var timestamp = require('moment')().format('YYYY-MM-DD HH:mm:ss')
  console.log('[' + timestamp + ' INFO] (' + basename + ') ' + msg)
}
