//
//  PAAttendanceSummary.m
//  ParentApp
//
//  Created by Yogesh Pal on 09/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"
#import "PAAttendanceSummary.h"

@implementation PAAttendanceSummary

+(PAAttendanceSummary *)parseAttendanceDetailWith:(NSDictionary *)dict
{
    PAAttendanceSummary *objAttendanceSummary  = [[PAAttendanceSummary alloc] init];
    
    objAttendanceSummary.studentID = [dict objectForKeyNotNull:cpStudentID expectedObj:@""];
    objAttendanceSummary.studentEnrollmentNumber = [dict objectForKeyNotNull:cpEnrollmentNumber expectedObj:@""];
    objAttendanceSummary.studentName = [dict objectForKeyNotNull:pPIStudentName expectedObj:@""];
   // objAttendanceSummary.studentProfileImage = [dict objectForKeyNotNull:pPIStudentPicture expectedObj:@""];
    objAttendanceSummary.dataSourceAttendance =  [Attendance parseAttendanceDataWith:dict];
    
    return objAttendanceSummary;
}

@end

@implementation Attendance

+(NSMutableArray *)parseAttendanceDataWith:(NSDictionary *)dict
{
    NSMutableArray *attendanceList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *attendanceDict in [dict objectForKeyNotNull:pAttendanceBarChart expectedObj:[NSMutableArray array]]) {
        
        Attendance *objAttendance = [[Attendance alloc] init];
        
        objAttendance.monthNum = [attendanceDict objectForKeyNotNull:pMonthNumber expectedObj:@""];
        objAttendance.monthName = [attendanceDict objectForKeyNotNull:pMonthName expectedObj:@""];
        objAttendance.attendanceScore = [attendanceDict objectForKeyNotNull:pAttendancePercentage expectedObj:@""];
        objAttendance.attendanceDate = [attendanceDict objectForKeyNotNull:cpDate expectedObj:@""];

        [attendanceList addObject:objAttendance];
    }
    
    return attendanceList;
}

@end