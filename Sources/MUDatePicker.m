//
//  MUDatePicker.h
//
//
// Copyright (c) 2015 Maxime Urban, https://github.com/MoKeS-
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
    [_dateComponents dealloc];
    
    [super dealloc];
}

/**
 *  Basic variable initialization.
 */
-(void) initialization {
    super.delegate = self;
    super.dataSource = self;
    _muPickerMode = DATE;
    _calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
}

/**
 *  Show current date on picker.
 *
 *  @param date the date to show
 */
-(void)showDateOnPicker:(NSDate *)date
{
 
    _dateComponents = [[self.calendar
                                    components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour | NSCalendarUnitMinute
                                    fromDate:date]retain];
    
    if(_muPickerMode == TIME) {
        [self selectRow:[_dateComponents hour] inComponent:0 animated:YES];
        [self selectRow:[_dateComponents minute] inComponent:1 animated:YES];
    } else {
        [self selectRow:[_dateComponents day]-1 inComponent:1 animated:YES];
        [self selectRow:[_dateComponents month]-1 inComponent:2 animated:YES];
        [self selectRow:[_dateComponents year]-1 inComponent:3 animated:YES];
        [self calcLastDayOfMonth:date];
        [self calcDayName:date];
    }
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
    
    if(_muPickerMode == TIME ) {
        _dateComponents.hour = [self selectedRowInComponent:0];
        _dateComponents.minute = [self selectedRowInComponent:1];
    } else {
        _dateComponents.month =[self selectedRowInComponent:2] + 1 ;
        _dateComponents.year = [self selectedRowInComponent:3] + 1;
        _dateComponents.day = [self selectedRowInComponent:1] + 1;
    }

    return [_calendar dateFromComponents:_dateComponents];
}

#pragma mark Delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if(_muPickerMode == TIME) {
        return 2;
    } else {
        return 4;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger ret;
    
    if(_muPickerMode == TIME) {
        switch (component) {
            case 0 :
                ret = 24;
                break;
            default :
                ret = 60;
                break;
        }
    } else {
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
    }
    return ret;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if(_muPickerMode == TIME) {
        switch (component) {
            case 0:
                return self.columnHourWidth;
                break;
            case 1:
                return self.columnMinuteWidth;
                break;
            default:
                return 100;
                break;
        }
    } else {
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
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (_muPickerMode == DATE) {
        
        NSDateComponents *dateComponent = [[NSDateComponents alloc] init];
        dateComponent.month =[self selectedRowInComponent:2] + 1 ;
        dateComponent.year = [self selectedRowInComponent:3] + 1;
        [self calcLastDayOfMonth:[_calendar dateFromComponents:dateComponent]];
        [dateComponent release];
        
        _dateComponents.month =[self selectedRowInComponent:2] + 1 ;
        _dateComponents.year = [self selectedRowInComponent:3] + 1;
        _dateComponents.day = [self selectedRowInComponent:1] + 1;

        if(_dateComponents.day > lastDay) {
            [self selectRow:lastDay-1 inComponent:1 animated:YES];
            _dateComponents.day = lastDay-1;
        }
        
        [self calcDayName:[_calendar dateFromComponents:_dateComponents]];
    }
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
    
    if(_muPickerMode == TIME) {
        
        NSString *time = [NSString stringWithFormat:@"%ld",(long)row];
        if(row <10) {
            time = [NSString stringWithFormat:@"0%ld",(long)row];
        }
        labelDate.text = time;
        labelDate.textAlignment = NSTextAlignmentCenter;
    } else {
        switch (component) {
            case 0:
                labelDate.text = dayName;
                labelDate.textAlignment = NSTextAlignmentLeft;
                break;
            case 1:
                labelDate.text = [NSString stringWithFormat:@"%ld", (long)(row+1)];
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
                labelDate.text = [NSString stringWithFormat:@"%ld", (long)(row + 1) ];
                break;
            default:
                break;
        }
    }
    
    [labelDate sizeToFit];
    return labelDate;
}

@end
