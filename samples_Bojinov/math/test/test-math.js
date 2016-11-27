var math = require('../modules/math.js');

exports.test_add = function (test) {
    //test.equal(math.add(1, 1), 2);
	test.equal(math.add(1, 1), 3); // ==> AssertionError: 2 == 3
    test.done();
};

exports.test_subtract = function (test) {
    test.equals(math.subtract(4,2), 2);
    test.done();
};
