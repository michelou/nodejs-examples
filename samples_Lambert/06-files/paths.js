'use strict';

var pathLib = require('path');

var path = '/usr/local/include/node/node.h';

//      Dossier (dir)     Extension (ext)
// ┌──────────┴──────────┐     ┌┴┐
// /usr/local/include/node/node.h
//                         └─┬──┘
//                          Base

// Récupérer le dossier.
console.log(pathLib.dirname(path));
// > /usr/local/include/node

// Récupérer la base.
console.log(pathLib.basename(path));
// > node.h

// Récupérer la base sans l'extension.
console.log(pathLib.basename(path, '.h'));
// > node

// Récupérer l'extension
console.log(pathLib.extname(path));
// > .h

// Vérifier si un chemin est absolu.
var isAbsolute = require('absolute-path');
console.log(isAbsolute(path));
// > true

// Joindre des chemins.
console.log(pathLib.join(__dirname, 'assets', 'title.png'));
// > .../eni-nodejs/06-files/assets/title.png

// Normaliser (nettoyer) un chemin.
console.log(pathLib.normalize('foo/../../bar/./baz//'));
// > ../bar/baz/

// Construire un chemin absolu (à partir des chemins spécifiés et du
// dossier courant).
console.log(pathLib.resolve('foo/bar', '/tmp/file/', '..', 'a/../subfile'));
// > /tmp/subfile

// Construire un chemin relatif (inverse de `resolve()`).
console.log(pathLib.relative('/home/adele/Bureau', '/home/frank/Documents'));
// > ../../frank/Documents
