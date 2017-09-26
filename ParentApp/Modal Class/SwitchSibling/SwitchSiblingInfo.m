//
//  SwitchSiblingInfo.m
//  ParentApp
//
//  Created by Prince Kadian on 16/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "SwitchSiblingInfo.h"
#import "NSDictionary+NullChecker.h"
#import "ISConstants.h"

@implementation SwitchSiblingInfo

+(SwitchSiblingInfo *)parseSiblingInfo:(NSDictionary*)siblingDictionary {
    
    SwitchSiblingInfo *siblingInfo = [[SwitchSiblingInfo alloc] init];
    
    siblingInfo.studentID = [siblingDictionary objectForKeyNotNull:cpStudentID expectedObj:@""];
    siblingInfo.studentName = [siblingDictionary objectForKeyNotNull:pStudentName expectedObj:@""];
    siblingInfo.studentPicture = [siblingDictionary objectForKeyNotNull:pPIStudentPicture expectedObj:@""];
    siblingInfo.studentPictureData = [[NSData alloc] initWithBase64EncodedString:siblingInfo.studentPicture options:0];
    
    siblingInfo.teacherID = [siblingDictionary objectForKeyNotNull:@"classTeacherID" expectedObj:@""];
    siblingInfo.teacherName = [siblingDictionary objectForKeyNotNull:@"classTeacherName" expectedObj:@""];
    siblingInfo.teacherPhoto = [siblingDictionary objectForKeyNotNull:@"classTeacherPhoto" expectedObj:@""];
    
    return siblingInfo;
}

@end
