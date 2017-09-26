//
//  OPRequestTimeOutView.h
//  Openia
//
//  Created by Sunil Verma on 11/03/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPRequestTimeOutView : UIView

+ (BOOL)isShown;

+ (void)show;
+ (void)showWithMessage:(NSString *)message forTime:(NSInteger)timeInterval andController:(UIViewController *)controller;
+ (void)showWithMessage:(NSString *)message forTime:(NSInteger)timeInterval textAlignment:(NSTextAlignment)textAlignment andController:(UIViewController *)controller;

+ (void)hide;
+ (void)reframeViewCenter;

@end
