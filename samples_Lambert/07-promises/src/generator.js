// Les générateurs sont uniquement disponibles à partie de ECMAScript
// 6, il faudra donc utiliser une version récente de Node ou alors
// passer par Babel (http://babeljs.io/) :
//
// ```
// > ./node_modules/.bin/babel-node generator.js
// ```

//====================================================================
// Généralités.

// Un générateur est une fonction qui peut se suspendre en retournant
// des valeurs intermédiaires via l'instruction `yield`.

// Le générateur suivant retourne les entiers compris entre deux
// bornes `a` et `b`.
function *range(a, b) {
  a = Math.ceil(a);

  while (a < b) {
    yield a;
    a += 1;
  }
}

// À l'exécution, un générateur renvoie un itérateur qui est un objet
// possédant la méthode `next()` qui relance l'exécution du générateur
// jusqu'au prochain `yield` et retourne le résultat intérmédiaire.
let iterator = range(0, 2);

console.log(iterator.next());
// > { done: false, value: 0 }

console.log(iterator.next());
// > { done: false, value: 1 }

console.log(iterator.next());
// > { done: true, value: undefined }

//====================================================================
// Utilisation avec les promesses.

import {coroutine, promisify} from 'bluebird';
import {readFile} from 'fs';

let readFilePromise = promisify(readFile);

// `coroutine()` crée à partir d'un générateur, une fonction renvoyant
// `des promesses.
coroutine(function *()  {
  try {
    // Dans une coroutine, il suffit de `yield` une promesse (comme
    // celle renvoyée par `readFilePromise()`) pour suspendre
    // l'exécution et attendre automatiquement que la promesse soit
    // résolue ou rejetée.
    let content = yield readFilePromise(__filename);

    console.log(String(content));
  } catch (error) {
    console.error(error);
  }
})();
