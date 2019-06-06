const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.config.set('resolve.extensions', ['.js', '.jsx'])
environment.config.set('resolve.alias.vue$', 'vue/dist/vue.esm.js')

const defaultConfig = environment.toWebpackConfig()
const defaultEntry = Object.assign({}, defaultConfig.entry)
delete defaultEntry.embed

const nonDigestConfig = {
  entry: {
    embed: defaultConfig.entry.embed,
  },
  output: {
    filename: 'embed.js',
    path: defaultConfig.output.path,
    publicPath: defaultConfig.output.publicPath,
    pathinfo: true,
  },
  plugins: [],
}

module.exports = [
  Object.assign({}, defaultConfig, { entry: defaultEntry }),
  Object.assign({}, defaultConfig, nonDigestConfig),
]
