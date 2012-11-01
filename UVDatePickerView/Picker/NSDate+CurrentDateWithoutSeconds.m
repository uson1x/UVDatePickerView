//
//  NSDate+CurrentDateWithoutSeconds.m
//  UVDatePicker
//
//  Created by Ivan Parfenchuk on 01.11.12.
//  Copyright (c) 2012 Ivan Parfenchuk. All rights reserved.
//

#import "NSDate+CurrentDateWithoutSeconds.h"

@implementation NSDate (CurrentDateWithoutSeconds)

+ (NSDate*)dateCurrentWithoutSeconds
{
	NSCalendar * calendar = [NSCalendar currentCalendar];
	NSDateComponents * dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
													fromDate:[NSDate date]];
	return [calendar dateFromComponents:dateComponents];
}

+ (NSDate*)dateCurrentWithoutHoursMinutesAndSeconds
{
	return [[NSDate date] dateWithoutHoursMinutesAndSeconds];
}

- (NSDate*)dateWithoutHoursMinutesAndSeconds
{
	NSCalendar * calendar = [NSCalendar currentCalendar];
	NSDateComponents * dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
													fromDate:self];
	return [calendar dateFromComponents:dateComponents];
}

@end
