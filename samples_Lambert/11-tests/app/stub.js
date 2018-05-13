'use strict';

var sinon = require('sinon');

// Création du bouchon.
var stub = sinon.stub();

// Configuration pour qu'il lève une exception.
stub.throws();

// Sauf si 42 est passé dans ce cas là il retourne 1.
stub.withArgs(42).returns(1);
