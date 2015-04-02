//
//  MUDatePicker.m
//  DatePickerTest
//
//  Created by Maxime Urban on 01/04/2015.
//  Copyright (c) 2015 Maxime Urban. All rights reserved.
//

#import "MUDatePicker.h"

#define IDIOM   UI_USER_INTERFACE_IDIOM()
#define IPAD    UIUserInterfaceIdiomPad
#define IPHONE  UIUserInterfaceIdiomPhone

@implementation MUDatePicker

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    [self initialization];
    return self;
}

-(void)dealloc {
    
    [dayName dealloc];
    [_calendar dealloc];
    
    [super dealloc];
}

/**
 *  Basic variable initialization.
 */
-(void) initialization {
    super.delegate = self;
    super.dataSource = self;
    _calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
}

/**
 *  Show current date on picker.
 *
 *  @param date the date to show
 */
-(void)showDateOnPicker:(NSDate *)date
{
    NSDateComponents *components = [self.calendar
                                    components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                    fromDate:date];
    

    [self selectRow:[components day]-1 inComponent:1 animated:YES];
    [self selectRow:[components month]-1 inComponent:2 animated:YES];
    [self selectRow:[components year]-1 inComponent:3 animated:YES];
    [self calcLastDayOfMonth:date];
    [self calcDayName:date];
}

/**
 *  Function used to define what is the day name for a given date.
 *
 *  @param date The date to test
 */
- (void) calcDayName:(NSDate *) date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(IDIOM == IPAD) {
        [dateFormatter setDateFormat:@"EEEE"];
    } else {
        [dateFormatter setDateFormat:@"EEE"];
    }
    dayName = [[dateFormatter stringFromDate:date]retain];
    [dateFormatter release];
    
    [self reloadAllComponents];
}

/**
 *  Get the last day of a month with a given date.
 *
 *  @param date the date to test
 */
-(void)calcLastDayOfMonth:(NSDate *)date {
  
    NSRange currentRange = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    lastDay =  currentRange.length;
}

/**
 *  Get the selected date.
 *
 *  @return the date on the picker
 */
-(NSDate *)getSelectedDate {
    NSDateComponents *dateComponent = [[NSDateComponents alloc] init];
    dateComponent.month =[self selectedRowInComponent:2] + 1 ;
    dateComponent.year = [self selectedRowInComponent:3] + 1;
    dateComponent.day = [self selectedRowInComponent:1] + 1;
    
    return [_calendar dateFromComponents:dateComponent];
}

#pragma mark Delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger ret;
    
    switch (component) {
        case 0 :
            ret = 1;
            break;
        case 1 :
            ret = 31;
            break;
        case 2 :
            ret = 12;
            break;
        default :
            ret = 10000;
            break;
    }
    return ret;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return self.columnDayNameWidth;
            break;
        case 1:
            return self.columnDayWidth;
            break;
        case 2:
            return self.columnMonthWidth;
            break;
        case 3:
            return self.columnYearWidth;
            break;
        default:
            return 100;
            break;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSDateComponents *dateComponent = [[NSDateComponents alloc] init];
    dateComponent.month =[self selectedRowInComponent:2] + 1 ;
    dateComponent.year = [self selectedRowInComponent:3] + 1;
    [self calcLastDayOfMonth:[_calendar dateFromComponents:dateComponent]];
    
    dateComponent.day = [self selectedRowInComponent:1] + 1;

    if(dateComponent.day > lastDay) {
        [self selectRow:lastDay-1 inComponent:1 animated:YES];
        dateComponent.day = lastDay-1;
    }
    
    [self calcDayName:[_calendar dateFromComponents:dateComponent]];
    [dateComponent release];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelDate = (UILabel *)view;
    if (labelDate == nil) {
        
        labelDate = [[[UILabel alloc] init]autorelease];
        labelDate.font = self.dateFont;
        labelDate.textColor = self.fontColor;
        [labelDate setBackgroundColor:[UIColor clearColor]];
        labelDate.textAlignment = NSTextAlignmentRight;
        
    }
    labelDate.enabled = YES;
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    
    switch (component) {
        case 0:
            labelDate.text = dayName;
            labelDate.textAlignment = NSTextAlignmentLeft;
            break;
        case 1:
            labelDate.text = [NSString stringWithFormat:@"%d", row + 1];
            if((row+1) > lastDay) {
                labelDate.enabled = NO;
            }
            break;
        case 2 :
            if(IDIOM == IPAD) {
                labelDate.text = [[df monthSymbols] objectAtIndex:row];
            } else {
                labelDate.text = [[df shortMonthSymbols] objectAtIndex:row];
            }
            break;
        case 3 :
            labelDate.text = [NSString stringWithFormat:@"%d", row + 1 ];
            break;
        default:
            break;
    }
    
    [labelDate sizeToFit];
    return labelDate;
}

@end
