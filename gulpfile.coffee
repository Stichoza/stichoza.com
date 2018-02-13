autoprefixer = require 'gulp-autoprefixer'
bootstrap    = require 'bootstrap-styl'
coffee       = require 'gulp-coffee'
gulp         = require 'gulp'
ignore       = require 'gulp-ignore'
jade         = require 'gulp-jade'
log          = require 'fancy-log'
minifycss    = require 'gulp-minify-css'
notify       = require 'gulp-notify'
plumber      = require 'gulp-plumber'
rename       = require 'gulp-rename'
sourcemaps   = require 'gulp-sourcemaps'
stylus       = require 'gulp-stylus'
uglify       = require 'gulp-uglify'

gulp.task 'styles', ->
  gulp.src 'resources/stylus/**/*.styl'
    .pipe plumber
      errorHandler: notify.onError 'Error: <%= error.message %>'
    .pipe ignore.exclude '**/_*.styl'
    .on 'error', log
    .pipe stylus
      use: bootstrap()
    .pipe autoprefixer 'last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1'
    .pipe rename
      suffix: '.min'
    .pipe minifycss
      processImport: yes
    .pipe gulp.dest 'public/css'
  gulp.src 'resources/stylus/**/*.css'
    .pipe plumber
      errorHandler: notify.onError 'Error: <%= error.message %>'
    .pipe autoprefixer 'last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1'
    .pipe rename
      suffix: '.min'
    .pipe minifycss
      processImport: no
    .pipe gulp.dest 'public/css'

gulp.task 'scripts', ->
  gulp.src 'resources/coffee/**/*.coffee'
    .pipe plumber
      errorHandler: notify.onError 'Error: <%= error.message %>'
    .pipe coffee()
    .on 'error', log
    .pipe uglify()
    .pipe rename
      suffix: '.min'
    .pipe gulp.dest 'public/js'

gulp.task 'jade', ->
  gulp.src 'resources/jade/**/*.jade'
    .pipe plumber
      errorHandler: notify.onError 'Error: <%= error.message %>'
    .pipe jade()
    .on 'error', log
    .pipe gulp.dest 'public'

gulp.task 'watch', ->
  gulp.watch 'resources/stylus/**/*', ['styles']
  gulp.watch 'resources/coffee/**/*', ['scripts']
  gulp.watch 'resources/jade/**/*', ['jade']
  return

gulp.task 'build', ['scripts', 'styles', 'jade'], ->

gulp.task 'default', ['watch', 'build'], ->
