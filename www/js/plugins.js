(function(){var e;var t=function(){};var n=["assert","clear","count","debug","dir","dirxml","error","exception","group","groupCollapsed","groupEnd","info","log","markTimeline","profile","profileEnd","table","time","timeEnd","timeStamp","trace","warn"];var r=n.length;var i=window.console=window.console||{};while(r--){e=n[r];if(!i[e]){i[e]=t;}}})();

window.AudioContext = window.AudioContext||window.webkitAudioContext;

window.addStats = function(){
    window.stats = new Stats();
    window.stats.domElement.style.position = 'absolute';
    window.stats.domElement.style.top = '0px';
    window.stats.domElement.style.zIndex='999'
    document.body.appendChild( window.stats.domElement );
}