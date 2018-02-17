'use strict';

var fs = require('fs');

// Ce programme créé pour certains exemples des fichiers temporaires
// qui n'ont pas vocation à rester une fois l'exécution terminée.
//
// La fonction `cleanOnExit()` permet justement d'enregistrer ces
// fichiers afin de les supprimer automatiquement à la fin de
// l'exécution.
var cleanOnExit = (function () {
  var rimraf = require('rimraf').sync;
  var entries = {};

  process.on('exit', function () {
    var entry;
    for (entry in entries) {
      try {
        rimraf(entry);
      } catch (e) {}
    }
  });

  return function cleanOnExit(entry) {
    entries[entry] = true;
  };
})();

// Cette fonction retourne un chemin temporaire unique et l'enregistre
// pour nettoyage avec la fonction `cleanOnExit()`.
var i = 0;
function getTmpPath() {
  var path = __dirname + '/.tmp-' + (i++);

  cleanOnExit(path);

  return path;
}

//====================================================================
// Récupération des méta-données.

fs.stat(__filename, function (error, stats) {
  if (error) {
    console.error('stat: échec de récupération des métadonnées', error);
    return;
  }

  var type =
    stats.isFile() ? 'fichier' :
    stats.isDirectory() ? 'dossier' :
    'inconnu'
  ;

  console.log('stat: Ce fichier est de type %s.', type);
  console.log('stat: Il a une taille de %s octets.', stats.size);
});

//====================================================================
// Changement du propriétaire.

fs.chown(__filename, 0, 0, function (error) {
  if (error) {
    console.error('chown: échec du changement de propriétaire', error);
  } else {
    console.log('chown: propriétaire changé');
  }
});

//====================================================================
// Changement des permissions.

fs.chmod(__filename, '644', function (error) {
  if (error) {
    console.error('chmod: échec du changement de mode', error);
  } else {
    console.log('chmod: mode changé');
  }
});

//====================================================================
// Changement des dates d'accès et de modification.

var atime = new Date('2012-09-17');
var mtime = new Date('2012-07-04');

fs.utimes(__filename, atime, mtime, function (error) {
  if (error) {
    console.error('utimes: échec de modification des dates', error);
  } else {
    console.log('utimes: dates modifiées');
  }
});

//====================================================================
// Lecture d'un fichier.

fs.readFile(__filename, function (error, content) {
  // Convertit le tampon de données en chaîne.
  content = String(content);

  if (error) {
    console.error('readFile: échec de lecture', error);
  } else {
    content = content.slice(0, 200).replace(/^/mg, '  | ') + '...';

    console.log('readFile:');
    console.log(content);
  }
});

//====================================================================
// Écriture d'un fichier.

fs.writeFile(getTmpPath(), 'mon contenu', function (error) {
  if (error) {
    console.error('writeFile: échec de l\'écriture', error);
  } else {
    console.log('writeFile: fichier écrit');
  }
});

//====================================================================
// Lecture et écriture via les flux.

// Pour plus d'information sur les flux, voir le chapitre 5.

// `createReadStream()` créé un flux de lecture qui va émettre le
// `contenu du fichier demandé, ici le fichier courant (`__filename`).
//
// Note : le fichier n'est pas réellement lu tant que le flux n'est
// pas consommé par un flux d'écriture ce qui limite l'engorgement
// mémoire (principe de pression inverse).
fs.createReadStream(__filename)

  // La méthode `pipe()` connecte le flux de lecture à un flux
  // d'écriture.
  .pipe(

    // `createWriteStream()` créé un flux d'écriture qui va
    // `enregistrer toutes les données qui lui sont fournies dans le
    // `fichier demandé, ici un fichier temporaire.
    fs.createWriteStream(getTmpPath())
  )
;

//====================================================================
// Troncature d'un fichier.

// `truncate()` augmente ou diminue la taille d'un fichier pour qu'il
// `corresponde à la taille demandée.
//
// Si la taille demandée est inférieure à la taille actuelle alors le
// contenu du fichier est tronqué à la taille demandée.
//
// Si la taille demandée est supérieure à la taille actuelle alors le
// contenu est étendu avec des octets nuls (\0).
//
// Note : le fichier doit exister.
fs.truncate(getTmpPath(), 1e3, function (error) {
  if (error) {
    console.error('truncate: échec de la troncature', error);
  } else {
    console.log('truncate: fichier tronqué');
  }
});

//====================================================================
// Renommage d'un fichier.

fs.rename('foo.txt', 'bar.txt', function (error) {
  if (error) {
    console.error('échec du renommage du fichier', error);
  } else {
    console.log('fichier renommé');
  }
});

//====================================================================
// Suppression d'un fichier.

fs.unlink(getTmpPath(), function (error) {
  if (error) {
    console.error('échec de la suppression du fichier', error);
  } else {
    console.log('fichier supprimé');
  }
});
