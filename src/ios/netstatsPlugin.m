#import <Cordova/CDV.h>
#import "netstatsPlugin.h"
#import "CDZPinger.h"

@interface netstatsPlugin () <CDZPingerDelegate>
@property (nonatomic, strong) CDZPinger *pinger;
@end

@implementation netstatsPlugin

NSString* pingCallbackId;
NSInteger totalPings = 0;
NSInteger limitPings = 0;

- (void)init:(CDVInvokedUrlCommand*)command
{
    NSString* host = [command.arguments objectAtIndex:0];
    
    self.pinger = [[CDZPinger alloc] initWithHost: host];
    self.pinger.delegate = self;
}

- (void)getPing:(CDVInvokedUrlCommand*)command
{   
    pingCallbackId = command.callbackId;
    limitPings = [[command.arguments objectAtIndex:0] intValue];

    [self.pinger startPinging];
}

#pragma mark CDZPingerDelegate

- (void)pinger:(CDZPinger *)pinger didUpdateWithAverageSeconds:(NSTimeInterval)seconds
{
    totalPings++;

    if (totalPings == limitPings){
        [self.pinger stopPinging];

        int result = (int)(seconds * 1000.0);
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt: result];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:pingCallbackId];
    }
}

- (void)pinger:(CDZPinger *)pinger didEncounterError:(NSError *)error
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: error.localizedDescription];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:pingCallbackId];
}

@end

