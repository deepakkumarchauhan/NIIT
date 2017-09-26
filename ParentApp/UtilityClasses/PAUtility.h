//
//  MTUtility.h
//  ParentApp
//
//  Created by Prince Kadian on 18/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Header.h"

@interface PAUtility : NSObject

//Time and Date
+(NSString *)getTimeFromTimeStamp:(NSTimeInterval)interval;
+ (NSString *)getDateFromTimeStamp:(NSTimeInterval)dateTimeStamp;
+(NSDate *)convertJSONDateIntoNSDate:(NSString *)JSONDateString;
+ (NSString *)getStringFromDate:(NSDate *)date;
+(NSString *)getYearFromDate:(NSDate *)date;
+ (NSString *)getTimeStringFromDate:(NSDate *)date;
+(NSInteger)getYearNumber:(NSDate *)date;

//Rounded UILabel,UIImageView and UIButton
void getRoundedImageView (UIImageView *imageView);
void getRoundedButton (UIButton *button);
void getRoundedLabel (UILabel *label);

//Corner UILabel,UIVIew
void getCornerView (UIView *view,float cornerValue);
void getCornerLabel (UILabel *label,float cornerValue);

//Navigation left and right Button
UIBarButtonItem* leftBarButtonForController (id controller, NSString *imgStr);
UIBarButtonItem* rightBarButtonForController(id controller, NSString *imgStr );

//Month Number
+(NSInteger)getMonthNumber:(NSDate *)date andMonthChnage:(NSInteger)monthChangeNumber;

//Toolbar for number pad
UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext);

@end
