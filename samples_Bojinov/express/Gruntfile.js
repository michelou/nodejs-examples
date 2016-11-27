'use strict';

module.exports = function (grunt) {
  grunt.initConfig({
    jshint: {
      files: ['app/**/*.js'],
      options: {
        esversion: 6,
        strict: true,
        globals: {
        },
        node: true // module.exports
      }
    },
    watch: {
      files: ['<%= jshint.files %>'],
      tasks: ['jshint']
    },
    execute: {
      target: {
        src: ['app/app.js']
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-execute');

  grunt.registerTask('default', ['jshint', 'execute']);
  grunt.registerTask('run', ['execute']);
};
