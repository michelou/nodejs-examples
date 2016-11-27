'use strict';

var fs = require('fs');

exports.fill = function(db) {
  try {
    var data = fs.readFileSync('./data/contacts.json', 'utf8');
    var result = JSON.parse(data).result;
    for (var i in result) {
      var contact = result[i];
      console.log('Adding contact ' + contact.primarycontactnumber);
      db.put(contact.primarycontactnumber, contact);
    }
  }
  catch (e) {
    console.log('' + e);
    process.exit(1);
  }
};
