//
//  NSDate+Date___Extensions.h
//  SocketDemo
//
//  Created by Aynur Galiev on 15.января.2017.
//  Copyright © 2017 Aynur Galiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extensions)

- (nonnull NSString *) ISO8601String;
+ (nullable NSDate *) dateFromISO8601String:(nonnull NSString *)string;

@end
