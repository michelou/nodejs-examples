var mongoose = require('mongoose')

module.exports = mongoose.model('User', {
  firstName: String,
  lastName: String,
  username: String,
  password: String,
  email: String,
  gender: String,
  address: String
})
