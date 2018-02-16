'use strict';

var redis = require('redis');
var client = redis.createClient();

client.on('error', function (err) {
  console.log('Error ' + err);
});

client.set('Ma clef', 'Ma valeur', redis.print);
client.get('Ma clef', function (err, reply) {
  console.log(reply.toString());
});
