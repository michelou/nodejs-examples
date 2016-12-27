var mongoose = require('mongoose');

mongoose.Promise = global.Promise; // native promises
//mongoose.Promise = require('bluebird');

var basename = require('path').basename(__filename);

var logInfo = function(msg) {
  var timestamp = require('moment')().format('YYYY-MM-DD HH:mm:ss');
  console.log('['+timestamp+' INFO] ('+basename+') ' + msg);
};

var contactSchema = new mongoose.Schema({
  primarycontactnumber: {type: String, index: {unique: true}},
  firstname: String,
  lastname: String,
  title: String,
  company: String,
  jobtitle: String,
  othercontactnumbers: [String],
  primaryemailaddress: String,
  emailaddresses: [String],
  groups: [String]
});

var Contact = mongoose.model('Contact', contactSchema);

var john_douglas = new Contact({
  firstname: "John",
  lastname: "Douglas",
  title: "Mr.",
  company: "Dev Inc.",
  jobtitle: "Developer",
  primarycontactnumber: "+359777223345",
  othercontactnumbers: [],
  primaryemailaddress: "john.douglas@xyz.com",
  emailaddresses: ["j.douglas@xyz.com"],
  groups: ["Dev"]
});

var find_tests = function() {
  Contact.find({groups: 'Dev', title: 'Mr.'}, function(error, result) {
    if (error) {
      logInfo('Error while executing find operation');
      console.error(error);
    }
    else {
      logInfo('result='+result); //console.dir(result);
    }
  });

  Contact.findOne({primarycontactnumber: '+359777223345' }, function(error, data) {
    if (error) {
      console.log(error.message);
      //return;
    }
	  else {
      if (!data) {
        console.log('not found');
        //return;
      }
      else {
        data.remove(function(error) {
          if (!error) { data.remove(); }
          else { console.log(error); }
        });
      }
    }
  });
}

const db = require('./db');
var con = mongoose.connect(db.uri, function() {
  logInfo('Connecting to MongoDB '+db.uri);
});

if (db.is_local) {
  john_douglas.save(function(error) {
    if (error) {
      logInfo('Error while saving contact for Mr. John Douglas');
      console.log(error);
    }
    else {
      john_douglas.save();
      logInfo('Contact for Mr. John Douglas has been successfully stored');
    }
    find_tests();
    con.disconnect();
  });
}
else {
  find_tests();
  con.disconnect();
}
