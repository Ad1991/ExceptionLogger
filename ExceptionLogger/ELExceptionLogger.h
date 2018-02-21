//
//  ELExceptionLogger.h
//  ExceptionLogger
//
//  Created by Adarsh Kumar Rai on 21/02/18.
//  Copyright © 2018 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELExceptionLogger : NSObject

+ (NSString *)lastExceptionDetails;
+ (void)installExceptionLogger;

@end
