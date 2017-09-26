//
//  PAAttendanceCalendarVC.h
//  ParentApp
//
//  Created by Yogesh Pal on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PAAttendanceSummary;

@interface PAAttendanceCalendarVC : UIViewController

@property (nonatomic) NSInteger monthTag;

@property (strong, nonatomic) PAAttendanceSummary *attendanceSummary;

@end
