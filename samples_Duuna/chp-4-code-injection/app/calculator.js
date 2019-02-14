'use strict'

const express = require('express')
const bodyParser = require('body-parser')
const safeEval = require('safe-eval')

const app = express()
const port = +process.env.PORT || 3000

app.get('/', function (req, res) {
  var form = `
    <html>
    <head>
      <title>Calculator</title>
    </head>
    <body>
      <form method="POST" action="/calc">
        <input type="text" name="formula" placeholder="formula" autofocus="true" />
        <input type="submit" value="Calculate" />
      </form>
    </body>
    </html>`
  res.send(form)
})

app.use(bodyParser.urlencoded({ extended: false }))

app.post('/calc', function (req, res) {
  var result = safeEval(req.body.formula)
  res.send('The result is: ' + result)
})

var server = app.listen(port, function (error) {
  if (error) {
    console.log(error)
    return
  }
  console.log('Node runtime: ' + process.versions.node + ' (' + process.arch + ')')
  console.log('Module search path: ' + (process.env.NODE_PATH || '(none)'))
  console.log('Server listening on port ' + port)
})

if (require.main !== module) {
  // for testing
  exports.server = server
}
