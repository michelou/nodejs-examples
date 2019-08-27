'use strict';

var mongoose = require('mongoose');
 
mongoose.connect('mongodb://localhost/test', { useNewUrlParser: true } );

var Cat = mongoose.model('Cat', { name: String });

var kitty = new Cat({ name: 'Zildjian' });
kitty.save(function (err) {
  if (err) {
    // ...
  }

  console.log('miaou');
  mongoose.connection.close(function () { 
    console.log('Mongoose default connection disconnected'); 
    process.exit(0); 
  });
});
