//
//  UVViewController.m
//  UVDatePicker
//
//  Created by Ivan Parfenchuk on 01.11.12.
//  Copyright (c) 2012 Ivan Parfenchuk. All rights reserved.
//

#import "GregorianViewController.h"
#import "UVGregorianDatePickerView.h"

@interface GregorianViewController ()

@property (nonatomic, strong) NSDateFormatter * formatter;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UVGregorianDatePickerView *pickerView;

@end

@implementation GregorianViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateStyle = NSDateFormatterLongStyle;
    
    self.dateLabel.text = [self.formatter stringFromDate:self.pickerView.date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UVDatePickerViewDelegate methods

- (void)pickerViewChangedDate:(UVDatePickerView *)pickerView
{
    self.dateLabel.text = [self.formatter stringFromDate:pickerView.date];
}

- (NSDate*)getDateForResetting
{
    return [NSDate date];
}

@end
