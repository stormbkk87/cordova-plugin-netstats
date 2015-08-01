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

    NSLog(@"Finished Init");
}

- (void)getPing:(CDVInvokedUrlCommand*)command
{   
    NSLog(@"getPing");
    
    pingCallbackId = command.callbackId;
    limitPings = [[command.arguments objectAtIndex:0] intValue];

    [self.pinger startPinging];
}

#pragma mark CDZPingerDelegate

- (void)pinger:(CDZPinger *)pinger didUpdateWithAverageSeconds:(NSTimeInterval)seconds
{
    totalPings++;

    NSLog(@"Ping update");

    if (totalPings == limitPings){
        [self.pinger stopPinging];

        NSString *res = [NSString stringWithFormat:@"%f", (seconds * 1000.0)];
    
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: res];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:pingCallbackId];
    }
}

- (void)pinger:(CDZPinger *)pinger didEncounterError:(NSError *)error
{
    [self.pinger stopPinging];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: error.localizedDescription];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:pingCallbackId];
}

@end

