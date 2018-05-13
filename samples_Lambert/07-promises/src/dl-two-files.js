'use strict';

// Bluebird est une bibliothèque de promesses très performante
// proposant des fonctionnalités haut niveau.
var Bluebird = require('bluebird');

// Les deux fonctions suivantes `got()` et `writeFile()` sont
// promessifiées afin de renvoyer des promesses au lieu de prendre une
// callback en dernier paramètre.
var got = Bluebird.promisify(require('got'));
var writeFile = Bluebird.promisify(require('fs').writeFile);

var files = [
  {
    name: 'example-net.html',
    url: 'http://example.net/',
  },
  {
    name: 'example-org.html',
    url: 'http://example.org/',
  },
];

Bluebird

  // Télécharge en parallèle tous les fichiers de `files`.
  .map(files, function (file) {
    return got(file.url);
  })

  // Puis les enregistre sur le disque (toujours en parallèle).
  .map(function (result, i) {
    // got() retourne deux résultats que Bluebird.promisify()
    // transforme en tableau.
    var content = result[0];

    return writeFile(files[i].name, content);
  })

  .then(function () {
    console.log('Tout s\'est bien passé');
  })
  .catch(function (error) {
    console.error(error);
  })
;
