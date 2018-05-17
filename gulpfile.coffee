autoprefixer = require 'gulp-autoprefixer'
bootstrap    = require 'bootstrap-styl'
coffee       = require 'gulp-coffee'
concat       = require 'gulp-concat'
gulp         = require 'gulp'
ignore       = require 'gulp-ignore'
jade         = require 'gulp-jade'
log          = require 'fancy-log'
minifycss    = require 'gulp-minify-css'
notify       = require 'gulp-notify'
plumber      = require 'gulp-plumber'
rename       = require 'gulp-rename'
server       = require 'gulp-server-livereload'
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

gulp.task 'images', ->
  gulp.src 'resources/images/**'
    .pipe gulp.dest 'public/images'

gulp.task 'watch', ->
  gulp.watch 'resources/stylus/**/*', ['styles']
  gulp.watch 'resources/coffee/**/*', ['scripts']
  gulp.watch 'resources/jade/**/*', ['jade']
  gulp.watch 'resources/images/**/*', ['images']
  return

gulp.task 'webserver', ->
  gulp.src 'public'
    .pipe server
      livereload: yes
      open: yes

gulp.task 'build', ['scripts', 'styles', 'jade', 'images'], ->

gulp.task 'default', ['webserver', 'watch', 'build'], ->
