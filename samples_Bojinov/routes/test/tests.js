const expect = require('Chai').expect;
const superagent = require('superagent')

const config = require('../config.json');
const baseUrl = 'http://' + config.host + ":" + config.port;

describe('hello-1', function() {

  describe('Success', function() {

    it('/hello', function (done) {
      superagent
        .get(baseUrl + '/hello')
        .set('Content-Type', 'text/plain')
        .end(function (err, res) {
          expect(err).to.be.null
          expect(res.status).to.equal(200)
          expect(res.text).to.equal('Hello route')
        })
      done()
    })

    it('/hallo/:name', function (done) {
      superagent
        .get(baseUrl + '/hallo/John')
        .set('Content-Type', 'text/plain')
        .end(function (err, res) {
          expect(err).to.be.null
          expect(res.status).to.equal(200)
          expect(res.text).to.equal('Hallo John')
        })
      done()
    })

    it('/hallo/:name (UTF-8)', function (done) {
      superagent
        .get(baseUrl + '/hallo/Stéphane')
        .set('Content-Type', 'text/plain')
        .end(function (err, res) {
          expect(err).to.be.null
          expect(res.status).to.equal(200)
          expect(res.text).to.equal('Hallo Stéphane')
        })
      done()
    })

    it('/salut', function (done) {
      superagent
        .get(baseUrl + '/salut')
        .set('Content-Type', 'text/plain')
        .end(function (err, res) {
          expect(err).to.be.null
          expect(res.status).to.equal(200)
          expect(res.text).to.equal('Salut à tous')
        })
      done()
    })

    it('/salut?name=<name>', function (done) {
      superagent
        .get(baseUrl + '/salut?name=John')
        .set('Content-Type', 'text/plain')
        .end(function (err, res) {
          expect(err).to.be.null
          expect(res.status).to.equal(200)
          expect(res.text).to.equal('Salut John')
        })
      done()
    })

  })

  describe('Failure', function() {

    it('should return 404', function (done) {
      superagent
        .get(baseUrl)
        .set('Content-Type', 'text/plain')
        .end(function (err, res) {
          expect(err).to.not.be.null
          expect(err.status).to.equal(404)
          console.log(err.message)
          expect(err.message).to.match(/Not Found/)
        })
      done()
    })

  })

});
