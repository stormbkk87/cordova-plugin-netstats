# cordova-plugin-netstats
Cordova iOS plugin gathers stats on the current network connection to a remote host

Current

getPing - Average ping latency in milliseconds

Future

Jitter
Packet Loss

    document.addEventListener('deviceready', function () {
      if (window.device.platform === 'iOS') {
        cordova.plugins.netstats.init(<hostname>);
          
        cordova.plugins.netstats.getPing({
          numberOfPings: 6,
          onComplete: function(result){
            console.log("Avg Ping: "+result);
          },
          onError: function(error){
            console.log("Error from plugin netstats: "+error);
          }
        });
      }
    }, false);
