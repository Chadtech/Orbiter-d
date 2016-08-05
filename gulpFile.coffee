gulp       = require 'gulp'
autowatch  = require 'gulp-autowatch'
source     = require 'vinyl-source-stream'
buffer     = require 'vinyl-buffer'
cp         = require 'child_process'
stylus     = require 'gulp-stylus'
coffeeify  = require 'coffeeify'
browserify = require 'browserify'

paths =
  public: './public'
  elm:    './src/elm/**/*.elm'
  css:    './src/css/*.styl'
  js:     './src/js/*.coffee'

gulp.task 'coffee', ->
  bCache = {}
  b = browserify './src/js/app.coffee',
    debug: true
    interestGlobals: false
    cache: bCache
    extensions: ['.coffee']
  b.transform coffeeify
  b.bundle()
  .pipe source 'app.js'
  .pipe buffer()
  .pipe gulp.dest paths.public

gulp.task 'stylus', ->
  gulp.src paths.css
  .pipe stylus()
  .pipe gulp.dest paths.public

gulp.task 'elm', ->  
  cmd  = 'elm-make ./src/elm/main.elm'
  cmd += ' --output ./public/elm.js'

  cp.exec cmd, (err, stdout) ->
    if err
      console.log 'ELM ERROR :^('
      console.log err
    else
      console.log 'Elm says .. '
      console.log (stdout.slice 0, stdout.length - 1)

gulp.task 'watch', ->
  {elm, css, js} = paths
  autowatch gulp,
    server: './public/*.html'
    stylus: css
    coffee: js
    elm:    elm


gulp.task 'server', -> require './server'

gulp.task 'default', 
  [ 'elm', 'coffee', 'stylus', 'watch', 'server' ]





 