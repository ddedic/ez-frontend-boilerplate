var path = require('path');
var webpack = require("webpack");
//var glob_entries = require('webpack-glob-entries');
var glob = require("glob");

module.exports =  function(env){
    return {
        entry:
        //glob_entries(path.resolve(__dirname, 'javascript/src/**/*.js'))
        //glob.sync(path.resolve(__dirname, 'javascript/src/**/*.js'))
            path.resolve(__dirname, './app/Resources/public/js/app.js')
        ,
        output: {
            filename: 'bundle.js',
            //library: 'TV',
            path: path.resolve(__dirname, './web/assets/js')
        },
        module: {
            rules: [
                {
                    test: /\.js$/,
                    exclude: /node_modules/,
                    enforce: 'pre',
                    use: [{
                        loader: 'eslint-loader',
                        options: {
                            rules: {
                                semi: 0
                            }
                        }
                    }
                        ,{
                            loader: 'babel-loader',
                            options: {
                                presets: [
                                    ['es2015', { modules: false }]
                                ]
                            }
                        }
                    ],
                },
            ]
        },

        plugins: [
            new webpack.LoaderOptionsPlugin({
                // test: /\.xxx$/, // may apply this only for some modules
                options: {
                    eslint: {

                        configFile: '.eslintrc'
                    }
                }
            }),
            new webpack.SourceMapDevToolPlugin({
                options: {
                    test: /\.js$/,
                    exclude: /node_modules/,
                }
            })
        ]
    }
};