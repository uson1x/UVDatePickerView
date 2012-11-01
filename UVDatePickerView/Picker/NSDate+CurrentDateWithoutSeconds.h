//
//  NSDate+CurrentDateWithoutSeconds.h
//  UVDatePicker
//
//  Created by Ivan Parfenchuk on 01.11.12.
//  Copyright (c) 2012 Ivan Parfenchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CurrentDateWithoutSeconds)

+ (NSDate*)dateCurrentWithoutSeconds;
+ (NSDate*)dateCurrentWithoutHoursMinutesAndSeconds;

- (NSDate*)dateWithoutHoursMinutesAndSeconds;

@end
