var express = require('express');
var fs = require('fs');
var ejs = require('ejs');
var path = require('path');

var app = express();
var port = process.env.PORT || 8000;

app.use(express.static(__dirname + '/public'));

var filepath = path.join(__dirname, 'Paradise.m4a');

app.get('/music', function(req, res){
  res.set({'Content-Type': 'audio/mpeg'});
  var readStream = fs.createReadStream(filepath);
  readStream.pipe(res);
});

app.listen(port, function() {
  console.log("Module search path: "+(process.env.NODE_PATH || '(none)'));
  console.log('Express server listening on port ' + port);
});