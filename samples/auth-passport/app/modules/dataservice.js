var bCrypt = require('bcrypt-nodejs')
var mongoose = require('mongoose')

var dbConfig = require('./db.js')
var User = require('../models/user.js')

exports.initialize = function () {
  var john = new User({
    firstName: 'John',
    lastName: 'Smith',
    username: 'john',
    password: bCrypt.hashSync('s3cr3t'),
    email: 'john.smith@gmail.com',
    gender: 'Male',
    address: 'NY city'
  })

  mongoose.connect(dbConfig.url, dbConfig.options, function (err, res) {
    if (err) throw err
    console.log('MongoDB Connected')
  })
  /*
  // alternative:
  mongoose.connect(dbConfig.url, { useNewUrlParser: true })
    .then(() => console.log('MongoDB Connected'))
    .catch((err) => console.log(err))
  */
  User.find({ username: john.username }, function (err, res) {
    if (err) {
      // console.log(err);
      john.save(function (err) {
        if (err) {
          console.log('Error while saving user ' + john.username)
          console.log(err)
        }
        else {
          john.save()
          console.log('User ' + john.username + ' has been successfully stored')
        }
      })
    }
    else {
      console.log(res)
    }
  })
}
