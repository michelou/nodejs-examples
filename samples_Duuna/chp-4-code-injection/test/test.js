//var app = require('../calculator');

var Browser = require('zombie');
var http = require('http');
var should = require('should');

const config = require('../config.json');
const port = process.env.PORT || config.port;
const baseUrl = 'http://' + config.host + ':' + port;

var browser = new Browser({ site: baseUrl });
    
describe('/', function() {
  before(function() {
    //this.server = http.createServer(app).listen(port);
  });

  it('should return 2+2=4', function(done) {
    browser.visit('/', function() {
      browser.fill('input[name=formula]', '2+3');
      browser.document.forms[0].submit();
      console.log("0000000000000 ");
      browser.wait().then(function() {
        should.equal(browser.text('body'), 'The result is: 4');
        console.log("111111111111111 "+browser.text('body'));
        done();
      });   
      done();
    });
  });

});

