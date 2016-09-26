const webpack = require('webpack');
const path = require('path');

module.exports = {
    context: "app/assets/javascripts/src/",
    entry: {
      vendor: ['jquery','jquery-ujs','plugins/bootstrapv3/js/bootstrap.min'],
      login: 'controller/login.js',
      user: 'controller/user.js',
      personal_okr: 'controller/personal_okr.js',
      team_okr: 'controller/team_okr.js',
      company_okr: 'controller/company_okr.js',
      role: 'controller/role.js'
    },
    output: {
      path: __dirname + '/public/dist',
      publicPath: '/dist/',
      filename: '[name]-webpack.js',
    },
    resolve: {
      alias: {
        'jquery': 'plugins/jquery/jquery-1.11.1.min'
      },
      root: [
        // register root here
        path.resolve('./app/assets/javascripts/src'),
        path.resolve('./app/assets/images'),
        path.resolve('./app/assets/stylesheets'),
        path.resolve('./node_modules'),
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
    plugins: [
      new webpack.ProvidePlugin({
        $: "jquery",
        jQuery: "jquery",
        "window.jQuery": "jquery"
      })
    ]
  };
