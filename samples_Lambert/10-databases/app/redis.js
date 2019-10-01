'use strict'

var redis = require('redis')
var client = redis.createClient()

client.on('error', function (err) {
  console.log('Error ' + err)
})

client.set('Ma clef', 'Ma valeur', redis.print)
client.get('Ma clef', function (err, reply) {
  if (err) {
    return console.error('erreur à l\'exécution de la requête', err)
  }
  console.log(reply.toString())
})
