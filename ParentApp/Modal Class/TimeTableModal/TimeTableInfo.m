//
//  TimeTableInfo.m
//  ParentApp
//
//  Created by Prince Kadian on 12/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "TimeTableInfo.h"
#import "NSDictionary+NullChecker.h"
#import <Foundation/Foundation.h>

@implementation TimeTableInfo

+(NSArray *)parseTimeTableWithArray:(NSArray *)array
{
    NSMutableArray *timeTableArray = [NSMutableArray array];
    
    TimeTableInfo *objSection = [[TimeTableInfo alloc] init];
    objSection.numberOfRow = [NSMutableArray array];
    
    for (int index = 0; index < array.count; index ++) {
        
        NSDictionary *params = [array objectAtIndex:index];
        
        if ([[[params objectForKeyNotNull:@"period" expectedObj:@""] lowercaseString] containsString:@"break"]) {
            
            [timeTableArray addObject:objSection];
            
            objSection = [[TimeTableInfo alloc] init];
            objSection.sectionHeading = [NSString stringWithFormat:@"Lunch Time ( %@ )",[params objectForKeyNotNull:@"time" expectedObj:@""]];
            objSection.numberOfRow = [NSMutableArray array];

            continue;
        }
        
        [objSection.numberOfRow addObject:[TimeTableValue parseTimeTable:params]];
    }
    
    [timeTableArray addObject:objSection];
    
    return timeTableArray;
}


@end

@implementation TimeTableValue

+(TimeTableValue*)parseTimeTable:(NSDictionary*)dict {
    
    TimeTableValue *timeTableInfo = [[TimeTableValue alloc] init];
    
    timeTableInfo.studentId = [dict objectForKeyNotNull:@"studentId" expectedObj:@""];
    timeTableInfo.userId = [dict objectForKeyNotNull:@"id" expectedObj:@""];
    timeTableInfo.periodSrNo = [dict objectForKeyNotNull:@"periodSrNo" expectedObj:@""];
    
    timeTableInfo.time = [dict objectForKeyNotNull:@"time" expectedObj:@""];
    timeTableInfo.period = [dict objectForKeyNotNull:@"period" expectedObj:@""];
    timeTableInfo.monday = [dict objectForKeyNotNull:@"mon" expectedObj:@""];
    timeTableInfo.monPeriodTeacher = [dict objectForKeyNotNull:@"monPeriodTeacher" expectedObj:@""];
    timeTableInfo.tuesday = [dict objectForKeyNotNull:@"tues" expectedObj:@""];
    timeTableInfo.tuesPeriodTeacher = [dict objectForKeyNotNull:@"tuesPeriodTeacher" expectedObj:@""];
    timeTableInfo.wednesday = [dict objectForKeyNotNull:@"wed" expectedObj:@""];
    timeTableInfo.wedPeriodTeacher = [dict objectForKeyNotNull:@"wedPeriodTeacher" expectedObj:@""];
    timeTableInfo.thursday = [dict objectForKeyNotNull:@"thur" expectedObj:@""];
    timeTableInfo.thurPeriodTeacher = [dict objectForKeyNotNull:@"thurPeriodTeacher" expectedObj:@""];
    timeTableInfo.friday = [dict objectForKeyNotNull:@"fri" expectedObj:@""];
    timeTableInfo.friPeriodTeacher = [dict objectForKeyNotNull:@"friPeriodTeacher" expectedObj:@""];
    timeTableInfo.sat = [dict objectForKeyNotNull:@"sat" expectedObj:@""];
    timeTableInfo.satPeriodTeacher = [dict objectForKeyNotNull:@"satPeriodTeacher" expectedObj:@""];
    timeTableInfo.sun = [dict objectForKeyNotNull:@"sun" expectedObj:@""];
    timeTableInfo.sunPeriodTeacher = [dict objectForKeyNotNull:@"sunPeriodTeacher" expectedObj:@""];
    
    return timeTableInfo;
}

-(NSArray *)getTimeTableValue:(NSInteger)indexPathRow {
    NSMutableArray *rowArray = [NSMutableArray array];
    
    NSArray *numerals = [NSArray arrayWithObjects:@"I", @"II", @"III", @"IV", @"V", @"VI", @"VII", @"VIII", @"IX", @"X", @"XI", @"XII", @"XIII",@"XIV",@"XV",@"XVI",@"XVII",@"XVIII",@"XIX",@"XX", nil];
    NSArray* timeArray = [self.time componentsSeparatedByString: @"-"];

    [rowArray addObject:[NSString stringWithFormat:@" %@ (%@)",[numerals objectAtIndex:[self.period integerValue]-1],[NSString stringWithFormat:@"%@\n-%@",[timeArray firstObject],[timeArray lastObject]]]];
    
    [rowArray addObject:self.monday];
    [rowArray addObject:self.tuesday];
    [rowArray addObject:self.wednesday];
    [rowArray addObject:self.thursday];
    [rowArray addObject:self.friday];
    [rowArray addObject:self.sat];

    return rowArray;
}

@end
