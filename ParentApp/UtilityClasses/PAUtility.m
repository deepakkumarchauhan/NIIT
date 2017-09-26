//
//  MTUtility.m
//  ParentApp
//
//  Created by Prince Kadian on 18/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PAUtility.h"
#import "AlertView.h"

@implementation PAUtility

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Rounded UILabel,UIImageView and UIButton <<<<<<<<<<<<<<<<<<<<<<<<*/

void getRoundedImageView (UIImageView *imageView) {
    imageView.layer.cornerRadius =  imageView.frame.size.width /2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 1.0;
    imageView.layer.borderColor = ([UIColor lightGrayColor]).CGColor;
    imageView.clipsToBounds = YES;
}

void getRoundedButton (UIButton *button) {
    button.layer.cornerRadius =  button.frame.size.width /2;
    button.layer.masksToBounds = YES;
    button.clipsToBounds = YES;
}

void getRoundedLabel (UILabel *label) {
    label.layer.cornerRadius =  label.frame.size.width /2;
    label.layer.masksToBounds = YES;
    label.clipsToBounds = YES;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Corner UILabel,UIVIew <<<<<<<<<<<<<<<<<<<<<<<<*/

void getCornerView (UIView *view,float cornerValue) {

    view.layer.cornerRadius =  cornerValue;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
}

void getCornerLabel (UILabel *label,float cornerValue) {
    label.layer.cornerRadius =  cornerValue;
    label.layer.masksToBounds = YES;
    label.clipsToBounds = YES;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Back button on navigation bar <<<<<<<<<<<<<<<<<<<<<<<<*/

UIBarButtonItem* leftBarButtonForController(id controller, NSString *imgStr) {
    
    UIImage *buttonImage = [UIImage imageNamed:imgStr];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 22.0f, 30.0f);
    
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    [backButton setImage:buttonImage forState:UIControlStateSelected];
    [backButton setImage:buttonImage forState:UIControlStateHighlighted];
    
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [backButton addTarget:controller action:@selector(leftBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    return backBarButtonItem;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Right bar button on navigation bar <<<<<<<<<<<<<<<<<<<<<<<<*/

UIBarButtonItem* rightBarButtonForController(id controller, NSString *imgStr ) {
    UIImage *buttonImage = [UIImage imageNamed:imgStr];
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 27.0f, 30.0f);
    [barButton setImage:buttonImage forState:UIControlStateNormal];
    [barButton setImage:buttonImage forState:UIControlStateSelected];
    [barButton setImage:buttonImage forState:UIControlStateHighlighted];
    
    if ([imgStr isEqualToString:@"bell"]) {
        UILabel *notificationCount = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 20, 10)];
        [notificationCount setBackgroundColor:[UIColor clearColor]];
        [notificationCount setText:@"100"];
        [notificationCount setFont:AppFont(10)];
        [notificationCount setTextAlignment:NSTextAlignmentCenter];
        [notificationCount setTextColor:[UIColor redColor]];
        
        [barButton addSubview:notificationCount];
    }
    
    [barButton addTarget:controller action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    
    return barButtonItem;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Button Action on navigation bar <<<<<<<<<<<<<<<<<<<<<<<<*/

- (void)leftBarButtonAction:(id)sender {
    
}

- (void)rightBarButtonAction:(id)sender {
    
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> //Month Number <<<<<<<<<<<<<<<<<<<<<<<<*/


+(NSInteger)getMonthNumber:(NSDate *)date andMonthChnage:(NSInteger)monthChangeNumber{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    comps.month = monthChangeNumber;
    NSDate *modifiedDate = [calendar dateByAddingComponents:comps toDate:date options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:modifiedDate]; // Get necessary date components
    
    return (long)[components month];
}

+(NSInteger)getYearNumber:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    comps.month = 0;
    NSDate *modifiedDate = [calendar dateByAddingComponents:comps toDate:date options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:modifiedDate]; // Get necessary date components
    
    return (long)[components year];
}


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Time and Date <<<<<<<<<<<<<<<<<<<<<<<<*/

+(NSString *)getTimeFromTimeStamp:(NSTimeInterval)interval {
    NSDate *methodStart = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    return  [dateFormatter stringFromDate:methodStart];
}

+ (NSString *) getDateFromTimeStamp:(NSTimeInterval)dateTimeStamp {
    NSDate *selectedDate = [NSDate dateWithTimeIntervalSince1970:dateTimeStamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    return [dateFormatter stringFromDate: selectedDate];
}

+(NSDate *)convertJSONDateIntoNSDate:(NSString *)JSONDateString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    return  [dateFormat dateFromString:JSONDateString];
}

+ (NSString *)getStringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    
    return [dateFormatter stringFromDate: date];
}

+ (NSString *)getTimeStringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm a"];
    
    return [dateFormatter stringFromDate: date];
}


+(NSString *)getYearFromDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    return  [formatter stringFromDate:date];
}


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Tool Bar <<<<<<<<<<<<<<<<<<<<<<<<*/

UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext){
    //NSString *doneOrNext;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WINWIDTH, 50)];
    
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:titleDoneOrNext style:UIBarButtonItemStyleDone target:controller action:@selector(doneWithNumberPad)],
                           
                           nil];
    [numberToolbar sizeToFit];
    return numberToolbar;
}

- (void)doneWithNumberPad {
    
}

@end
