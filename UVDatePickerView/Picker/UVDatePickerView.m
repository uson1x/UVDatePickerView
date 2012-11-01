//
//  CustomDatePickerView.m
//  UVDatePicker
//
//  Created by Ivan Parfenchuk on 01.11.12.
//  Copyright (c) 2012 Ivan Parfenchuk. All rights reserved.
//

#import "UVDatePickerView.h"
#import "NSDate+CurrentDateWithoutSeconds.h"

@interface UVDatePickerView()

@end

@implementation UVDatePickerView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setupViewWithFrame:self.frame];
    }
    return self;
}

- (void)awakeFromNib
{
	[self setupViewWithFrame:self.frame];
}

- (void)setupViewWithFrame:(CGRect)frame
{
	self.pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	[self addSubview:self.pickerView];
	
	UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
	recognizer.numberOfTapsRequired = 2;
	[self.pickerView addGestureRecognizer:recognizer];

    [self setupCalendar];
    [self setupDateTimeFormatters];
    
    NSDate * now = [NSDate dateCurrentWithoutHoursMinutesAndSeconds];
    NSDateComponents * decreasingComponents = [[NSDateComponents alloc] init];
    decreasingComponents.day = - kRMMagicPickerNumber / 2;
    self.referenceDate = [_pickerCalendar dateByAddingComponents:decreasingComponents toDate:now options:0];
    self.referenceDateComponents = [_pickerCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                      fromDate:self.referenceDate];
    self.dateComponents = [_pickerCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:now];
    
    [self pickerViewLoaded:self.pickerView];
    [self setHours:self.dateComponents.hour];
    [self setMinutes:self.dateComponents.minute];
    [self setDayFromReferenceDay:kRMMagicPickerNumber / 2];
}

- (void)setupDateTimeFormatters
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)setupCalendar
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSString*)localizedNumber:(int)n
{
	return [self.numberFormatter stringFromNumber:[NSNumber numberWithInt:n]];
}

- (void)doubleTap:(UIGestureRecognizer*)recognizer
{
	NSDate * resettingDate = [self.delegate getDateForResetting];
	if(resettingDate)
		[self setDate:resettingDate animated:YES];
}

- (NSDate*)getPickerDate
{
	NSDateComponents * components = [[NSDateComponents alloc] init];
	components.day = [self.pickerView selectedRowInComponent:0];
	components.hour = [self.pickerView selectedRowInComponent:1] % [self pickerView:self.pickerView realNumberOfRowsInComponent:1];
	if (_hasAMPMSymbols) {
		if([self.pickerView selectedRowInComponent:3] % [self pickerView:self.pickerView realNumberOfRowsInComponent:3] == 1)
			components.hour += 12;
	}
	components.minute = [self.pickerView selectedRowInComponent:2] % [self pickerView:self.pickerView realNumberOfRowsInComponent:2];
	NSDate * date = [_pickerCalendar dateByAddingComponents:components toDate:self.referenceDate options:0];
	return date;
}

- (void)setDate:(NSDate*)date
{
	[self setDate:date animated:NO];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
	self.dateComponents = [_pickerCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
	[self setHours:self.dateComponents.hour];
	[self setMinutes:self.dateComponents.minute];
	NSDateComponents * dayAddition = [_pickerCalendar components:NSDayCalendarUnit fromDate:self.referenceDate toDate:date options:0];
	[self setDayFromReferenceDay:dayAddition.day animated:animated];
}

#pragma mark - UIPickerViewDataSource methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return _hasAMPMSymbols ? 4 : 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	//	[_pickerCalendar]
	switch (component) {
		case 0:
			//Day
			return kRMMagicPickerNumber;
			break;
		case 1:
			//Hour
			return kRMMagicPickerNumber;//_hasAMPMSymbols ? 12 : 24;
			break;
		case 2:
			//Minute
			return kRMMagicPickerNumber; //60;
			break;
		case 3:
			//PM/AM
			return _hasAMPMSymbols ? 2 : 0;
			break;
		default:
			return 0;
			break;
	}
}
- (NSInteger)pickerView:(UIPickerView *)pickerView realNumberOfRowsInComponent:(NSInteger)component
{
	switch (component) {
		case 0:
			//Day
			return kRMMagicPickerNumber;
			break;
		case 1:
			//Hour
			return _hasAMPMSymbols ? 12 : 24;
            //			return 24;
			break;
		case 2:
			//Minute
			return 60;
			break;
		case 3:
			//PM/AM
			return _hasAMPMSymbols ? 2 : 0;
			break;
		default:
			return 0;
			break;
	}
}

#pragma mark - UIPickerViewDelegate methods

// returns width of column and height of row for each component. 
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 50.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *retval = (id)view;
	if (!retval) {
		retval= [[UILabel alloc] initWithFrame:CGRectMake(3.0f, 0.0f, [pickerView rowSizeForComponent:component].width-6, [pickerView rowSizeForComponent:component].height)];
		retval.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
		retval.minimumScaleFactor = 0.5f;
		retval.adjustsFontSizeToFitWidth = YES;
		retval.textAlignment = component ? NSTextAlignmentCenter : NSTextAlignmentLeft;
	}
	retval.text = [self pickerView:pickerView titleForRow:row forComponent:component];;
	return retval;
}

- (void)setDayFromReferenceDay:(NSUInteger)day
{
	[self setDayFromReferenceDay:day animated:NO];
}

- (void)setDayFromReferenceDay:(NSUInteger)day animated:(BOOL)animated
{
	[self.pickerView selectRow:day inComponent:0 animated:animated];
}

- (void)setMinutes:(NSUInteger)minutes
{
	NSUInteger max = kRMMagicPickerNumber;
	NSInteger realCount = [self pickerView:self.pickerView realNumberOfRowsInComponent:2];
	NSUInteger base = (max / 2) - (max / 2 ) % realCount;
	[self.pickerView selectRow:minutes%realCount + base inComponent:2 animated:NO];
}

- (void)setHours:(NSUInteger)hours
{
	NSUInteger max = kRMMagicPickerNumber;
	NSInteger realCount = [self pickerView:self.pickerView realNumberOfRowsInComponent:1];
	NSUInteger base = (max / 2) - (max / 2 ) % realCount;
	[self.pickerView selectRow:hours%realCount + base inComponent:1 animated:NO];
	if(hours >= 12 && _hasAMPMSymbols)
	{
		[self.pickerView selectRow:1 inComponent:3 animated:NO];
	}
}

- (void)pickerViewLoaded:(UIPickerView*)pickerView
{
	NSUInteger max = kRMMagicPickerNumber;
	for (int component = 1; component < 3; component++) {
		NSInteger realCount = [self pickerView:pickerView realNumberOfRowsInComponent:component];
		NSUInteger base = (max / 2) - (max / 2 ) % realCount;
		[pickerView selectRow:[pickerView selectedRowInComponent:component]%realCount + base inComponent:component animated:NO];
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	[self pickerViewLoaded:pickerView];
	if(self.delegate && [self.delegate respondsToSelector:@selector(pickerViewChangedDate:)])
    {
        [self.delegate pickerViewChangedDate:self];
    }
}

- (NSString*)pmSymbol
{
	return @"PM";
}

- (NSString*)amSymbol
{
	return @"AM";
}

@end