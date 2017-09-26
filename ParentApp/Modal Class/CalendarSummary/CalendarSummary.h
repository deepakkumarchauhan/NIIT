//
//  CalendarSummary.h
//  ParentApp
//
//  Created by Yogesh Pal on 09/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarSummary : NSObject

@property (nonatomic, strong) NSString *presentCount;
@property (nonatomic, strong) NSString *absentCount;
@property (nonatomic, strong) NSString *leaveCount;
@property (nonatomic, strong) NSString *firstHalfCount;
@property (nonatomic, strong) NSString *secondHalfCount;

@property (nonatomic, strong) NSMutableArray *dataSourceCalendarMonthWise;

+(CalendarSummary *)parseCalendarSummaryMonthWiseWith:(NSDictionary *)dict;

@end

@interface Calendar : NSObject

@property (nonatomic, strong) NSString *dayKey;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *date;

+(NSMutableArray *)parseCalendarDataMonthWiseWith:(NSDictionary *)dict;

@end