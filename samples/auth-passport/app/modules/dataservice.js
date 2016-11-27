var bCrypt = require('bcrypt-nodejs');
var mongoose = require('mongoose');

var dbConfig = require('./db.js');
var User = require('../models/user.js');

exports.initialize = function() {

    var john = new User({
        firstName: "John",
        lastName: "Smith",
        username: "john",
        password: bCrypt.hashSync("s3cr3t"),
        email: "john.smith@gmail.com",
        gender: "Male",
        address: "NY city"
    });

    mongoose.connect(dbConfig.url);
            
    User.find({username: john.username}, function(error, result) {
        if (error) {
            //console.log(error);
            john.save(function(error) {
                if (error) {
                    console.log('Error while saving user '+john.username);
                    console.log(error);
                }
                else {
                    john.save();
                    console.log('User '+john.username+' has been successfully stored');
                }
            });
        }
        else {
            console.log(result);
        }
    });

};
