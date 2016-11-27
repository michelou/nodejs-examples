'use strict';

var express = require('express');
var bodyParser = require('body-parser');

var app = express();
const port = +process.env.PORT || 3000;

app.get('/', function(req, res){
  var form = '' +
    '<html>' + 
    '<head></head>' +
    '<body>' +
    '  <form method="POST" action="/calc">' +
    '    <input type="text" name="formula" placeholder="formula" />' +
    '    <input type="submit" value="Calculate" />' +
    '  </form>' +
    '</body>' + 
    '</html>';
    res.send(form);
});

app.use(bodyParser.urlencoded({extended: false}));

app.post('/calc', function (req, res) {
  var result;
  eval('result = ' + req.body.formula);
  res.send('The result is: ' + result);
});

// for testing
module.exports = app;
if (!module.parent) {
  app.listen(port, function(error) {
    console.log('Node runtime: ' + process.versions.node+' ('+process.arch+')');
    console.log("Module search path: " + (process.env.NODE_PATH || '(none)'));
    console.log('Server listening on port ' + port);
  });
}
