const os = require('os')
const exec = require('child_process').exec

const config = require('../config.json')

function login(username, done) {
  const endpoint = `http://${config.host}:${config.port}/login`
  logInfo("login: username=" + username)

  const curlOpts = '-H "User-Agent: Mozilla/5.0" -H "Content-Type: application/json"'
  const payload = `{"username": "${username}", "password":"bar"}`.replace(/\"/g,'\\"')
  logInfo(`curl ${curlOpts} -X POST -d "${payload}" ${endpoint}`)
  exec(`curl ${curlOpts} -X POST -d "${payload}" ${endpoint}`, (error, stdout, stderr) => {
    if (error) return done(error, '')
    return done(null, stdout)
  })
}

login('foo', function(error, token) {
  if (error) {
    logInfo(`exec error: ${error}`)
    return
  }
  console.log("token=" + token)
})

// ///////////////////////////////////////////////////////////////////////////
// Logging

function logInfo(msg) {
  var timestamp = require('moment')().format('YYYY-MM-DD HH:mm:ss')
  console.log('[' + timestamp + ' INFO] (start_client.js) ' + msg)
}
