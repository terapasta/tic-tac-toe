const environment = require('./environment')

const config = environment.toWebpackConfig()
config.resolve.alias = Object.assign({}, {
  'vue$': 'vue/dist/vue.esm.js'
})

module.exports = config
