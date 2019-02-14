const os = require('os')
const exec = require('child_process').exec

const config = require('../config.json')
const url = `http://${config.host}:${config.port}`

if (os.platform() === 'win32') {
  const languages = ['en', 'fr', 'de']
  for (const i in languages) {
    exec(`curl -H "User-Agent: Mozilla/5.0" --header "Accept-Language: ${languages[i]}" ${url}`, (error, stdout, stderr) => {
      if (error) {
        console.log(`exec error: ${error}`)
        return
      }
      console.log(languages[i] + ' ' + stdout)
    })
  } // for
}
