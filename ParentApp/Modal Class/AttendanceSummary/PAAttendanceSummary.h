//
//  PAAttendanceSummary.h
//  ParentApp
//
//  Created by Yogesh Pal on 09/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAAttendanceSummary : NSObject

@property (nonatomic, strong) NSString *studentID;
@property (nonatomic, strong) NSString *studentName;
@property (nonatomic, strong) NSString *studentEnrollmentNumber;
@property (nonatomic, strong) NSString *studentProfileImage;
@property (nonatomic, strong) NSMutableArray *dataSourceAttendance;

+(PAAttendanceSummary *)parseAttendanceDetailWith:(NSDictionary *)dict;

@end

@interface Attendance : NSObject

@property (nonatomic, strong) NSString *monthNum;
@property (nonatomic, strong) NSString *monthName;
@property (nonatomic, strong) NSString *attendanceScore;
@property (nonatomic, strong) NSString *attendanceDate;

+(NSMutableArray *)parseAttendanceDataWith:(NSDictionary *)dict;

@end