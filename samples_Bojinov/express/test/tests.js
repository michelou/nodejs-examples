var expect = require('Chai').expect;
var request = require('request');

describe('express (success)', function() {

  it('should return 200', function (done) {
    var options = {
      url: 'http://localhost:8180',
      headers: { 'Content-Type': 'text/plain' }
    };
    request.get(options, function (err, res, body) {
      expect(res.statusCode).to.equal(200);
      // e.g. '2016-04-16T00:59:37+02:00'
      expect(res.body).to.match(/[0-9]{4}-[0-9]+-[0-9]+T[0-9]{2}:[0-9]{2}:[0-9]{2}.*/);
      done();
    });
  });

});
