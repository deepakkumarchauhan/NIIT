//
//  PADesciplineInfo.m
//  ParentApp
//
//  Created by Prince Kadian on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PADesciplineInfo.h"
#import "NSDictionary+NullChecker.h"
#import "ISConstants.h"

@implementation PADesciplineInfo

+(PADesciplineInfo *)getDesciplineInfo:(NSDictionary*)response {
    
    PADesciplineInfo *disciplineInfo = [PADesciplineInfo new];
    
    disciplineInfo.disciplineID = [response objectForKeyNotNull:pDisciplineID expectedObj:@""];
    disciplineInfo.date = [response objectForKeyNotNull:pActionDate expectedObj:@""];
    disciplineInfo.actionPoints = [response objectForKeyNotNull:pActionPoints expectedObj:@""];
    disciplineInfo.reason = [response objectForKeyNotNull:pReason expectedObj:@""];
    disciplineInfo.techerName = [response objectForKeyNotNull:pTeacherName expectedObj:@""];
    disciplineInfo.card = [response objectForKeyNotNull:pCardType expectedObj:@""];
    
    return disciplineInfo;
}

@end
