const expect = require('Chai').expect;
const request = require('request');

const config = require('../config.json');
const baseUrl = 'http://' + config.host + ":" + config.port;

describe('hello-1', function() {

  describe('Success', function() {

    it('/hello', function (done) {
      var options = {
        url: baseUrl + '/hello',
        headers: { 'Content-Type': 'text/plain' }
      };
      request.get(options, function (err, res, body) {
        expect(res.statusCode).to.equal(200);
        expect(res.body).to.equal('Hello route');
        done();
      });
    });

    it('/hallo/:name', function (done) {
      var options = {
        url: baseUrl + '/hallo/John',
        headers: { 'Content-Type': 'text/plain' }
      };
      request.get(options, function (err, res, body) {
        expect(res.statusCode).to.equal(200);
        expect(res.body).to.equal('Hallo John');
        done();
      });
    });

    it('/hallo/:name (UTF-8)', function (done) {
      var options = {
        url: baseUrl + '/hallo/Stéphane',
        headers: { 'Content-Type': 'text/plain' }
      };
      request.get(options, function (err, res, body) {
        expect(res.statusCode).to.equal(200);
        expect(res.body).to.equal('Hallo Stéphane');
        done();
      });
    });

    it('/salut', function (done) {
      var options = {
        url: baseUrl + '/salut',
        headers: { 'Content-Type': 'text/plain' }
      };
      request.get(options, function (err, res, body) {
        expect(res.statusCode).to.equal(200);
        expect(res.body).to.equal('Salut à tous');
        done();
      });
    });

    it('/salut?name=<name>', function (done) {
      var options = {
        url: baseUrl + '/salut?name=John',
        headers: { 'Content-Type': 'text/plain' }
      };
      request.get(options, function (err, res, body) {
        expect(res.statusCode).to.equal(200);
        expect(res.body).to.equal('Salut John');
        done();
      });
    });

  });

  describe('Failure', function() {

    it('should return 404', function (done) {
      var options = {
        url: baseUrl,
        headers: { 'Content-Type': 'text/plain' }
      };
      request.get(options, function (err, res, body) {
        expect(res.statusCode).to.equal(404);
        console.log(res)
        expect(res.body).to.match(/Cannot GET/) //equal('Cannot GET /\n');
        done();
      });
    });

  });

});
