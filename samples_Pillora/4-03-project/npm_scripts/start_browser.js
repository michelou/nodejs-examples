const exec = require('child_process').exec;
const platform = require('os').platform();

const url = process.argv.length > 2 ? process.argv[2] : 'build/app.html';

const cmd = (platform === 'win32')
  ? `start "" ${url}`
  : ((platform === 'darwin')
    ? `open ${url}`
    :  `x-www-browser ${url}`
  );

exec(cmd, (error, stdout, stderr) => {
  if (error) {
    console.log(`exec error: ${error}`);
    return;
  }
 console.log(stdout);
})
