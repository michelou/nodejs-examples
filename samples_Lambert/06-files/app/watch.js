// L'exemple suivant est basé sur Chokidar
// (https://github.com/paulmillr/chokidar) qui est la bibliothèque la
// plus utilisée pour la surveillance de fichier.
//
// Il est intéressant de lancer les autres exemples de ce dossier
// pendant que celui-ci tourne afin de voir ce qu'il se passe:
//
// ```
// > node watch.js &
// > node directories.js
// > node files.js
// ```

'use strict';

var chokidar = require('chokidar');

// Création d'un surveillant (watcher).
var watcher = chokidar.watch(__dirname);

watcher.once('ready', function () {
  console.log('[WATCH] début de la surveillance');

  watcher.on('add', function (path) {
    console.log('[WATCH] ajout d\'un fichier :', path);
  });
  watcher.on('addDir', function (path) {
    console.log('[WATCH] ajout d\'un dossier :', path);
  });

  watcher.on('change', function (path) {
    console.log('[WATCH] modification d\'un fichier :', path);
  });
  watcher.on('changeDir', function (path) {
    console.log('[WATCH] modification d\'un dossier :', path);
  });

  watcher.on('unlink', function (path) {
    console.log('[WATCH] suppression d\'un fichier :', path);
  });
  watcher.on('unlinkDir', function (path) {
    console.log('[WATCH] suppression d\'un dossier :', path);
  });
});

watcher.on('error', function (error) {
 console.error('[WATCH] erreur :', error);
});
