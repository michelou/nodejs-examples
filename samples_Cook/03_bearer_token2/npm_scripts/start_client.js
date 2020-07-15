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

function userInfo(token, done) {
  const endpoint = `http://${config.host}:${config.port}/userinfo`
  
  const curlOpts = `-H "Authorization: Bearer ${token}"`
  logInfo(`curl ${curlOpts} -X GET ${endpoint}`)
  exec(`curl ${curlOpts} -X GET ${endpoint}`, (error, stdout, stderr) => {
    if (error) return done(error, '')
    return done(null, stdout)
  })
}

if (os.platform() === 'win32') {
  login('foo', function(error, token) {
    if (error) {
      logInfo(`exec error: ${error}`)
      return
    }
    console.log("token=" + token)
    userInfo(token, function (error, result) {
      if (error) {
        logInfo(`exec error: ${error}`)
        return
      }
      logInfo("json=" + result)
    })
  })
}

// ///////////////////////////////////////////////////////////////////////////
// Logging

function logInfo(msg) {
  var timestamp = require('moment')().format('YYYY-MM-DD HH:mm:ss')
  console.log('[' + timestamp + ' INFO] (start_client.js) ' + msg)
}
