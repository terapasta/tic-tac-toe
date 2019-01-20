const axios = require('axios')

const { MYOPE_API_URL } = require('./env')
axios.defaults.baseURL = MYOPE_API_URL

const functions = require('./api/functions')
module.exports = functions
