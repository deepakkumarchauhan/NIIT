//
//  TimeTableInfo.h
//  ParentApp
//
//  Created by Prince Kadian on 12/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTableInfo : NSObject

@property (strong,nonatomic) NSString *sectionHeading;

@property (strong,nonatomic) NSMutableArray *columnArray;

@property (nonatomic, strong) NSMutableArray *numberOfRow;

+(NSArray *)parseTimeTableWithArray:(NSArray *)array;

@end

@interface TimeTableValue : NSObject

@property (strong,nonatomic) NSString *studentId;
@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSString *periodSrNo;

@property (strong,nonatomic) NSString *time;
@property (strong,nonatomic) NSString *period;
@property (strong,nonatomic) NSString *monday;
@property (strong,nonatomic) NSString *monPeriodTeacher;
@property (strong,nonatomic) NSString *tuesday;
@property (strong,nonatomic) NSString *tuesPeriodTeacher;
@property (strong,nonatomic) NSString *wednesday;
@property (strong,nonatomic) NSString *wedPeriodTeacher;
@property (strong,nonatomic) NSString *thursday;

@property (strong,nonatomic) NSString *thurPeriodTeacher;
@property (strong,nonatomic) NSString *friday;
@property (strong,nonatomic) NSString *friPeriodTeacher;
@property (strong,nonatomic) NSString *sat;
@property (strong,nonatomic) NSString *satPeriodTeacher;
@property (strong,nonatomic) NSString *sun;
@property (strong,nonatomic) NSString *sunPeriodTeacher;

+(TimeTableValue*)parseTimeTable:(NSDictionary*)dict;

-(NSArray *)getTimeTableValue:(NSInteger)indexPathRow;

@end
