//
//  IslamicViewController.m
//  UVDatePicker
//
//  Created by Ivan Parfenchuk on 01.11.12.
//  Copyright (c) 2012 Ivan Parfenchuk. All rights reserved.
//

#import "IslamicViewController.h"
#import "UVIslamicDatePickerView.h"

@interface IslamicViewController ()

@property (nonatomic, strong) NSDateFormatter * formatter;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UVIslamicDatePickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *hijriCorrectionLabel;

@end

@implementation IslamicViewController

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

- (IBAction)correctionSliderValueChanged:(UISlider*)sender
{
    int newCorrection = (int)sender.value;
    self.pickerView.hijriCorrection = newCorrection;
    self.hijriCorrectionLabel.text = [NSString stringWithFormat:@"Hijri Correction: %d", newCorrection];
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
