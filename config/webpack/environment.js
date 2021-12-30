const { environment } = require('@rails/webpacker')

const erb = require('./loaders/erb')
environment.loaders.prepend('erb', erb)

// allow imports to be accessible from the views
environment.config.merge({
  output: {
    library: ['Packs', '[name]'],
    libraryTarget: 'window'
  },
})

module.exports = environment
