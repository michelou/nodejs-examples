const exec = require('child_process').exec;
const platform = require('os').platform();

const config = require('./config.json');
const url = `http://${config.host}:${config.port}`;

const cmd;
if (platform === 'win32') {
  cmd = `start "" ${url}`;
}
else if (platform === 'darwin') {
  cmd = `open ${url}`;
}
else {
  cmd = `x-www-browser ${url}`;
}

exec(cmd, (error, stdout, stderr) => {
  if (error) {
    console.log(`exec error: ${error}`);
    return;
  }
 console.log(stdout);
})
