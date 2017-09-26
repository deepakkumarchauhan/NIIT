//
//  PAExamination.m
//  ParentApp
//
//  Created by Yogesh Pal on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"
#import "PAExamination.h"

@implementation PAExamination

+(PAExamination *)parseExamData:(NSDictionary *)examDict
{
    PAExamination *examList = [PAExamination new];
    
    examList.reportName = [examDict objectForKeyNotNull:pReportName expectedObj:@""];
    examList.reportCaption = [examDict objectForKeyNotNull:pReportCaption expectedObj:@""];
    examList.reportIsPublished = [examDict objectForKeyNotNull:pReportIsPublished expectedObj:@""];
    examList.reportURL = [examDict objectForKeyNotNull:pReportURL expectedObj:@""];
    
    return examList;
}

@end
