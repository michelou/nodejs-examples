'use strict'

// console.log(
//   'Ce fichier contient des exemples mais n\'est pas destiné à être\n' +
//   'exécuté directement.'
// )
// process.exit(0)

// ===================================================================
// Import de levelup

const leveldown = require('leveldown')

// Le paquet level expose directement levelup.
const levelup = require('levelup')
const path = require('path')

const tmpdir = require('os').tmpdir()
const booksFile = path.join(tmpdir, '/books.db')
const jsonFile = path.join(tmpdir, '/json.db')
const mydbFile = path.join(tmpdir, '/mydb.db')
const mainFile = path.join(tmpdir, '/main.db')

// ===================================================================
// Ouverture

// Ouvre une base de données de façon asynchrone.
levelup(leveldown(booksFile), function (error, db) {
  if (error) {
    console.error('l\'ouverture de la base a échoué (books)')
    return
  }

  // Utilise l'objet db.
  // (voir https://github.com/Level/levelup#api)
  db.put('name', 'LevelUp', function (err) {
    if (err) return console.log('l\'ajout a échoué (books)')
  })
  db.get('name', function (err, value) {
    if (err) console.log('la lecture a échoué (books)')
    console.log('name=' + value)
  })
  db.close(function (err) {
    if (err) console.error('la fermeture a échoué (books)')
  })
})

// ===================================================================
// Ouverture d'une base d'objets (JSON)

levelup(leveldown(jsonFile), {
  valueEncoding: 'json'
}, function (error, db) {
  if (error) {
    console.error('l\'ouverture de la base a échoué (json)')
    return
  }

  // Utilise l'objet db.
  // ...
  db.put('name', 'json', function (err) {
    if (err) return console.log('l\'ajout a échoué (json)')
  })
  db.get('name', function (err, value) {
    if (err) {
      console.log('la lecture a échoué (json)')
      return
    }
    console.log('name=' + value)
  })
  db.close(function (err) {
    if (err) console.error('la fermeture a échoué (json)')
  })
})

// ===================================================================
// Manipulation

const db = levelup(leveldown(mydbFile))

// Insertion d'une valeur.
db.put('foo', 'bar', function (error) {
  if (error) {
    console.error('l\'insertion a échoué (mydb)')
  }
})

// Récupération d'une valeur.
db.get('foo', function (error, value) {
  if (error) {
    console.error('la récupération a échoué (mydb)')
    return
  }
  console.log('value='+value)
})

// Suppression d'une valeur.
db.del('foo', function (error) {
  if (error) {
    console.error('la suppression a échoué (mydb)')
  }
})

// ===================================================================
// Manipulation par lot

db.batch([
  { type: 'del', key: 'foo' },
  { type: 'put', key: 'bar', value: 'Hello' },
  { type: 'put', key: 'baz', value: 'World' }
], function (error) {
  if (error) {
    console.error('le lot de modification a échoué (mydb)')
  }
})

// ===================================================================
// Flux de lecture

// Affiche toutes les clefs situées entre d (inclus) et f (exclu) :
db.createReadStream({
  gte: 'd',
  lt: 'f'
}).on('data', function (data) {
  console.log(data)
})

// ===================================================================
// Fermeture

// Une fois que l'utilisation de la base de données est terminée, il
// est recommandé de la fermer correctement afin d'être sûr que toutes
// les modifications ont été enregistrées :
db.close(function (error) {
  if (error) {
    console.error('la fermeture de la base a échoué (mydb)')
  }
})

// ===================================================================
// Ouverture de la base par plusieurs processus

const levelParty = require('level-party')

levelParty(mainFile, function (error, db) {
  if (error) {
    console.error('l\'ouverture de la base a échoué (main)')
    return
  }

  // L'objet db s'utilise comme une instance de LevelUp.
  // ...
  db.put('name', 'levelParty', function (error) {
    if (error) {
      console.error('l\'insertion a échoué (main)')
    }
  })
  db.get('name', function (err, value) {
    if (err) {
      console.log('la lecture a échoué (main)')
      return
    }
    console.log('name=' + value)
  })
  db.close(function (err) {
    if (err) console.error('la fermeture a échoué (main)')
  })
})

// ===================================================================
// Ouverture de la base par plusieurs processus

const sublevel = require('level-sublevel')

levelup(mainFile, function (error, db) {
  if (error) {
    console.error('l\'ouverture de la base a échoué (sublevel)')
    return
  }
  // Étend la base de données avec sublevel.
  db = sublevel(db)

  // Création de deux sous bases qui peuvent être manipulées
  // indépendamment.
  const dbFoo = db.sublevel('foo')
  const dbBar = db.sublevel('bar')

  dbFoo.isOpen()
  dbBar.isOpen()
})
