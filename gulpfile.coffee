gulp = require('gulp')
nodemon = require('gulp-nodemon')

gulp.task 'server', ()->
	nodemon(
		script: 'app.coffee'
		ext: 'coffee html'
	)

gulp.task 'default', ()->
	gulp.start 'server'

