var express = require('express')

var app = express()

const config = require('../config.json')
const host = config.host
const port = process.env.PORT || config.port

app.get('/hello', function (request, response) {
  response.send('Hello route')
})

app.get('/hallo/:name', function (request, response) {
  response.send('Hallo ' + request.params.name)
})

// eg. http://127.0.0.1:8180/salut?name=tom
app.get('/salut', function (request, response) {
  // var get_params = url.parse(request.url, true).query
  const get_params = request.query
  response.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' })
  if (Object.keys(get_params).length === 0) {
    response.end('Salut à tous')
  }
  else {
    response.end('Salut ' + get_params.name)
  }
})

app.listen(port, host, function () {
  console.log('Node runtime: ' + process.versions.node + ' (' + process.arch + ')')
  console.log('Module search path: ' + (process.env.NODE_PATH || '(none)'))
  console.log('Server listening at ' + host + ':' + port)
  console.log('(press Ctrl-C to kill the application)')
})
