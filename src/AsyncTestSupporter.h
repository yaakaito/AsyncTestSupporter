//
//  AsyncTestSupporter.h
//
//  Created by yaakaito on 12/09/09.
//
//

#import <Foundation/Foundation.h>

enum {
    kAsyncTestSupporterWaitStatusUnknown,
    kAsyncTestSupporterWaitStatusSuccess,
    kAsyncTestSupporterWaitStatusFailure
};

@interface AsyncTestSupporter : NSObject

- (void)prepare;
- (void)notify:(NSInteger)status;
- (void)waitForTimeout:(NSTimeInterval)timeout;
@end
