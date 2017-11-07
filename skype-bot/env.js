const path = require('path')
const fs = require('fs')

const envFile = path.dirname(__dirname) + '/.env'
const env = fs.readFileSync(envFile, { encoding: 'UTF-8' })
  .split("\n")
  .filter(it => it !== '')
  .map(it => it.split('='))
  .reduce((acc, it) => { acc[it[0]] = it[1]; return acc }, {})

module.exports = env