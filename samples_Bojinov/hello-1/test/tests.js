const expect = require('Chai').expect
const request = require('request')

const config = require('../config.json')
const baseUrl = 'http://' + config.host + ':' + config.port

describe('hello-1', function () {
  describe('Success', function () {
    it('should return 200', function (done) {
      var options = {
        url: baseUrl,
        headers: { 'Content-Type': 'text/plain' }
      }
      request.get(options, function (err, res, body) {
        if (err) throw err
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.equal('Hello World.- Are you restless to go restful?')
        done()
      })
    })

    it('should accept any path', function (done) {
      var options = {
        url: baseUrl + '/dummy',
        headers: { 'Content-Type': 'text/plain' }
      }
      request.get(options, function (err, res, body) {
        if (err) throw err
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.equal('Hello World.- Are you restless to go restful?')
        done()
      })
    })

    it('should accept PUT method', function (done) {
      var options = {
        url: baseUrl,
        headers: { 'Content-Type': 'text/plain' }
      }
      request.put(options, function (err, res, body) {
        if (err) throw err
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.equal('Hello World.- Are you restless to go restful?')
        done()
      })
    })
  })

  describe('Failure', function () {
  })
})
