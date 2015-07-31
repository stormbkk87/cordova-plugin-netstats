var exec = require('cordova/exec');

var netstats = {
    init: function(host) {
        exec(null, null, "netstatsPlugin", "init", [host]);
    },
    getPing: function(successCallback, numberOfPings) {
        exec(successCallback, null, "netstatsPlugin", "getPing", [numberOfPings]);
    }
};
    
module.exports = netstats;