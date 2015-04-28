//
//  ViewController.m
//  DatePickerTest
//
//  Created by Maxime Urban on 01/04/2015.
//  Copyright (c) 2015 Maxime Urban. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

#define IDIOM   UI_USER_INTERFACE_IDIOM()
#define IPAD    UIUserInterfaceIdiomPad
#define IPHONE  UIUserInterfaceIdiomPhone

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    datePicker = [[MUDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 216, self.view.frame.size.width , 216)];
    
    
    /**
     *  Picker Customisation
     */
    //http://www.colorpicker.com/
    datePicker.backgroundColor = [UIColor colorWithRed:227/255.f green:93/255.f blue:93/255.f alpha:0.5];
    datePicker.fontColor = [UIColor whiteColor];
    datePicker.dateFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];

    /*
    // DATE MODE
    //Uncomment to test
    
    datePicker.muPickerMode = DATE;
     
    datePicker.columnDayNameWidth = 100;
    datePicker.columnDayWidth = 100;
    datePicker.columnMonthWidth = 100;
    datePicker.columnYearWidth = 100;
    
     */
    //END DATE MODE
    
    //TIME MODE
    
    datePicker.muPickerMode = TIME;
    datePicker.columnHourWidth = 100;
    datePicker.columnMinuteWidth = 100;
    
    //Select the today date on the picker
    [datePicker showDateOnPicker:[NSDate new]];
    [self.view addSubview:datePicker];
    
}

-(void)dealloc {
    [datePicker release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotate {
    
    UIInterfaceOrientation newOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // Should change orientation to portrait
    if ( UIInterfaceOrientationIsPortrait( newOrientation ) && IDIOM == IPHONE)
    {
        //Here you can change the column width if you want to
        datePicker.columnDayNameWidth = 25;
        datePicker.columnDayWidth = 30;
        datePicker.columnMonthWidth = 100;
        datePicker.columnYearWidth = 40;
    } else {
        datePicker.columnDayNameWidth = 100;
        datePicker.columnDayWidth = 100;
        datePicker.columnMonthWidth = 100;
        datePicker.columnYearWidth = 100;
    }
    // Should change orientation to portrait
    datePicker.frame = CGRectMake(0, self.view.frame.size.height - 216, self.view.frame.size.width , 216);
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
