//
//  ExamResult.m
//  ParentApp
//
//  Created by Yogesh Pal on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "Header.h"
#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"

@implementation ExamResult

+(NSMutableArray *)parseExamResultWith:(NSDictionary *)dict
{
    NSMutableArray *subjectList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *objSubject in [dict objectForKeyNotNull:@"" expectedObj:[NSMutableArray array]]) {
        
        ExamResult *objResult = [[ExamResult alloc] init];
        
        objResult.subjectName = [objSubject objectForKeyNotNull:pSubjectName expectedObj:@""];
        objResult.subjectMarks = [objSubject objectForKeyNotNull:@"" expectedObj:@""];
        objResult.subjectTeacher = [objSubject objectForKeyNotNull:@"" expectedObj:@""];
        objResult.remark = [objSubject objectForKeyNotNull:@"" expectedObj:@""];
        
        [subjectList addObject:objResult];
    }
    
    return [subjectList mutableCopy];
}
@end
