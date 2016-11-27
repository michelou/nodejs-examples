// See https://github.com/mashpie/i18n-node
var eps = require('ejs');
var express = require('express');
var http = require('http');
var i18n = require('i18n-abide');
var path = require('path');

const config = require('../config.json');
const host = config.host;
const port = +process.env.PORT || config.port;

var app = express();

app.set('port', port);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(i18n.abide({
  supported_languages: ['de', 'en'],
  default_lang: 'en',
  translation_directory: 'app/locales'
}));

app.get('/', function(req, res){
  res.render('index.ejs', {
    title: req.gettext('Hello world')
  })
});

// development only
function errorHandler(err, req, res, next) {
  res.status(500);
  res.render('error', { error: err });
}
if ('development' == app.get('env')) {
    app.use(errorHandler);
}

http.createServer(app).listen(port, host, function() {
  console.log('Node runtime: ' + process.versions.node+' ('+process.arch+')');
  console.log("Module search path: " + (process.env.NODE_PATH || '(none)'));
  console.log('Server listening on port ' + port);
});
