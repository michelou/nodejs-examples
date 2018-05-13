'use strict';

var Bluebird = require('bluebird');

function foo() {
  console.log('foo 1');
  throw new Error('Error foo');
  console.log('foo 2');
}

function bar() {
  console.log('bar 1');
  foo();
  console.log('bar 2');
}

function baz() {
  console.log('baz');
}

//====================================================================

try {
  bar();
  baz();
} catch (error) {
  console.error(error);
}
// →
// bar 1
// foo 1
// Error foo

//--------------------------------------------------------------------

Bluebird.try(function () {
  return bar();
}).then(function () {
  return baz();
}).catch(function (error) {
  console.error(error);
});
// →
// bar 1
// foo 1
// Error foo
