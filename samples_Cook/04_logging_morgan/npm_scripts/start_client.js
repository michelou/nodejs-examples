const exec = require('child_process').exec

const config = require('../config.json')

function getInfo(done) {
  const endpoint = `http://${config.host}:${config.port}/info`
  
  const curlOpts = `-H "User-Agent: Mozilla/5.0"`
  logInfo(`curl ${curlOpts} -X GET ${endpoint}`)
  exec(`curl ${curlOpts} -X GET ${endpoint}`, (error, stdout, stderr) => {
    if (error) return done(error, '')
    return done(null, stdout)
  })
}

getInfo(function (error, json) {
  if (error) {
    logInfo(`exec error: ${error}`)
    return
  }
  logInfo("json=" + json)
})

// ///////////////////////////////////////////////////////////////////////////
// Logging

function logInfo(msg) {
  var timestamp = require('moment')().format('YYYY-MM-DD HH:mm:ss')
  console.log('[' + timestamp + ' INFO] (start_client.js) ' + msg)
}
