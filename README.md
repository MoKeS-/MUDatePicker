# MUDatePicker


<p align="center">
	<img src="Screenshot1.png" alt="Sample">
</p>

<p align="center">
	<img src="Screenshot2.png" alt="Sample">
</p>

A real customizable DatePicker for iOS that shows the Day name without the timestamp.

#### Podfile

...Soon

## Basic Usage

Import the class header.

``` objective-c
#import "MUDatePicker.h"
```

Just create your date picker in a frame.

``` objective-c
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	MUDatePicker *datePicker = [[MUDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 216, self.view.frame.size.width , 216)];

```

Then you can customize it : 

``` objective-c

	datePicker.backgroundColor = [UIColor colorWithRed:227/255.f green:93/255.f blue:93/255.f alpha:0.5];
    
    
    datePicker.columnDayNameWidth = 100;
    datePicker.columnDayWidth = 100;
    datePicker.columnMonthWidth = 100;
    datePicker.columnYearWidth = 100;
    
    datePicker.fontColor = [UIColor whiteColor];
    datePicker.dateFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];

```

and add it to your view 

``` objective-c

 //Select the today date on the picker
    [datePicker showDateOnPicker:[NSDate new]];
    [self.view addSubview:datePicker];

```

and ... that's it !

## Coming Soon

Use of the delegate

## Demo

Build and run the `DatePickerTest` project in Xcode to see `MUDatePicker` in action.
Have fun. Make it faster. Fork and send pull requests. Figure out hooks for customization.

## Contact

Maxime Urban

- https://github.com/MoKeS-
- https://twitter.com/MoKeS_
- maxime.urban@gmail.com

