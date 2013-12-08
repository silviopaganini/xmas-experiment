var paths = {
	"plugins"  : "js/plugins",
	"vendors"  : "js/vendors/v.min",
    "svg"      : "js/vendors/snap.svg-min"
};

var libs = [];
for(var n in paths) libs.push(n);

requirejs.config({
	baseUrl: "",
	paths: paths,
	shim: {
        "svg" : ['vendors'],
        "vendors" : ["plugins"]
	}
});

require(libs, function(){
	require(["js/main.min.js"]);
});