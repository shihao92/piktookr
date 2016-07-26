const path = require('path');

module.exports = {
    context: "app/assets/javascripts/src/",
    entry: {
      dashboard:'controller/role.js',

    },
    output: {
      path: __dirname + '/public/dist',
      publicPath: '/dist/',
      filename: '[name]-webpack.js',
    },
    resolve: {
      root: [
        // register root here
        path.resolve('./app/assets/javascripts/src'),
        // path.resolve()
      ],
    },
    resolveLoader: {
      root: path.join( __dirname, 'node_modules' )
    },
    module: {
      loaders: [
        { test: /\.css$/, loader: 'style!css' },
        {
          test: /\.js$/,
          exclude: /(node_modules)/,
          loader: 'babel', // 'babel-loader' is also a legal name to reference
        },
      ],
    },
    devtool: 'eval',
  };
