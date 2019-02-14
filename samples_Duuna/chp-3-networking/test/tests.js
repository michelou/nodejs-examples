const expect = require('Chai').expect
const request = require('request')
const server = require('../app/cluster-main.js').server

const config = require('../config.json')
const baseUrl = 'http://' + config.host + ':' + config.port

describe('networking', function () {
  describe('Success', function () {
    it('should return 200', function (done) {
      var options = {
        url: baseUrl,
        headers: { 'Content-Type': 'text/plain' }
      }
      request.get(options, function (err, res, body) {
        if (err) throw err
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.equal('hello world\n')
        done()
      })
    })
  })

  describe('Failure', function () {
  })
  
  after(function () {
    server.close(function () {
      console.log('Server closed')
    })        
  })
})
