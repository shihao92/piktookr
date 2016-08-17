const path = require('path');

module.exports = {
    context: "app/assets/javascripts/src/",
    entry: {
      shared: 'controller/shared.js',
      role: 'controller/role.js',
      team_key_result: 'controller/objective_key_result/team_key_result',
      personal_objective: 'controller/objective_key_result/personal_objective'
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
        path.resolve('./app/assets/images'),
        path.resolve('./app/assets/stylesheets'),
        // path.resolve()
      ],
    },
    resolveLoader: {
      root: path.join( __dirname, 'node_modules' )
    },
    module: {
      loaders: [
        { test: /\.(css|scss)$/, loader: 'style!css' },
        { test: /\.(png|jpg|jpeg)$/, loader: 'file'},
        {
          test: /\.js$/,
          exclude: /(node_modules)/,
          loader: 'babel', // 'babel-loader' is also a legal name to reference
        },
      ],
    },
    devtool: 'eval',
  };
