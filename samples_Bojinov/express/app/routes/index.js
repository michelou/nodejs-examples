'use strict'

var moment = require('moment')

exports.index = function (req, res) {
  return res.status(200).send(moment().format())
}
