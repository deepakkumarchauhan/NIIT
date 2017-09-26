//
//  StudentProfileInfo.m
//  ParentApp
//
//  Created by PRIYANKA JAISWAL on 31/08/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "StudentProfileInfo.h"
#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"
#import "PAUtility.h"

@implementation StudentProfileInfo

+(StudentProfileInfo *)parseStudentInfo:(NSDictionary *)studentDictionary {
    
    StudentProfileInfo *studentInfo = [StudentProfileInfo new];

    studentInfo.enrollmentNumber = [studentDictionary objectForKeyNotNull:cpEnrollmentNumber expectedObj:@""];
    studentInfo.studentName = [studentDictionary objectForKeyNotNull:pPIStudentName expectedObj:@""];
    studentInfo.standard = [studentDictionary objectForKeyNotNull:pStandard expectedObj:@""];
    studentInfo.section = [studentDictionary objectForKeyNotNull:pPISection expectedObj:@""];
    studentInfo.rollNumber = [studentDictionary objectForKeyNotNull:pRollNo expectedObj:@""];
    studentInfo.parentMobileNumber = [studentDictionary objectForKeyNotNull:pParentMobileNumber expectedObj:@""];
    studentInfo.address = [studentDictionary objectForKeyNotNull:pCIAddress expectedObj:@""];
   // studentInfo.studentPicture = [studentDictionary objectForKeyNotNull:pPIStudentPicture expectedObj:@""];
    studentInfo.dOB = [studentDictionary objectForKeyNotNull:pDOB expectedObj:@""];
    
    return studentInfo;
}

@end
