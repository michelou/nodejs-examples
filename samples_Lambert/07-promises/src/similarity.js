'use strict';

var Bluebird = require('bluebird');
var fs = require('fs');

var readFile, writeFile;

//====================================================================
// Code synchrone.

readFile = fs.readFileSync;
writeFile = fs.writeFileSync;

try {
  var config = JSON.parse(readFile('config.json'));

  config.foo = 'bar';

  writeFile('config.json', JSON.stringify(config));
} catch (error) {
  console.error('Erreur :', error);
}

//====================================================================
// Code asynchrone avec promesses.

// On peut constater que ce code est extrêmement similaire au code
// synchrone.

readFile = Bluebird.promisify(fs.readFile);
writeFile = Bluebird.promisify(fs.writeFile);

readFile('config.json').then(JSON.parse).then(function (config) {
  config.foo = 'bar';

  return writeFile('config.json', JSON.stringify(config));
}).catch(function (error) {
  console.error('Erreur :', error);
});

//====================================================================
// Code asynchrone avec callbacks.

// On peut constater que ce code est très différent.

fs.readFile('config.json', function (error, content) {
  if (error) {
    console.error('Erreur :', error);
    return;
  }

  try {
    var config = JSON.parse(content);

    config.foo = 'bar';

    fs.writeFile('config.json', function (error) {
      if (error) {
        console.error('Erreur :', error);
        return;
      }
    });
  } catch (error) {
    console.error('Erreur :', error);
  }
});
