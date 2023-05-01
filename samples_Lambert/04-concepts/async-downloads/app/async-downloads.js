// Cet exemple utilise la bibliothèque async
// (https://github.com/caolan/async#asyncjs) qui offre un grand nombre
// de fonctionnalités de haut niveau pour construire des processus
// asynchrones.
//
// Ici, 2 fichiers (`example-net.html` et `example-org.html`) vont
// être téléchargés en parallèle et enregistrés sur le disque.

// Cette exemple requiert l'installation de dépendances :
//
// ```
// > npm install
// ```

'use strict'

const async = require('async')

// Utiliser le paquet `got` pour le téléchargement.
const got = require('got')  // starting with 12.x an ESM-only package

// Utiliser `fs.writeFile()` pour enregistrer les fichiers.
const writeFile = require('fs').writeFile

const files = [
  {
    name: 'example-net.html',
    url: 'http://example.net/'
  },
  {
    name: 'example-org.html',
    url: 'http://example.org/'
  }
]

async.waterfall([

  // Télécharge en parallèle tous les fichiers de `files`.
  function (callback) {
    async.parallel(files.map(function (file) {
      return function (callback) {
        // console.log('get URL ' + file.url)
        got(file.url)
        callback()
      }
    }), callback)
  },

  // Puis les enregistre sur le disque (toujours en parallèle).
  function (results, callback) {
    async.parallel(results.map(function (content, i) {
      return function (callback) {
        // console.log('write file ' + files[i].name)
        writeFile(files[i].name, content, callback)
      }
    }), callback)
  }

], function (error) {
  if (error) {
    console.error(error)
  }
  else {
    console.log('Tout s\'est bien passé')
  }
})
