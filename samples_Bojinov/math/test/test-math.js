var math = require('../modules/math.js');
var should = require('should');

describe('math', function() {

  it('add(1, 2) should give 3', function (done) {
    should.equal(math.add(1, 2), 3);
    done();
  });

  it('subtract(4, 2) should give 2', function (done) {
    should.equal(math.subtract(4, 2), 2);
    done();
  });

});

/* nodeunit tests (nodeunit is deprecated since 2018) */
/*
exports.test_add = function (test) {
    //test.equal(math.add(1, 1), 2);
	test.equal(math.add(1, 2), 3); // ==> AssertionError: 2 == 3
    test.done();
};

exports.test_subtract = function (test) {
    test.equals(math.subtract(4, 2), 2);
    test.done();
};
*/
