//
//  MUDatePicker.h
//  DatePickerTest
//
//  Created by Maxime Urban on 01/04/2015.
//  Copyright (c) 2015 Maxime Urban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUDatePicker : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>
{
    //String containing the current day name
    NSString *dayName;
    
    //Number of the last day for the current month
    NSInteger lastDay;
}

// Calendar used in the PickerView
@property (nonatomic, copy) NSCalendar *calendar;


// Picker customization
@property(nonatomic, retain) UIColor *fontColor;
@property(nonatomic, retain) UIFont *dateFont;

@property(nonatomic, assign) NSInteger columnDayNameWidth;
@property(nonatomic, assign) NSInteger columnDayWidth;
@property(nonatomic, assign) NSInteger columnMonthWidth;
@property(nonatomic, assign) NSInteger columnYearWidth;



-(void)showDateOnPicker:(NSDate *)date;
-(NSDate *)getSelectedDate;


@end
