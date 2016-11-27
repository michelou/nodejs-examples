var expect = require('Chai').expect;
var request = require('request');

const config = require('../config.json');
const baseUrl = 'http://' + config.host + ":" + config.port;

describe('hello-2', function() {

  describe('Success', function() {

  it('should return 200', function (done) {
    var options = {
      url: baseUrl,
      headers: { 'Content-Type': 'text/plain' }
    };
    request.get(options, function (err, res, body) {
      expect(res.statusCode).to.equal(200);
      expect(res.body).to.equal('Get action was requested');
    });
    request.put(options, function (err, res, body) {
      expect(res.statusCode).to.equal(200);
      expect(res.body).to.equal('Put action was requested');
    });
    request.head(options, function (err, res, body) {
      expect(res.statusCode).to.equal(200);
      expect(res.body).to.equal('');
    });
    request.del(options, function (err, res, body) {
      expect(res.statusCode).to.equal(200);
      expect(res.body).to.equal('Delete action was requested');
      done();
    });
  });

  });

  describe('hello-2 (fail)', function() {

    it('should return 404', function (done) {
      done();
    });
  
  });
  
});
