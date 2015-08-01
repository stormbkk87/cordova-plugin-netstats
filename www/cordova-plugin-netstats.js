var exec = require('cordova/exec');

var netstats = {
    init: function(host) {
        exec(null, null, "netstatsPlugin", "init", [host]);
    },
    getPing: function(params) {
        exec(params.onComplete, params.onError, "netstatsPlugin", "getPing", [params.numberOfPings]);
    }
};
    
module.exports = netstats;