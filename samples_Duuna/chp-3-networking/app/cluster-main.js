'use strict';

var http = require('http');
const port = +process.env.PORT || 3000;

var server = http.createServer(function(req, res) {
  res.writeHead(200);
  res.end("hello world\n");
});
server.listen(port, function(error) {
  console.log('Node runtime: ' + process.versions.node+' ('+process.arch+')');
  console.log("Module search path: " + (process.env.NODE_PATH || '(none)'));
  console.log('Server listening on port ' + port);
});
