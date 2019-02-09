// See https://github.com/mashpie/i18n-node

var http = require('http')
var i18n = require('i18n')
var path = require('path')

const config = require('../config.json')
const host = config.host
const port = +process.env.PORT || config.port

i18n.configure({
  locales: ['en', 'de', 'fr'],
  directory: path.join(__dirname, 'locales')
})

var server = http.createServer(function (req, res) {
  i18n.init(req, res)
  res.end(res.__('Hello'))
})

// eg. Error: listen EADDRINUSE :::8180
server.on('error', (error) => {
  console.log(error) // JSON.stringify(error)
})

server.listen(port, host, function (error) {
  if (error) {
    console.log(error)
    return
  }
  console.log('Node runtime: ' + process.versions.node + ' (' + process.arch + ')')
  console.log('Module search path: ' + (process.env.NODE_PATH || '(none)'))
  console.log('Server listening on port ' + port)
})
