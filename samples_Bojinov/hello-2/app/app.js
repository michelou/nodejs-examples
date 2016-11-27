'use strict';

var http = require('http');

var httpModule = require('./modules/http-module');

var host = httpModule.host;
var port = httpModule.port;

http.createServer(httpModule.handle_request).listen(port, host, function() {
  console.log('Node runtime: ' + process.versions.node+' ('+process.arch+')');
  console.log("Module search path: " + (process.env.NODE_PATH || '(none)'));
  console.log('Server listening on port ' + port);
});
