#import <Cordova/CDVPlugin.h>

@interface netstatsPlugin : CDVPlugin

- (void)init:(CDVInvokedUrlCommand*)command;
- (void)getPing:(CDVInvokedUrlCommand*)command;

@end
