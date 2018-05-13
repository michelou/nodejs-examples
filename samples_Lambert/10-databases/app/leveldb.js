'use strict';

console.error(
  'Ce fichier contient des exemples mais n\'est pas destiné à être\n' +
  'exécuté directement.'
);
return 1;

//====================================================================
// Import de levelup

// Le paquet level expose directement levelup.
var levelup = require('level');

//====================================================================
// Ouverture

// Ouvre une base de données de façon asynchrone.
levelup(__dirname + '/books.db', function (error, db) {
  if (error) {
    console.error('l\'ouverture de la base a échoué');
    return;
  }

  // Utilise l'objet db.
  // ...
});

//====================================================================
// Ouverture d'une base d'objets (JSON)

levelup(__dirname + '/book.db', {
  valueEncoding: 'json'
}, function (error, db) {
  if (error) {
    console.error('l\'ouverture de la base a échoué');
    return;
  }

  // Utilise l'objet db.
  // ...
});

//====================================================================
// Fermeture

// Une fois que l'utilisation de la base de données est terminée, il
// est recommandé de la fermer correctement afin d'être sûr que toutes
// les modifications ont été enregistrées :
db.close(function (error) {
  if (error) {
    console.error('la fermeture de la base a échoué');
  }
});

//====================================================================
// Manipulation

// Insertion d'une valeur.
db.put('foo', 'bar', function (error) {
  if (error) {
    console.error('l\'insertion a échoué');
  }
});

// Récupération d'une valeur.
db.get('foo', function (error, value) {
  if (error) {
    console.error('la récupération a échoué');
    return;
  }

  console.log(value);
});

// Suppression d'une valeur.
db.del('foo', function (error) {
  if (error) {
    console.error('la suppression a échoué');
  }
});

//====================================================================
// Manipulation par lot

db.batch([
  { type: 'del', key: 'foo' },
  { type: 'put', key: 'bar' , value: 'Hello'},
  { type: 'put', key: 'baz' , value: 'World'},
], function (error) {
  if (error) {
    console.error('le lot de modification a échoué');
  }
});

//====================================================================
// Flux de lecture

// Affiche toutes les clefs situées entre d (inclus) et f (exclu) :
db.createReadStream({
  gte: 'd',
  lt: 'f',
}).on('data', function (data) {
  console.log()
});

//====================================================================
// Ouverture de la base par plusieurs processus

var levelParty = require('level-party');

levelParty.open(__dirname + '/books.db', function (error, db) {
  if (error) {
    console.error('l\'ouverture de la base a échoué');
    return;
  }

  // L'objet db s'utilise comme une instance de LevelUp.
  // ...
});
var levelup = require('level');

//====================================================================
// Ouverture de la base par plusieurs processus

var sublevel = require('level-sublevel');


levelup(__dirname + '/main.db', function (error, db) {
  // Étend la base de données avec sublevel.
  db = sublevel(db);

  // Création de deux sous bases qui peuvent être manipulées
  // indépendamment.
  var dbFoo = db.sublevel('foo');
  var dbBar = db.sublevel('bar');
});
