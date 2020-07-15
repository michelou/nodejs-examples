var Http = require('http')
var Morgan = require('morgan')
var Router = require('router')

var router = new Router()
router.use(Morgan('tiny'))

var port = require('../config.json').port

/* Simple server */
Http.createServer(function (request, response) {
  router(request, response, function (error) {
    if (!error) {
      response.writeHead(404)
    }
    else {
      // Handle errors
      console.log(error.message, error.stack)
      response.writeHead(400)
    }
    response.end('\n')
  })
}).listen(port)

console.log(`Server running on port ${port}`)

function getInfo(request, response) {
  var info = process.versions
  info = JSON.stringify(info)
  response.writeHead(200, { 'Content-Type': 'application/json' })
  response.end(info)
}
router.get('/info', getInfo)
