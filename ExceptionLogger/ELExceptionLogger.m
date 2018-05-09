// The MIT License (MIT)
//
// Copyright (c) 2018 Adarsh Rai <adrai75@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


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
