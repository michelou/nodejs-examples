'use strict'

var cluster = require('cluster')
var http = require('http')

// Ask the number of CPU-s for optimal forking (one fork per CPU)
var numCPUs = require('os').cpus().length

const port = +process.env.PORT || 3000

if (cluster.isMaster) {
  // Fork workers.
  for (var i = 0; i < numCPUs; i++) {
    cluster.fork()
  }
  // Log when a worker exits
  cluster.on('exit', function (worker, code, signal) {
    console.log('worker ' + worker.process.pid + ' died')
  })
}
else {
  // Workers can share any TCP connection
  // In this case its a HTTP server
  const server = http.createServer(function (req, res) {
    res.writeHead(200)
    res.end('hello world\n')
  })
  server.listen(port, function (error) {
    if (error) {
      console.log(error)
      return
    }
    console.log('Node runtime: ' + process.versions.node + ' (' + process.arch + ')')
    console.log('Module search path: ' + (process.env.NODE_PATH || '(none)'))
    console.log('Server listening on port ' + port)
  })
}
