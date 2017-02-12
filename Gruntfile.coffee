module.exports = (grunt) ->
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json')
    less: {
      development: {
        files: {
          './main.css': './src/main.less'
        }
      }
    }
    coffee: {
      compile: {
        files: {
          "./birthday.js" : "./src/birthday.coffee"
        }
      }
    }
    jade: {
      compile: {
        options: {
          pretty: true
        }
        files: {
          './index.html': './src/index.jade'
        }
      }
    }
    connect: {
      server: {
        options: {
          port: 3000
          debug: true
          keepalive: true
        }
      }
    }
  })

  grunt.loadNpmTasks('grunt-contrib-less')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-connect')
  # Set tasks
  grunt.registerTask('build',['less', 'coffee', 'jade'])
  grunt.registerTask('run', ['build', 'connect'])
