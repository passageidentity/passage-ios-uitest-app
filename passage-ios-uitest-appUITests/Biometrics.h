//
//  Biometrics.h
//  example-iosUITests
//
//  Created by Ricky Padilla on 10/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Biometrics : NSObject

+ (void)enrolled;
+ (void)unenrolled;
+ (void)successfulAuthentication;
+ (void)unsuccessfulAuthentication;

@end

NS_ASSUME_NONNULL_END
