autoprefixer = require 'gulp-autoprefixer'
bootstrap    = require 'bootstrap-styl'
coffee       = require 'gulp-coffee'
concat       = require 'gulp-concat'
convert      = require 'gulp-images-convert'
gulp         = require 'gulp'
ignore       = require 'gulp-ignore'
imagemin     = require 'gulp-imagemin'
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

#
# Comile Stylus to CSS
#
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

#
# Compile CoffeeScript to JS
#
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

#
# Compile Jade (Pug) to HTML
#
gulp.task 'jade', ->
  gulp.src 'resources/jade/**/*.jade'
    .pipe plumber
      errorHandler: notify.onError 'Error: <%= error.message %>'
    .pipe jade()
    .on 'error', log
    .pipe gulp.dest 'public'

#
# Compress and convert images
#
gulp.task 'images', ->

  # Miscellaneous images
  gulp.src 'resources/images/misc/**'
    .pipe plumber
      errorHandler: notify.onError 'Error: <%= error.message %>'
    .on 'error', log
    .pipe imagemin()
    .pipe gulp.dest 'public/images/misc'
  
  # Company logos
  gulp.src 'resources/images/companies/**'
    .pipe plumber
      errorHandler: notify.onError 'Error: <%= error.message %>'
    .on 'error', log
    .pipe imagemin()
    .pipe gulp.dest 'public/images/companies'
  
  # Talk deck covers
  gulp.src 'resources/images/slides/**'
    .pipe plumber
      errorHandler: notify.onError 'Error: <%= error.message %>'
    .on 'error', log
    .pipe imagemin()
    .pipe gulp.dest 'public/images/slides'
  
  # Portfolio images

  # Covers
  gulp.src 'resources/images/works/**/*.*'
    .pipe plumber
      errorHandler: notify.onError 'Error: <%= error.message %>'
    .on 'error', log
    .pipe convert targetType: 'jpg'
    .pipe rename extname: '.jpg'
    .pipe imagemin()
    .pipe gulp.dest 'public/images/works'

  # # Covers
  # gulp.src 'resources/images/works/**/cover.*'
  #   .pipe plumber
  #     errorHandler: notify.onError 'Error: <%= error.message %>'
  #   .on 'error', log
  #   .pipe imagemin()
  #   .pipe gulp.dest 'public/images/works'

  # # Screenshots
  # gulp.src 'resources/images/works/**/*'
  #   .pipe plumber
  #     errorHandler: notify.onError 'Error: <%= error.message %>'
  #   .pipe ignore.exclude '**/cover.*'
  #   .on 'error', log
  #   .pipe imagemin()
  #   .pipe gulp.dest 'public/images/works'

#
# Watch files
#
gulp.task 'watch', ->
  gulp.watch 'resources/stylus/**/*', ['styles']
  gulp.watch 'resources/coffee/**/*', ['scripts']
  gulp.watch 'resources/jade/**/*', ['jade']
  return

#
# Webserver
#
gulp.task 'webserver', ->
  gulp.src 'public'
    .pipe server
      livereload: yes
      open: yes

#
# Build task
#
gulp.task 'build', ['scripts', 'styles', 'jade', 'images'], ->

#
# Default task
#
gulp.task 'default', ['webserver', 'watch', 'build'], ->
