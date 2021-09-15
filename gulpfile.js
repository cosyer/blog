var gulp = require('gulp');
var minifycss = require('gulp-minify-css');
var minify = require('gulp-minify');
var htmlmin = require('gulp-htmlmin');
var htmlclean = require('gulp-htmlclean');
var imagemin = require('gulp-imagemin');
var order = require("gulp-order");
var concat = require("gulp-concat");
const rev = require('gulp-rev');

// 压缩、合并 CSS
gulp.task('css', function () {
    return gulp.src([
        './public/lib/font-awesome/css/font-awesome.min.css',
        './public/lib/fancybox/source/jquery.fancybox.css',
        './public/css/main.css',
        './public/css/lib.css',
        './public/live2dw/css/perTips.css'
    ]).pipe(concat('all.css')).pipe(minify()).pipe(rev()).pipe(gulp.dest('./public/dist/'));
});
// 压缩 public 目录 css
gulp.task('minify-css', function () {
    return gulp.src('./public/**/*.css')
        .pipe(minifycss())
        .pipe(gulp.dest('./public'));
});
// 压缩 public 目录 html
gulp.task('minify-html', function () {
    return gulp.src('./public/**/*.html')
        .pipe(htmlclean())
        .pipe(htmlmin({
            removeComments: true,
            minifyJS: true,
            minifyCSS: true,
            minifyURLs: true,
        }))
        .pipe(gulp.dest('./public'))
});
//压缩、合并js
gulp.task('scripts', function () {
    return gulp.src([
        './public/lib/fastclick/lib/fastclick.min.js',
        './public/lib/jquery_lazyload/jquery.lazyload.js',
        './public/lib/velocity/velocity.min.js',
        './public/lib/velocity/velocity.ui.min.js',
        './public/lib/fancybox/source/jquery.fancybox.pack.js',
        './public/js/src/utils.js',
        './public/js/src/motion.js',
        './public/js/src/scrollspy.js',
        './public/js/src/post-details.js',
        './public/js/src/bootstrap.js',
        './public/js/src/push.js',
        './public/live2dw/js/perTips.js',
        './public/live2dw/lib/L2Dwidget.min.js',
        './public/js/src/love.js',
        './public/js/src/busuanzi.pure.mini.js',
        './public/js/src/activate-power-mode.js',
        './public/js/src/cosyer.js'
    ]).pipe(concat('all.js')).pipe(minify()).pipe(rev()).pipe(gulp.dest('./public/dist/'));
});
// 压缩 public/js 目录 js
gulp.task('minify-js', function () {
    gulp.src('./public/**/*.js')
        .pipe(minify({
            ext: {
                src: '-debug.js',
                min: '.js'
            },
            exclude: ['tasks'],
            ignoreFiles: ['.combo.js', '-min.js']
        }))
        .pipe(gulp.dest('./public'))
});
//建立一个imagemin任务 直接可以用 gulp imagemin就可以执行这个任务
gulp.task('imagemin', function () {
    gulp.src('./public/**/*.{png,jpg,gif,ico,jpeg}')
        .pipe(imagemin())
        .pipe(gulp.dest('./public'));
});
// 执行 gulp 命令时执行的任务
gulp.task('default', [
    'css', 'scripts', 'minify-html', 'minify-css', 'minify-js', 'imagemin'
]);