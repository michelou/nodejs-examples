'use strict';

var pg = require('pg');

var conString = 'postgres://myuser:mypassword@myhost/mydatabase';

var client = new pg.Client(conString);
client.connect(function(err) {
  if(err) {
    return console.error('impossible de se connecter à PostgreSQL', err);
  }
  client.query('SELECT NOW() AS "maintenant"', function(err, result) {
    if(err) {
      return console.error('erreur à l\'exécution de la requête', err);
    }
    console.log(result.rows[0].maintenant);
    //output: Tue Jul 04 2012 15:10:14 GMT +200 (CEST)
    client.end();
  });
});
