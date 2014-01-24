module.exports = function(grunt) {
    grunt.initConfig({
        ender: {
            options: {
                output: "app/assets/javascripts/mobile/lib/ender",
                dependencies: ["bean", "bonzo", "qwery-mobile", "domready"]
            }
        }
    });
    grunt.loadNpmTasks('grunt-ender')
    grunt.registerTask('default', ['ender']);
};