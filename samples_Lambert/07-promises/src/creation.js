'use strict';

var Bluebird = require('bluebird');
var readFile = require('fs').readFile;

//====================================================================

// Une promesse peut être créée via le constructeur (ici on utilise
// `Bluebird` mais c'est exactement pareil avec l'implémentation
// standard `Promise`).
//
// Le constructeur prend comme seul argument une fonction qui reçoit
// `resolve()` et `reject()` qui peuvent servir respectivement à
// résoudre la promesse avec succès ou avec erreur.
var promise = new Bluebird(function (resolve, reject) {
  readFile(__filename, function (error, content) {
    if (error) {
      // Si `readFile()` a échoué, il suffit d'appeler `reject()` en
      // lui passant l'erreur.
      reject(error);
    } else {
      // Si, au contraire, l'opération a réussi alors on appelle
      // `resolve()` avec le résultat.
      resolve(content);
    }
  });
});

//====================================================================

// On peut maintenant utiliser la promesse pour accéder au résultat.
promise.then(function (content) {
  console.log(String(content));
}).catch(function (error) {
  console.error('erreur lors de la lecture', error);
});
