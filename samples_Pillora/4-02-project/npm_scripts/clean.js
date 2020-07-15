const exec = require('child_process').exec
const fs = require('fs')
const platform = require('os').platform()

const rmdir = (platform === 'win32') ? 'rmdir /s /q' : 'rm -rf'

if (fs.existsSync('./node_modules')) {
  exec(`${rmdir} "./node_modules"`, (error, stdout, stderr) => {
    if (error) {
      console.log(`exec error: ${error}`)
      return
    }
    // console.log(stdout)
  })
}
