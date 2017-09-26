//
//  HomeModal.h
//  ParentApp
//
//  Created by Abhishek Agarwal on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModal : NSObject

@property (strong , nonatomic) NSString *studentName;
@property (strong , nonatomic) NSString *studentAdminNumber;
@property (strong , nonatomic) NSString *studentSection;
@property (strong , nonatomic) NSString *studentSchoolName;
@property (strong , nonatomic) NSString *studentQualification;

@property (strong , nonatomic) NSString *studentImage;
@property (strong , nonatomic) NSString *studentID;
@property (strong , nonatomic) NSString *studentEnrollmentNumber;

@property (strong, nonatomic) NSString *notificationCount;
@property (strong, nonatomic) NSString *updateCircularCount;
@property (strong, nonatomic) NSString *attendenceAveragePercentage;
@property (strong, nonatomic) NSString *dueAmountCost;
@property (strong, nonatomic) NSString *upadeAssignmentCount;
@property (strong, nonatomic) NSString *upadeTransportCount;
@property (strong, nonatomic) NSString *upadeTimeTableCount;

@property (strong, nonatomic) NSArray *dashboardArray;

+(HomeModal *)parseHomeData:(NSDictionary *)homeDictionary;

@end
