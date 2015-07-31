var exec = require('cordova/exec');

var netstats = {
    init: function(host) {
        exec(null, null, "netstatsPlugin", "init", [host]);
    },
    getPing: function(params) {
        exec(params.onComplete, null, "netstatsPlugin", "getPing", [params.numberOfPings]);
    }
};
    
module.exports = netstats;