'use strict';

//====================================================================
// Promessification d'une seule fonction.

var promisify = require('bluebird').promisify;
var readFile = require('fs').readFile;

// `promisify()` créé à partir d'une fonction asynchrone respectant
// `les conventions Node (callback en dernier paramètre), une fonction
// `quasi-identique mais qui renvoie des promesses.
var readFilePromise = promisify(readFile);

// La fonction peut maintenant être utilisée directement dans une
// chaîne de promesses.
readFilePromise(__filename).then(function (content) {
  console.log(String(content));
}).catch(function (error) {
  console.error('erreur lors de la lecture', error);
});

//====================================================================
// Promessification de toutes les méthodes d'un objet.

var promisifyAll = require('bluebird').promisifyAll;
var fs = require('fs');

// `promisifyAll()` parcourt toutes les méthodes d'un objet et en créé
// `des versions promessifiées ayant le même nom mais suffixées de
// ``Async`.
promisifyAll(fs);

// Les méthodes peuvent maintenant être utilisées directement dans une
// chaîne de promesses.
fs.readFileAsync(__filename).then(function (content) {
  console.log(String(content));
}).catch(function (error) {
  console.error('erreur lors de la lecture', error);
});
