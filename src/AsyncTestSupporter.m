//
//  AsyncTestSupporter.m
//
//  Created by yaakaito on 12/09/09.
//
//

#import "AsyncTestSupporter.h"

@interface AsyncTestSupporter ()
@property NSInteger status;
@end

@implementation AsyncTestSupporter

- (void)prepare {
    self.status = kAsyncTestSupporterWaitStatusUnknown;
}

- (void)notify:(NSInteger)status {
    @synchronized(self) {
        self.status = status;
    }
}

- (void)waitForTimeout:(NSTimeInterval)timeout {
    
    NSTimeInterval checkInterval = 0.05;
    NSDate *runUntilDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
    BOOL timedOut = NO;

    while(self.status == kAsyncTestSupporterWaitStatusUnknown) {
        
        if (![[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:checkInterval]]) {
            [NSThread sleepForTimeInterval:checkInterval];
        }
        
        if ([runUntilDate compare:[NSDate date]] == NSOrderedAscending) {
            timedOut = YES;
            break;
        }
    }

    if (timedOut) {
        @throw [self timeOutException];
    }

    if (self.status == kAsyncTestSupporterWaitStatusFailure) {
        @throw [self failureException];
    }

}

- (NSException *)timeOutException {
    return [NSException exceptionWithName:@"AsyncSupporterTimeOut" reason:@"Operation timed out" userInfo:nil];
}

- (NSException *)failureException {
    return [NSException exceptionWithName:@"AsyncSupporterFailure" reason:@"Notified failure" userInfo:nil];
}
@end
