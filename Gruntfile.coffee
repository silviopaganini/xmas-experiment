module.exports = (grunt) ->

    "use strict"

    pkg = grunt.file.readJSON("package.json")

    # Project configuration
    grunt.initConfig
        pkg: pkg

        # Set the path for all folders
        paths:
            source:
                coffee:   pkg.folders.src + "/coffee"
                css:      pkg.folders.src + "/stylus"
                toMerge:  pkg.folders.bin + "/js/vendors/merged"
                r:        pkg.folders.bin + "/js/r.js"
                js:       pkg.folders.bin + "/js/main.js"

            release:
                r:        pkg.folders.bin + "/js/r.min.js"
                js:       pkg.folders.bin + "/js/main.min.js"
                css:      pkg.folders.bin + "/css/main.css"
                vendors:  pkg.folders.bin + "/js/vendors/v.min.js"
                bin :     pkg.folders.bin

            map:
                build     : pkg.folders.bin + "/js/main.map"
                build_url : "/js/main.map"
                r         : pkg.folders.bin + "/js/r.map"
                r_url     : "/js/r.map"


         # Uglify
        uglify: 
            coffee: 
              options: 
                banner           : "'use strict';\n"
                sourceMap        : "<%= paths.map.build %>"
                sourceMappingURL : "<%= paths.map.build_url %>"
                sourceMapPrefix : 2
              files: 
                '<%= paths.release.js %>': ['<%= paths.source.js %>']

            require: 
                options: 
                    banner: "'use strict';\n"
                    sourceMap     : '<%= paths.map.r %>'
                    sourceMappingURL : "<%= paths.map.r_url %>"
                    sourceMapPrefix : 2
                files: 
                    '<%= paths.release.r %>': ['<%= paths.source.r %>']


        concat: 
            options: 
                banner: '/*! <%= pkg.name %> | <%= pkg.author %> - VENDORS - v<%= pkg.version %> - ' + '<%= grunt.template.today("yyyy-mm-dd") %> */\n\n'
                separator : '\n\n'
            vendors: 
              src: ["<%= paths.source.toMerge %>/core/*.js", "<%= paths.source.toMerge %>/*.js", "<%= paths.source.toMerge %>/three/*.js"]
              dest: '<%= paths.release.vendors %>'

       
        # Compile SASS
        sass: 
            dist: 
                files : 
                    '<%=paths.release.css%>' : "<%=paths.source.css%>/wrapper.scss"

        stylus: 
            compile: 
                options:
                    compress: true
                files: 
                    "<%= paths.release.css %>": "<%= paths.source.css %>/**/*.styl"
            
        # Watch for changes
        watch:
            main: 
                files : ["<%= paths.source.coffee %>/**/*.coffee", "<%= paths.source.css %>/**/*.styl", "<%= paths.release.bin %>*.html"]
                tasks : ['percolator:main', 'stylus', 'uglify']
                options : 
                    livereload: true


        # Compile CoffeeScript using Percolator
        percolator: 
            main:
                source: '<%= paths.source.coffee %>'
                output: '<%= paths.source.js %>'
                main: 'App.coffee'

        # Modernizr custom build (based on css classes / js obj references)
        modernizr :
            devFile    : pkg.folders.bin + "/js/vendors/modernizr-dev.js"
            outputFile : pkg.folders.bin + "/js/vendors/modernizr-custom.js"

            extra :
                shiv       : true
                printshiv  : false
                load       : true
                mq         : false
                cssclasses : true

            extensibility :
                addtest      : false
                prefixed     : false
                teststyles   : false
                testprops    : false
                testallprops : false
                hasevents    : false
                prefixes     : false
                domprefixes  : false

            parseFiles : true

            files : ['<%= paths.release.bin %>/**/*.js', '<%= paths.release.bin %>/**/*.css']

        # css prefixes
        autoprefixer:
            build:
                options:
                    browsers: ["ie >= 8", "ff >= 3", "safari >= 4", "opera >= 12", "chrome >= 4" ]
                files:
                    "<%= paths.release.css %>": "<%= paths.release.css %>"

    # Load tasks
    list = pkg.devDependencies
    grunt.loadNpmTasks k for k, v of list
        
    # Register tasks.
    grunt.registerTask "default", ["percolator:main", "stylus", "autoprefixer:build", "uglify:require", "uglify:coffee", "modernizr"]
    grunt.registerTask "w", ["percolator:main", "stylus", "autoprefixer:build", "uglify:require", "uglify:coffee", "watch:main"]
    grunt.registerTask "v", ["concat:vendors"]
    grunt.registerTask "m", "modernizr"
