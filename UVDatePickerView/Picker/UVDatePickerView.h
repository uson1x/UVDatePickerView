//
//  CustomDatePickerView.h
//  UVDatePicker
//
//  Created by Ivan Parfenchuk on 01.11.12.
//  Copyright (c) 2012 Ivan Parfenchuk. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRMMagicPickerNumber 16384

@class UVDatePickerView;

@protocol UVDatePickerViewDelegate <NSObject>
@optional
- (void)pickerViewChangedDate:(UVDatePickerView *)pickerView;
- (NSDate*)getDateForResetting;
@end

@interface UVDatePickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
{
	@protected
	__strong NSCalendar * _pickerCalendar;
    BOOL _hasAMPMSymbols;

}

@property (nonatomic, assign) IBOutlet id<UVDatePickerViewDelegate> delegate;
@property (nonatomic, strong, getter = getPickerDate, setter = setDate:) NSDate * date;

@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) NSDateFormatter   * dateFormatter;
@property (nonatomic, strong) NSDateFormatter   * fullDateTimeFormatter;
@property (nonatomic, strong) NSDate			* referenceDate;
@property (nonatomic, strong) NSDateComponents  * referenceDateComponents;
@property (nonatomic, strong) NSDateComponents  * dateComponents;
@property (nonatomic, strong) NSNumberFormatter * numberFormatter;

- (NSString*)pmSymbol;
- (NSString*)amSymbol;

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

- (void)setupViewWithFrame:(CGRect)frame;
- (void)pickerViewLoaded:(UIPickerView*)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView realNumberOfRowsInComponent:(NSInteger)component;
- (void)setMinutes:(NSUInteger)minutes;
- (void)setHours:(NSUInteger)hours;
- (void)setDayFromReferenceDay:(NSUInteger)day;
- (void)setDayFromReferenceDay:(NSUInteger)day animated:(BOOL)animated;
- (void)setupDateTimeFormatters;
- (void)setupCalendar;
- (NSString*)localizedNumber:(int)n;

@end