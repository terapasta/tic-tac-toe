const { environment } = require('@rails/webpacker')

const config = environment.toWebpackConfig()
config.resolve.alias = Object.assign({}, {
  'vue$': 'vue/dist/vue.esm.js'
})

module.exports = config
