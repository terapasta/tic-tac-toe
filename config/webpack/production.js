const webpack = require('webpack')
const config = require('./environment')

config.plugins = config.plugins.map(plug => {
  if (plug instanceof webpack.optimize.UglifyJsPlugin) {
    return new webpack.optimize.UglifyJsPlugin({
      sourceMap: false,
      parallel: true,
      mangle: false,
      uglifyOptions: {
        mangle: false
      },
      compress: {
        warnings: false
      },
      output: {
        comments: false
      }
    });
  }
  return plug;
})

config.devtool = 'eval'

module.exports = config
