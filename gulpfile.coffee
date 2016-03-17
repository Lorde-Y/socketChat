gulp = require('gulp')
nodemon = require('gulp-nodemon')
coffeeify = require('gulp-coffeeify')
less = require('gulp-less')
clean = require('gulp-clean')

coffeeDir = __dirname + '/client/src/*.coffee'
lessDir = __dirname + '/client/src/*.less'

gulp.task 'server', ()->
	nodemon(
		script: 'app.coffee'
		ext: 'coffee html'
	)

gulp.task 'coffee', ['clean:coffee'], ()->
	gulp.src(coffeeDir)
	.pipe(coffeeify())
	.pipe(gulp.dest('client/dist/js'))

gulp.task 'less', ['clean:less'], ()->
	gulp.src(lessDir)
	.pipe(less())
	.pipe(gulp.dest('client/dist/css'))

gulp.task 'clean:coffee', ()->
	gulp.src('client/dist/js')
	.pipe(clean({force:true}))

gulp.task 'clean:less', ()->
	gulp.src('client/dist/css')
	.pipe(clean({force:true}))

gulp.task 'default', ()->
	gulp.start 'server','coffee', 'less', 'watchFile'

gulp.task 'watchFile', ()->
	gulp.watch coffeeDir, ()->
		gulp.start 'coffee'

	gulp.watch lessDir, ()->
		gulp.start 'less'

	gulp.watch 'gulpfile.coffee', ()->
		gulp.start 'default'

