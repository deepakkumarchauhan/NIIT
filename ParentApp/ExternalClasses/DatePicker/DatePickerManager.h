//
//  DatePicker.h
//  MeAndChange
//
//  Created by Raj Kumar Sharma on 27/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RMDateSelectionViewController.h"

@interface DatePickerManager : NSObject

+ (DatePickerManager *)dateManager;

@property (assign, nonatomic) BOOL showCurrentDateOption;

- (void)showDatePicker:(UIViewController *)parentController completionBlock:(void (^)(NSDate *date))block;
- (void)showDatePicker:(UIViewController *)parentController withTitle:(NSString *)title completionBlock:(void (^)(NSDate *date))block;

@end
