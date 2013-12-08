var git_ignore  = ["node_modules/"];

var fs     = require('fs'),
    https  = require('https'),
    http   = require('http'),
    mkdirp = require('mkdirp');

var pkg = require('./package.json');

/*
DON'T CHANGE ANYTHING HERE
HAVE A LOOK AT THE PACKAGE.JSON INSTEAD
*/

var BIN     = pkg.folders.bin,
    SRC     = pkg.folders.src,
    CDN     = pkg.folders.static,
    FOLDERS = [
        BIN + "/"+ CDN +"/images", 
        BIN + "/"+ CDN +"/fonts", 
        BIN + "/"+ CDN +"/sound", 
        BIN + "/css", 
        BIN + "/js/vendors", 
        BIN + "/js/vendors/merged", 
        BIN + "/data", 
        SRC + "/coffee", 
        SRC + "/coffee/models", 
        SRC + "/coffee/collections", 
        SRC + "/coffee/router", 
        SRC + "/coffee/utils", 
        SRC + "/coffee/view", 
        SRC + "/stylus"],

    index       = BIN + "/index.html",
    plugins     = BIN + "/js/plugins.js",
    r           = BIN + "/js/r.js",
    mainStyl    = SRC + "/stylus/main.styl",
    appCoff     = SRC + "/coffee/App.coffee",
    appRouter   = SRC + "/coffee/router/Router.coffee",
    appViewCoff = SRC + "/coffee/AppView.coffee",
    ignore      = ".gitignore",

    request = null,
    commandQueue = [],

    icon        = 'http://favicon.cargocollective.com/517181361830966.ico',
    boilerplate = 'https://raw.github.com/silviopaganini/html5_proj_start/master/boilerplate/index.html',
    require     = 'http://requirejs.org/docs/release/2.1.9/minified/require.js',
    modernizr   = 'http://modernizr.com/downloads/modernizr-2.6.2.js',
    jquery      = 'http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js',
    backbone    = 'http://backbonejs.org/backbone-min.js',
    underscore  = 'http://underscorejs.org/underscore-min.js';

var color = {
    reset : '\x1b[0m',
    green : '\x1b[32m',
    red : '\x1b[31m'
};


function writeIndexBoilerplate(callBack)
{
    // download latest HTML5 boilerplate
    var indexFile = fs.createWriteStream(index);
    request = https.get(boilerplate, function(response) {
      response.pipe(indexFile);
      if(callBack) callBack();
    });
}

function writePluginsJS(callBack)
{
    var pluginsText = '(function(){var e;var t=function(){};var n=["assert","clear","count","debug","dir","dirxml","error","exception","group","groupCollapsed","groupEnd","info","log","markTimeline","profile","profileEnd","table","time","timeEnd","timeStamp","trace","warn"];var r=n.length;var i=window.console=window.console||{};while(r--){e=n[r];if(!i[e]){i[e]=t;}}})();';
    fs.writeFile(plugins, pluginsText, function(err) {
        if(err) {
            console.log(err);
        } else {
            if(callBack) callBack();
        }
    });
}

function writeModernizr(callBack)
{
    var m = fs.createWriteStream(BIN + "/js/vendors/modernizr-dev.js");
    request = http.get(modernizr, function(response) {
      response.pipe(m);

      if(callBack) callBack();
    });
}

function writeBackbone(callBack)
{
    var m = fs.createWriteStream(BIN + "/js/vendors/merged/backbone.js");
    request = http.get(backbone, function(response) {
      response.pipe(m);

      if(callBack) callBack();
    });
}

function writeUnderscore(callBack)
{
    var m = fs.createWriteStream(BIN + "/js/vendors/merged/_underscore.js");
    request = http.get(modernizr, function(response) {
      response.pipe(m);

      if(callBack) callBack();
    });
}

function writejQuery(callBack)
{
    var m = fs.createWriteStream(BIN + "/js/vendors/merged/__jquery.js");
    request = http.get(jquery, function(response) {
      response.pipe(m);

      if(callBack) callBack();
    });
}

function writeGitIgnore(callBack)
{
    fs.writeFile(ignore, git_ignore.toString().split(",").join("\n"), function(err) {
        if(err) {
            console.log(err);
        } else {
            if(callBack) callBack();
        }
    });
}


function writeDefaultIcon(callBack)
{
    var ico = fs.createWriteStream(BIN + "/favicon.ico");
    request = http.get(icon, function(response) {
      response.pipe(ico);

      if(callBack) callBack();
    });
}

function writeAppCoffee(callBack)
{
    var appCoffeeText = "###\n\nAdd here the sequence of your imports, usually start with \n\nutils.*\nmodels.*\ncollections.*\nrouter.*\nview.*\n\n###\n#import AppView.coffee\n\n\n# DECLARE MAIN WINDOW METHODS AND VARS\nview = (window || document)\n\n#define your namespace\nview.ns = {}\nview.ns.appView = new AppView\n\nconsole.log('hello world')"
    var appViewText = "class AppView extends Backbone.View\n\n\t#this should be your $body, use it!\n\n\tinit : =>\n\t\t@setElement $('body')"
    var routerText = "class Router extends Backbone.Router\n\n\troutes :\n\t\t'(/):area(/)'     : 'hashChanged'\n\t\t'(/):area/:id(/)' : 'hashChanged'\n\t\t'*actions'        : 'hashChanged'\n\n\tstart: ->\n\t\tBackbone.history.start \n\t\t\tpushState: true, \n\t\t\troot: ''\n\n\t\treturn null\n\n\thashChanged : (area = null, sub = null) =>\n\t\tconsole.log(area, sub)\n\n\t\tnull\n\n\tnavigateTo : (where, trigger = true) =>\n\n\t\twhere = '/' if where is undefined\n\n\t\tif where.charAt( where.length - 1 ) != '/'\n\t\t\twhere += '/'\n\n\t\t@navigate where, trigger: trigger\n\n\t\treturn null"

    fs.writeFile(appCoff, appCoffeeText, function(err) {
        if(err) {
            console.log(err);
        } else {
            fs.writeFile(appViewCoff, appViewText, function(err) {
                if(err) {
                    console.log(err);
                } else {
                    fs.writeFile(appRouter, routerText, function(err) {
                        if(err) {
                            console.log(err);
                        } else {
                            if(callBack) callBack();
                        }
                    });
                }
            });
        }
    });
}

function writeRequire(callBack)
{
    var appRequireText = 'var paths = {\n\t"plugins"  : "js/plugins",\n\t"vendors"  : "js/vendor/v.min"\n};\n\nvar libs = [];\nfor(var n in paths) libs.push(n);\n\n';
    appRequireText    += 'requirejs.config({\n\tbaseUrl: "",\n\tpaths: paths,\n\tshim: {\n\t\t"vendors" : ["plugins"]\n\t}\n});\n\n';
    appRequireText    += 'require(libs, function(){\n\trequire(["js/main.min.js"]);\n});';

    fs.writeFile(r, appRequireText, function(err) {
        if(err) {
            console.log(err);
        } else {
            if(callBack) callBack();
        }
    });
}

function writeStylus(callBack)
{
    var stlText = "@import 'nib'\n\nglobal-reset()\n\n/*\nsprites vars\n_CDN = \"{{CDN_URL}}\"\nFOLDER_PATH = _CDN + 'img/ss/'\n*/\n\n_CDN = \"{{CDN_URL}}\"\n\n/* GLOBALS */\n\n::-moz-selection\n\tbackground transparent\n\ttext-shadow none\n::selection\n\tbackground transparent\n\ttext-shadow none\nhtml\n\t-webkit-text-size-adjust: 100%\n\t-ms-text-size-adjust: 100%\n\tmargin 0\n\tpadding 0\n\tsize 100% 100%\n\t-webkit-font-smoothing: antialiased\n\ttext-shadow: 1px 1px 1px rgba(0,0,0,0.004)\n\nbody\n\tuser-select(none)\n\tmargin 0\n\tpadding 0\n\tsize 100% 100%\n\tbackground-color #000\n\toverflow hidden\n\tfont-smoothing(antialiased)\n\n";

    fs.writeFile(mainStyl, stlText, function(err) {
        if(err) {
            console.log(err);
        } else {
            if(callBack) callBack();
        }
    });
}

function createDefaultFolders(callBack)
{
    total = FOLDERS.length - 2;
    current = 0;

    mkdirp(BIN, function(err) {

        // create folders
        for(var i in FOLDERS) mkdirp(FOLDERS[i], function(){
            if(current == total) if(callBack) callBack();
            current++;
        });
    });
}

function processQueue()
{
    commandQueue[0].c.apply(this, [commandComplete]);
}

function commandComplete()
{
    log(commandQueue[0].msg);

    if(commandQueue.length > 1)
    {
        commandQueue.shift();
        processQueue();
    } else {
        log("=) Ready to go\n");
    }
}

function log(msg, error)
{
    error = error || false;
    console.log(error ? color.red : color.green + msg + color.reset);
}

/*

Setup order of commands to process

*/

function setup()
{
    commandQueue = [];
    commandQueue.push({c : createDefaultFolders  , msg : "Folders -> OK"});
    commandQueue.push({c : writeAppCoffee        , msg : "App.coffee -> OK"});
    commandQueue.push({c : writeStylus           , msg : "Write Stylus -> OK"});
    commandQueue.push({c : writeIndexBoilerplate , msg : "Index Boilerplate -> OK"});
    commandQueue.push({c : writeRequire          , msg : "Require Loading -> OK"});
    commandQueue.push({c : writePluginsJS        , msg : "Default Plugins -> OK"});
    commandQueue.push({c : writeModernizr        , msg : "Modernizr -> OK"});
    commandQueue.push({c : writeBackbone         , msg : "Backbone -> OK"});
    commandQueue.push({c : writeUnderscore       , msg : "Underscore -> OK"});
    commandQueue.push({c : writejQuery           , msg : "jQuery -> OK"});
    commandQueue.push({c : writeDefaultIcon      , msg : "Default Icon -> OK"});
    commandQueue.push({c : writeGitIgnore        , msg : "git ignore -> OK"});
    
    processQueue();
}


setup();
