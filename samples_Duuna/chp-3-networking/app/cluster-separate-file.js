'use strict'

var cluster = require('cluster')
var path = require('path')

// Ask the number of CPU-s for optimal forking (one fork per CPU)
var numCPUs = require('os').cpus().length

cluster.setupMaster({
  exec: path.join(__dirname, 'cluster-main.js') // Points to the index file you want to fork
})

// Fork workers.
for (var i = 0; i < numCPUs; i++) {
  cluster.fork()
}
// Log when a worker exits
cluster.on('exit', function (worker, code, signal) {
  console.log('worker ' + worker.process.pid + ' died')
})
