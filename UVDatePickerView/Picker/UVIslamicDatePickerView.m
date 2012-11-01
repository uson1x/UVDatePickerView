//
//  CustomIslamicDatePickerView.m
//  UVDatePicker
//
//  Created by Ivan Parfenchuk on 01.11.12.
//  Copyright (c) 2012 Ivan Parfenchuk. All rights reserved.
//

#import "UVIslamicDatePickerView.h"
#import "NSDate+CurrentDateWithoutSeconds.h"

@interface UVIslamicDatePickerView()

@end

@implementation UVIslamicDatePickerView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{

    }
	return self;
}

- (void)dealloc
{

}

- (void)setupDateTimeFormatters
{
	self.dateFormatter = [[NSDateFormatter alloc] init];
	self.dateFormatter.timeZone = [[NSCalendar currentCalendar] timeZone];
	self.dateFormatter.calendar = _pickerCalendar;
	[self.dateFormatter setDateStyle:NSDateFormatterNoStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	if([[self.dateFormatter dateFormat] rangeOfString:@"a"].location != NSNotFound) {
		// user prefers 12 hour clock
		_hasAMPMSymbols = YES;
		[self.dateFormatter setDateFormat:@"hh:mm a"];
	} else {
		// user prefers 24 hour clock
		_hasAMPMSymbols = NO;
		[self.dateFormatter setDateFormat:@"HH:mm"];
	}
    
    NSLocale * locale = [NSLocale currentLocale];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[self.dateFormatter setDateFormat:@"d MMMM"];
    
	self.numberFormatter = [[NSNumberFormatter alloc] init];
	self.numberFormatter.minimumIntegerDigits = 2;
	
	self.dateFormatter.locale = locale;
	self.numberFormatter.locale = locale;
}

- (void)setupCalendar
{
    _pickerCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSIslamicCivilCalendar];
}

#pragma mark - UIPickerViewDataSource methods

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if(component == 0)
		return _hasAMPMSymbols ? 144.0f : 198.0f;
	else
		return 50.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 50.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if(component == 0)
	{
		if (row == kRMMagicPickerNumber / 2)
		{
			return @"Today";
		}
		else
		{
			NSDateComponents * components = [[NSDateComponents alloc] init];
			components.day = row;
			NSDate * date = [self correctedDate:[_pickerCalendar dateByAddingComponents:components toDate:self.referenceDate options:0]];
			return [self.dateFormatter stringFromDate:date];
		}
	}
	else if (component == 1 || component == 2)
	{
		return [self localizedNumber:row % [self pickerView:pickerView realNumberOfRowsInComponent:component]];
	}
	else if (component == 3)
	{
		return !_hasAMPMSymbols ? @"" : (row == 0 ? [self amSymbol] : [self pmSymbol]);
	}
	
	return @"";
}

- (NSDate*)correctedDate:(NSDate*)sourceDate
{
	if (self.hijriCorrection != 0)
	{
		NSDateComponents * components = [[NSDateComponents alloc] init];
		components.day = self.hijriCorrection;
		NSCalendar * c = [[NSCalendar alloc] initWithCalendarIdentifier:NSIslamicCivilCalendar];
		return [c dateByAddingComponents:components toDate:sourceDate options:0];
	}
	else
		return sourceDate;
}

- (void)setHijriCorrection:(NSInteger)hijriCorrection
{
    if (hijriCorrection != _hijriCorrection) {
        _hijriCorrection = hijriCorrection;
        [self.pickerView reloadAllComponents];
    }
}

@end
