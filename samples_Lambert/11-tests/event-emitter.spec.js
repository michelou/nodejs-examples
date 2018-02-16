'use strict';

//====================================================================

var EventEmitter = require('events').EventEmitter;
var expect = require('chai').expect;
var sinon = require('sinon');

//====================================================================

describe('EventEmitter#emit()', function () {
  beforeEach(function () {
    this.emitter = new EventEmitter();
    this.spy = sinon.spy();

    this.emitter.on('foo', this.spy);
  });

  it('should invoke the callback', function () {
    this.emitter.emit('foo');

    expect(this.spy.calledOnce).to.be.true;
  });

  it('should pass arguments to the callback', function () {
    this.emitter.emit('foo', 'bar', 'baz');

    expect(this.spy.calledWithExactly('bar', 'baz')).to.be.true;
  });

  it('should set the context to the emitter', function () {
    this.emitter.emit('foo');

    expect(this.spy.calledOn(this.emitter)).to.be.true;
  });
});

describe('EventEmitter#emit()', function () {
  beforeEach(function () {
    this.emitter = new EventEmitter();
    this.stub = sinon.stub();

    this.emitter.on('foo', this.stub);
  });

  it('forward the exception if a listener throws', function () {
    this.stub.throws();

    expect(function () {
      this.emitter.emit('foo');
    }).to.throw;
  });
});
