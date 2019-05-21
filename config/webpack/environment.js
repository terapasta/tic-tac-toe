const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.config.set('resolve.extensions', ['.js', '.jsx'])

const defaultConfig = environment.toWebpackConfig()
const defaultEntry = { ...defaultConfig.entry }
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
  { ...defaultConfig, entry: defaultEntry },
  { ...defaultConfig, ...nonDigestConfig }
]
