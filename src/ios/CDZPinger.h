#import <Foundation/Foundation.h>

@protocol CDZPingerDelegate;

@interface CDZPinger : NSObject

@property (nonatomic, weak) id<CDZPingerDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *domainOrIp;

/**
 * Number of pings to average. Defaults to 6.
 */
@property (nonatomic, assign) NSUInteger averageNumberOfPings;

/**
 * Seconds to wait in between pings. Defaults to 1.0.
 */
@property (nonatomic, assign) NSTimeInterval pingWaitTime;

/**
 * Designated initializer.
 *
 * @param domainOrIp Domain name or IPv4 address to ping
 */
- (id)initWithHost:(NSString *)domainOrIp;

/**
 * Tell the pinger to begin pinging when it's ready.
 */
- (void)startPinging;

/**
 * Tell the pinger to stop pinging and clean up.
 */
- (void)stopPinging;

@end

@protocol CDZPingerDelegate <NSObject>

/**
 * Called every time the pinger receives a ping back from the server.
 *
 * @param pinger This CDZPinger object
 * @param seconds The average ping time, in seconds
 */
- (void)pinger:(CDZPinger *)pinger didUpdateWithAverageSeconds:(NSTimeInterval)seconds;

@optional

/**
 * Reports a ping error.
 *
 * Note: The pinger stops running after any error is encountered.
 *
 * @param pinger This CDZPinger object
 * @param error The NSError that was encountered
 */
- (void)pinger:(CDZPinger *)pinger didEncounterError:(NSError *)error;

@end

typedef void(^SMDelayedBlockHandle)(BOOL cancel);

static SMDelayedBlockHandle perform_block_after_delay(CGFloat seconds, dispatch_block_t block) {
    
    if (nil == block) {
        return nil;
    }
    
    // block is likely a literal defined on the stack, even though we are using __block to allow us to modify the variable
    // we still need to move the block to the heap with a copy
    __block dispatch_block_t blockToExecute = [block copy];
    __block SMDelayedBlockHandle delayHandleCopy = nil;
    
    SMDelayedBlockHandle delayHandle = ^(BOOL cancel){
        if (NO == cancel && nil != blockToExecute) {
            dispatch_async(dispatch_get_main_queue(), blockToExecute);
        }
        
        // Once the handle block is executed, canceled or not, we free blockToExecute and the handle.
        // Doing this here means that if the block is canceled, we aren't holding onto retained objects for any longer than necessary.
#if !__has_feature(objc_arc)
        [blockToExecute release];
        [delayHandleCopy release];
#endif
        
        blockToExecute = nil;
        delayHandleCopy = nil;
    };
    
    // delayHandle also needs to be moved to the heap.
    delayHandleCopy = [delayHandle copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (nil != delayHandleCopy) {
            delayHandleCopy(NO);
        }
    });
    
    return delayHandleCopy;
};

static void cancel_delayed_block(SMDelayedBlockHandle delayedHandle) {
    if (nil == delayedHandle) {
        return;
    }
    
    delayedHandle(YES);
}