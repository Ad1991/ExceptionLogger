//
//  ELExceptionLogger.m
//  ExceptionLogger
//
//  Created by Adarsh Kumar Rai on 21/02/18.
//  Copyright © 2018 Personal. All rights reserved.
//

#import "ELExceptionLogger.h"
#import "GTMStackTrace.h"
#include <libkern/OSAtomic.h>
#include <signal.h>
#include <unistd.h>

NSString * const UncaughtExceptionHandlerSignalExceptionKey = @"UncaughtExceptionHandlerSignalExceptionKey";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 1;

@implementation ELExceptionLogger

void HandleException(NSException *exception) {
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    NSString *stackTrace = GTMStackTraceFromException(exception);
    NSString *exceptionReason = exception.reason;
    NSString *dateString = [ELExceptionLogger dateStringForCurrentDate];
    [ELExceptionLogger storeExceptionDetails:[NSString stringWithFormat:@"Date: %@\n\nReason: %@\n\n Stacktrace: %@", dateString, exceptionReason, stackTrace]];
}


static void SignalHandler(int signal) {
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    NSString *exceptionReason = [NSString stringWithFormat:@"Signal Received: %@", [ELExceptionLogger signalNameForSignal:signal]];
    NSString *stackTrace = GTMStackTrace();
    NSString *dateString = [ELExceptionLogger dateStringForCurrentDate];
    [ELExceptionLogger storeExceptionDetails:[NSString stringWithFormat:@"Date: %@\n\nReason: %@\n\n Stacktrace: %@", dateString, exceptionReason, stackTrace]];
}


+ (void)storeExceptionDetails:(NSString *)exceptionDetails {
    [[NSUserDefaults standardUserDefaults] setObject:exceptionDetails forKey:UncaughtExceptionHandlerSignalExceptionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *)dateStringForCurrentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-yyyy hh:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"IST"];
    return [dateFormatter stringFromDate:[NSDate date]];
}


+ (NSString *)signalNameForSignal:(int)signal {
    switch (signal) {
        case SIGABRT:
            return @"SIGABRT";
        case SIGILL:
            return @"SIGILL";
        case SIGSEGV:
            return @"SIGSEGV";
        case SIGFPE:
            return @"SIGFPE";
        case SIGBUS:
            return @"SIGBUS";
        case SIGPIPE:
            return @"SIGPIPE";
        default:
            return @"Unknown Signal";
    }
}


#pragma mark - Public Methods -

+ (NSString *)lastExceptionDetails {
    return [[NSUserDefaults standardUserDefaults] stringForKey:UncaughtExceptionHandlerSignalExceptionKey];
}


+ (void)installExceptionLogger {
    if (NSGetUncaughtExceptionHandler() == nil) {
        NSSetUncaughtExceptionHandler(&HandleException);
        
        struct sigaction mySigAction;
        memset(&mySigAction, 0, sizeof(mySigAction));
        sigemptyset(&mySigAction.sa_mask);
        mySigAction.sa_flags = 0;
        mySigAction.sa_handler = SignalHandler;
        
        sigaction(SIGHUP, &mySigAction, NULL);
        sigaction(SIGINT, &mySigAction, NULL);
        sigaction(SIGQUIT, &mySigAction, NULL);
        sigaction(SIGILL, &mySigAction, NULL);
        sigaction(SIGTRAP, &mySigAction, NULL);
        sigaction(SIGABRT, &mySigAction, NULL);
        sigaction(SIGEMT, &mySigAction, NULL);
        sigaction(SIGFPE, &mySigAction, NULL);
        sigaction(SIGBUS, &mySigAction, NULL);
        sigaction(SIGSEGV, &mySigAction, NULL);
        sigaction(SIGSYS, &mySigAction, NULL);
        sigaction(SIGPIPE, &mySigAction, NULL);
        sigaction(SIGALRM, &mySigAction, NULL);
        sigaction(SIGXCPU, &mySigAction, NULL);
        sigaction(SIGXFSZ, &mySigAction, NULL);
    }
}
@end
