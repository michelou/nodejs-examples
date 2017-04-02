const os = require('os');
const exec = require('child_process').exec;

const config = require('../config.json');
const url = `http://${config.host}:${config.port}`;

if (os.platform() === 'win32') {
  const headers = `-H "User-Agent: Mozilla/5.0" -H "Accept: text/html"`;
  const languages = ['en', 'fr', 'de'];
  for (const i in languages) {
    const cmd = `curl ${headers} -H "Accept-Language: ${languages[i]}" ${url}`;
    exec(cmd, (error, stdout, stderr) => {
      if (error) {
        console.log(`exec error: ${error}`);
        return;
      }
      console.log(languages[i]+'\n'+stdout);
    })
  } // for
}
