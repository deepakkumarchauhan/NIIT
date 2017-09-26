//
//  CalendarSummary.m
//  ParentApp
//
//  Created by Yogesh Pal on 09/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"
#import "CalendarSummary.h"

@implementation CalendarSummary

+(CalendarSummary *)parseCalendarSummaryMonthWiseWith:(NSDictionary *)dict
{
    CalendarSummary *objCalendarSummary = [[CalendarSummary alloc] init];
    
    objCalendarSummary.presentCount = [dict objectForKeyNotNull:pPresentCode expectedObj:@""];
    objCalendarSummary.absentCount = [dict objectForKeyNotNull:pAbsentCount expectedObj:@""];
    objCalendarSummary.leaveCount = [dict objectForKeyNotNull:pLeaveCount expectedObj:@""];
    objCalendarSummary.firstHalfCount = [dict objectForKeyNotNull:pFirstHalfCount expectedObj:@""];
    objCalendarSummary.secondHalfCount = [dict objectForKeyNotNull:pSecondHalfCount expectedObj:@""];
    
    objCalendarSummary.dataSourceCalendarMonthWise = [Calendar parseCalendarDataMonthWiseWith:dict];
    
    return  objCalendarSummary;
}

@end

@implementation Calendar

+(NSMutableArray *)parseCalendarDataMonthWiseWith:(NSDictionary *)dict
{
    NSMutableArray *presenceList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *presenceDict in [dict objectForKeyNotNull:pAttendanceMonth expectedObj:[NSMutableArray array]]) {
        
        Calendar *objCalendar = [[Calendar alloc] init];
        
        objCalendar.dayKey = [presenceDict objectForKeyNotNull:pDayKey expectedObj:@""];
        objCalendar.status = [presenceDict objectForKeyNotNull:pStatus expectedObj:@""];
        objCalendar.date = [presenceDict objectForKeyNotNull:pCalendarDate expectedObj:@""];
        
        [presenceList addObject:objCalendar];
    }
    
    return [presenceList mutableCopy];
}


@end
