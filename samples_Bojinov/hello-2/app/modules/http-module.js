'use strict'

const config = require('../../config.json')
exports.host = config.host
exports.port = +process.env.PORT || config.port

function handle_GET_request(request, response) {
  response.writeHead(200, { 'Content-Type': 'text/plain' })
  response.end('Get action was requested')
}

function handle_POST_request(request, response) {
  var body = ''
  request.on('data', function (chunk) {
    body += chunk.toString()
  }).on('end', function () {
    response.writeHead(200, { 'Content-Type': 'text/plain' })
    response.end('Post action was requested (' + body + ')\n')
  })
}

function handle_PUT_request(request, response) {
  response.writeHead(200, { 'Content-Type': 'text/plain' })
  response.end('Put action was requested')
}

function handle_HEAD_request(request, response) {
  response.writeHead(200, { 'Content-Type': 'text/plain' })
  response.end('Head action was requested')
}

function handle_DELETE_request(request, response) {
  response.writeHead(200, { 'Content-Type': 'text/plain' })
  response.end('Delete action was requested')
}

function handle_bad_request(request, response) {
  response.writeHead(400, { 'Content-Type': 'text/plain' })
  response.end('Bad request\n')
}

exports.handle_request = function (request, response) {
  switch (request.method) {
    case 'GET':
      handle_GET_request(request, response)
      break
    case 'POST':
      handle_POST_request(request, response)
      break
    case 'PUT':
      handle_PUT_request(request, response)
      break
    case 'DELETE':
      handle_DELETE_request(request, response)
      break
    case 'HEAD':
      handle_HEAD_request(request, response)
      break
    default:
      handle_bad_request(request, response)
      break
  }
  console.log(request.method + ' request processing by http-module ended')
}
