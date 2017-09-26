//
//  StudentProfileInfo.h
//  ParentApp
//
//  Created by PRIYANKA JAISWAL on 31/08/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentProfileInfo : NSObject

@property (strong,nonatomic) NSString *enrollmentNumber;
@property (strong,nonatomic) NSString *studentName;
@property (strong,nonatomic) NSString *standard;
@property (strong,nonatomic) NSString *section;
@property (strong,nonatomic) NSString *rollNumber;
@property (strong,nonatomic) NSString *dOB;
@property (strong,nonatomic) NSString *dOBTimeStamp;
@property (strong,nonatomic) NSString *parentMobileNumber;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *studentPicture;

+(StudentProfileInfo *)parseStudentInfo:(NSDictionary *)studentDictionary;

@end
