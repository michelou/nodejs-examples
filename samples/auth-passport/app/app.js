var bodyParser = require('body-parser');
var flash = require('connect-flash');
var express = require('express');
var session = require('express-session');
var http = require('http');
var passport = require('passport');
var path = require('path');

var sessionConfig = require('./modules/session.js');

require('./modules/dataservice').initialize();

var app = express();
var port = process.env.PORT || 8180;

// all environments
app.set('port', port);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(bodyParser.urlencoded({ extended: false }));
app.use(session(sessionConfig));
app.use(express.static(path.join(__dirname, 'public')));
app.use(passport.initialize());
app.use(passport.session());
// Using the flash middleware provided by connect-flash to store messages in session
// and displaying in templates
app.use(flash());

var routes = require('./routes/index')(passport);
app.use('/', routes);

/// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}


http.createServer(app).listen(port, function() {
    console.log("Module search path: "+(process.env.NODE_PATH || '(none)'));
    console.log('Express server listening on port ' + port);
});
