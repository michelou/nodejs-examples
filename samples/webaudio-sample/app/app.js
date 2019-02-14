// const ejs = require('ejs')
const express = require('express')
const fs = require('fs')
const path = require('path')

const config = require('../config.json')
// const host = config.host
const port = +process.env.PORT || config.port

const app = express()

app.use(express.static(path.join(__dirname, 'public')))

var filepath = path.join(__dirname, 'Paradise.m4a')

app.get('/music', function (req, res) {
  console.log('Returning ' + path.basename(filepath) + ' for request /music')
  res.set({ 'Content-Type': 'audio/mpeg' })
  var readStream = fs.createReadStream(filepath)
  readStream.pipe(res)
})

app.listen(port, function () {
  console.log('Module search path: ' + (process.env.NODE_PATH || '(none)'))
  console.log('Express server listening on port ' + port)
})
