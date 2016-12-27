const os = require('os');
const exec = require('child_process').exec;

const config = require('./config.json');
const url = `http://${config.host}:${config.port}`;

if (os.platform() === 'win32') {
  const actions = ['GET', 'POST', 'PUT', 'HEAD', 'DELETE'];
  for (const i in actions) {
    exec(`curl -H "User-Agent: Mozilla/5.0" -d 'hello' -X ${actions[i]} ${url}`, (error, stdout, stderr) => {
      if (error) {
        console.log(`exec error: ${error}`);
        return;
      }
      console.log(actions[i]+' '+stdout);
    })
  } // for
}
