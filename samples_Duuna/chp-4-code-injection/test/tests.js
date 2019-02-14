// see http://krasimirtsonev.com/blog/article/Testing-with-headless-browser-Zombiejs-Jasmine-TDD-NodeJS-example

const Browser = require('zombie')
const should = require('should')
const server = require('../app/calculator.js').server

const config = require('../config.json')
Browser.localhost(config.host, config.port)

describe('/', function () {
  const browser = new Browser()
  before(function (done) {
    browser.visit('/', function () {
      browser.assert.text('title', 'Calculator')
      done()
    })
  })

  it('should return 2+2=4', function (done) {
    browser.fill('input[name="formula"]', '2+2')
    browser.document.forms[0].submit()
    browser.wait().then(function () {
      should.equal(browser.text('body'), 'The result is: 4')
      done()
    })
  })

  after(function () {
    server.close(function () {
      console.log('Server closed')
    })
  })
})
