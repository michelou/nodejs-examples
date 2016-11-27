'use strict';

const http = require('http');

const config = require('../config.json');
const hostname = config.host;
const port = +process.env.PORT || config.port;

function handle_request(request, response) {
  response.writeHead(200, {'Content-Type' : 'text/plain'});
  response.end('Hello World.- Are you restless to go restful?');
  console.log('requested (' + request.method + ')');
}

http.createServer(handle_request).listen(port, hostname);

console.log('Node runtime: ' + process.versions.node+' ('+process.arch+')');
console.log("Module search path: " + (process.env.NODE_PATH || '(none)'));
console.log('Started Node.js http server at http://'+hostname+':'+port);
