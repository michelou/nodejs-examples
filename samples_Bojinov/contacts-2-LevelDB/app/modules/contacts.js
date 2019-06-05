'use strict'

const fs = require('fs')
const path = require('path')

exports.fill = function (db) {
  try {
    var data = fs.readFileSync(path.join(__dirname, '/../data/contacts.json'), 'utf8')
    var result = JSON.parse(data).result
    for (var i in result) {
      var contact = result[i]
      console.log('[modules/contacts.js] Adding contact ' + contact.primarycontactnumber)
      db.put(contact.primarycontactnumber, contact)
    }
  }
  catch (err) {
    console.log('[modules/contacts.js] ' + err)
    process.exit(1)
  }
}
