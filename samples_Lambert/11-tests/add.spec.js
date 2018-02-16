'use strict';

//====================================================================

// Importe la fonction à tester.
var add = require('./add');

var expect = require('chai').expect;

// La bibliothèque Leche (https://github.com/box/leche) permet de
// construire des tests à partir d'un jeu de données.
var leche = require('leche');

//====================================================================

describe('add()', function () {

  leche.withData({
    'naturals': [42, 1024, 1066],
    'integers': [-69, -2, -71],
    'floats': [6.28, 2.72, 9],
  }, function (a, b, sum) {

    it('computes the sum', function () {
      expect(add(a, b)).to.equal(sum);
    });

  });

});
