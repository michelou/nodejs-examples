'use strict';

var fs = require('fs');

//====================================================================
// Lecture d'un répertoire.

fs.readdir(__dirname, function (error, files) {
  if (error) {
    console.error('échec de lecture du répertoire', error);
    return;
  }

  console.log('fichiers trouvés :', files);
});

//====================================================================
// Création et suppression d'un répertoire vide.

var tmpDir = __dirname + '/tmp-dir';
fs.mkdir(tmpDir, function (error) {
  if (error) {
    console.error('échec de la création du répertoire', error);
    return;
  }

  console.log('répertoire créé');
  fs.rmdir(tmpDir, function (error) {
    if (error) {
      console.error('échec de suppression du répertoire', error);
      return;
    }

    console.log('répertoire supprimé');
  });
});

//====================================================================
// Création et suppression d'une arborescence.

// Crée un dossier et tous ses parents.
//
// Le nom vient de la commande Unix `mkdir -p`.
var mkdirp = require('mkdirp');

// Supprime un dossier et tous ses enfants.
//
// Le nom vient de la commande Unix `rm -rf`.
var rimraf = require('rimraf');

var tmpTree = __dirname + '/tmp-tree';
mkdirp(tmpTree + '/foo/bar/baz', function (error) {
  if (error) {
    console.error('échec de la création de l\'arborescence', error);
    return;
  }

  console.log('arborescence créée');
  rimraf(tmpTree, function (error) {
    if (error) {
      console.error('échec de suppression de l\'arborescence', error);
      return;
    }

    console.log('arborescence supprimée');
  });
});
