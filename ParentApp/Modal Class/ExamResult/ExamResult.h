//
//  ExamResult.h
//  ParentApp
//
//  Created by Yogesh Pal on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamResult : NSObject

@property (nonatomic, strong) NSString *subjectName;
@property (nonatomic, strong) NSString *subjectMarks;
@property (nonatomic, strong) NSString *subjectTeacher;
@property (nonatomic, strong) NSString *remark;

+(NSMutableArray *)parseExamResultWith:(NSDictionary *)dict;

@end
