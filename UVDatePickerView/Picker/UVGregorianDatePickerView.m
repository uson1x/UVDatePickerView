//
//  CustomGregorianDatePickerView.m
//  UVDatePicker
//
//  Created by Ivan Parfenchuk on 01.11.12.
//  Copyright (c) 2012 Ivan Parfenchuk. All rights reserved.
//

#import "UVGregorianDatePickerView.h"
#import "NSDate+CurrentDateWithoutSeconds.h"

@interface UVGregorianDatePickerView()

@end

@implementation UVGregorianDatePickerView

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
	[self.dateFormatter setDateFormat:@"EEE d MMM"];
	
	self.numberFormatter = [[NSNumberFormatter alloc] init];
	self.numberFormatter.minimumIntegerDigits = 2;
	
    self.dateFormatter.locale = locale;
	self.numberFormatter.locale = locale;
}

- (void)setupCalendar
{
    _pickerCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
}

#pragma mark - UIPickerViewDataSource methods

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if(component == 0)
		return _hasAMPMSymbols ? 159.0f : 211.0f;
	else
		return 45.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 42.0f;
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
			NSDate * date = [_pickerCalendar dateByAddingComponents:components toDate:self.referenceDate options:0];
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

@end
