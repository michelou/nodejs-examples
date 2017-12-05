'use strict'

var fs = require('fs')
var path = require('path')
var xml2js = require('xml2js')

function read_json_file() {
  var file = path.resolve(__dirname, '../data/contacts.json')
  var s = '{ "results": [] }'
  try {
    s = fs.readFileSync(file)
  }
  catch (err) {
    console.log(err)
  }
  return s
}

var json = JSON.parse(read_json_file())

exports.list = function () {
  return json
}

exports.query = function (number) {
  var result = json.result
  for (var i = 0; i < result.length; i++) {
    var contact = result[i]
    if (contact.primarycontactnumber === number) {
      return contact
    }
  }
  return null
}

exports.query_by_arg = function (arg, value) {
  var result = json.result
  for (var i = 0; i < result.length; i++) {
    var contact = result[i]
    if (contact[arg] === value) {
      return contact
    }
  }
  return null
}

exports.list_groups = function () {
  var result = json.result
  var resultArray = []
  for (var i = 0; i < result.length; i++) {
    var groups = result[i].groups
    for (var index = 0; index < groups.length; index++) {
      if (resultArray.indexOf(groups[index]) === -1) {
        resultArray.push(groups[index])
      }
    }
  }
  return JSON.parse(JSON.stringify(resultArray))
}

exports.get_members = function (group_name) {
  var result = json.result
  var resultArray = []
  for (var i = 0; i < result.length; i++) {
    if (result[i].groups.indexOf(group_name) > -1) {
      resultArray.push(result[i])
    }
  }
  return resultArray
}

function read_xml_file() {
  var file = path.resolve(__dirname, '../data/contacts.xml')
  var s = ''
  try {
    s = fs.readFileSync(file)
  }
  catch (err) {
    console.log(err)
  }
  return s
}

exports.list_groups_from_xml = function (returnsXML) {
  var result = read_xml_file()
  if (returnsXML) {
    return result
  }
  else {
    xml2js.parseString(result, function (err, res) {
      if (err) {
        console.log(err)
        result = err
      }
      else { // JSON
        console.log(result)
        result = res
      }
    })
  }
  return result
}
