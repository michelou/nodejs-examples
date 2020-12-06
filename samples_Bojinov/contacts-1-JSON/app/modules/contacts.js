'use strict'

const fs = require('fs')
const path = require('path')
const xml2js = require('xml2js')

function read_json_file() {
  const file = path.resolve(__dirname, '../data/contacts.json')
  let s = '{ "results": [] }'
  try {
    s = fs.readFileSync(file)
  }
  catch (err) {
    console.log(err)
  }
  return s
}

const json = JSON.parse(read_json_file())

exports.list = function () {
  return json
}

exports.query = function (number) {
  const result = json.result
  for (let i = 0; i < result.length; i++) {
    const contact = result[i]
    if (contact.primarycontactnumber === number) {
      return contact
    }
  }
  return null
}

exports.query_by_arg = function (arg, value) {
  const result = json.result
  for (let i = 0; i < result.length; i++) {
    const contact = result[i]
    if (contact[arg] === value) {
      return contact
    }
  }
  return null
}

exports.list_groups = function () {
  const result = json.result
  const resultArray = []
  for (let i = 0; i < result.length; i++) {
    const groups = result[i].groups
    for (let index = 0; index < groups.length; index++) {
      if (resultArray.indexOf(groups[index]) === -1) {
        resultArray.push(groups[index])
      }
    }
  }
  return JSON.parse(JSON.stringify(resultArray))
}

exports.get_members = function (group_name) {
  const result = json.result
  const resultArray = []
  for (let i = 0; i < result.length; i++) {
    if (result[i].groups.indexOf(group_name) > -1) {
      resultArray.push(result[i])
    }
  }
  return resultArray
}

function read_xml_file() {
  const file = path.resolve(__dirname, '../data/contacts.xml')
  let s = ''
  try {
    s = fs.readFileSync(file)
  }
  catch (err) {
    console.log(err)
  }
  return s
}

exports.list_groups_from_xml = function (returnsXML) {
  let result = read_xml_file()
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
