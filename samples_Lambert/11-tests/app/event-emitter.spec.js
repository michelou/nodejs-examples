'use strict'

// ====================================================================

const EventEmitter = require('events').EventEmitter
const expect = require('chai').expect
const sinon = require('sinon')

// ====================================================================

describe('EventEmitter#emit()', function () {
  beforeEach(function () {
    this.emitter = new EventEmitter()
    this.spy = sinon.spy()

    this.emitter.on('foo', this.spy)
  })

  it('should invoke the callback', function () {
    this.emitter.emit('foo')

    expect(this.spy.calledOnce).to.be.true // eslint-disable-line no-unused-expressions
  })

  it('should pass arguments to the callback', function () {
    this.emitter.emit('foo', 'bar', 'baz')

    expect(this.spy.calledWithExactly('bar', 'baz')).to.be.true // eslint-disable-line no-unused-expressions
  })

  it('should set the context to the emitter', function () {
    this.emitter.emit('foo')

    expect(this.spy.calledOn(this.emitter)).to.be.true // eslint-disable-line no-unused-expressions
  })
})

describe('EventEmitter#emit()', function () {
  beforeEach(function () {
    this.emitter = new EventEmitter()
    this.stub = sinon.stub()

    this.emitter.on('foo', this.stub)
  })

  it('forward the exception if a listener throws', function () {
    this.stub.throws()

    expect(function () { // eslint-disable-line no-unused-expressions
      this.emitter.emit('foo')
    }).to.throw
  })
})
