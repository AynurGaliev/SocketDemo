//
//  NSDate+Date___Extensions.m
//  SocketDemo
//
//  Created by Aynur Galiev on 15.января.2017.
//  Copyright © 2017 Aynur Galiev. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

+ (nullable NSDate *)dateFromISO8601String:(nonnull NSString *)string {
    if (!string) {
        return nil;
    }
    
    struct tm tm;
    time_t t;
    
    strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%dT%H:%M:%S%z", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    
    return [NSDate dateWithTimeIntervalSince1970:t + [[NSTimeZone localTimeZone] secondsFromGMT]];
}


- (nonnull NSString *) ISO8601String {
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = [self timeIntervalSince1970] - [[NSTimeZone localTimeZone] secondsFromGMT];
    timeinfo = localtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%dT%H:%M:%S%z", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

@end
