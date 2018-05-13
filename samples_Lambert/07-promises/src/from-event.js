'use strict';

var EventEmitter = require('events').EventEmitter;

// Le module `event-to-promise`
// (https://www.npmjs.com/package/event-to-promise) permet de créer
// une promesse qui sera résolue à l'arrivée d'un événement.
var eventToPromise = require('event-to-promise');

var emitter = new EventEmitter();

function waitFooEvent() {
  eventToPromise(emitter, 'foo')

    // Si l'événement attendu (ici `foo`) arrive alors la promesse est
    // résolue.
    .then(function (value) {
      console.log('succès : %j', value);
    })

    // Si l'événement `error` survient avant alors la promesse est
    // rejetée.
    .catch(function (error) {
      console.error('erreur : %j', error);
    })
  ;
}

waitFooEvent();
emitter.emit('foo', 'bar');
// > succès : "bar"

waitFooEvent();
emitter.emit('error', 'baz');
// > erreur : "baz"
