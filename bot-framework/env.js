const path = require('path')
const fs = require('fs')

const getEnv = (path) => {
  try {
    // 指定された場所にファイルがあれば、そこから環境変数を読み込む
    return fs.readFileSync(envFile, { encoding: 'UTF-8' })
      .split("\n")
      .filter(it => it !== '')
      .map(it => it.split('='))
      .reduce((acc, it) => { acc[it[0]] = it[1]; return acc }, {})
  } catch (err) {
    // ファイルが見つからない場合、空のオブジェクトを返す
    return {}
  }
}

const envFile = path.dirname(__dirname) + '/.env'
const env = getEnv(envFile)

module.exports = Object.assign({
  NODE_ENV: process.env.NODE_ENV || 'development',
  MYOPE_API_URL: process.env.MYOPE_API_URL || 'http://localhost:3000',

  // Azure の環境変数があらかじめキャメルケースで定義されているので
  // 仕方なくここでもキャメルケースで定義する
  MicrosoftAppId: process.env.MicrosoftAppId,
  MicrosoftAppPassword: process.env.MicrosoftAppPassword,

  BOT_TOKEN: process.env.BOT_TOKEN,
}, env)
