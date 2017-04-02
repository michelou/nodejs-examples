// See https://github.com/mozilla/i18n-abide
const ejs = require('ejs');
const express = require('express');
const http = require('http');
const i18n = require('i18n-abide');
const path = require('path');

const config = require('../config.json');
const host = config.host;
const port = +process.env.PORT || config.port;

const app = express();

app.set('port', port);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(i18n.abide({
  supported_languages: ['de', 'en', 'fr'],
  default_lang: 'fr',
  translation_directory: 'app/i18n'
}));

app.get('/', function (req, res) {
  console.log(req.headers['accept-language']);
  res.render('index.ejs', {
    title : req.gettext('Hello world')
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

http.createServer(app).listen(port, host, function () {
  console.log('Node runtime: ' + process.versions.node+' ('+process.arch+')');
  console.log("Module search path: " + (process.env.NODE_PATH || '(none)'));
  console.log('Server listening on port ' + port);
});
