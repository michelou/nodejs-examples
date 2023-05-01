'use strict'

const mongoose = require('mongoose')

mongoose.connect('mongodb://localhost/test', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).catch(err => {
  console.error('Connection failed', err)
})

const Cat = mongoose.model('Cat', { name: String })

const kitty = new Cat({ name: 'Zildjian' })
kitty.save()
.catch(err => {
  console.log('miaou')
  mongoose.connection.close()
  .then(function () {
    console.log('Mongoose default connection disconnected')
    process.exit(0)
  })
})
