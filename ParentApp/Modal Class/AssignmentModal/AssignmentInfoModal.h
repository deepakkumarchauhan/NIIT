//
//  AssignmentInfoModal.h
//  ParentApp
//
//  Created by Prince Kadian on 08/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SubjectInfoModal : NSObject

@property(strong,nonatomic)NSString *subjectID;
@property(strong,nonatomic)NSString *subjectName;

+(SubjectInfoModal *)parseSubjectInfo:(NSDictionary*)subjectDictionary;

@end

@interface AssignmentInfoModal : NSObject

@property(strong,nonatomic)NSString *assignmentName;
@property(strong,nonatomic)NSString *assignmentDetail;
@property(strong,nonatomic)NSString *assignmentDescriptionWithoutDetail;

@property(assign,nonatomic)  BOOL isTextMore;

@property(strong,nonatomic)NSString *assignmentPicture;
@property(strong,nonatomic)NSString *assignmentDate;

@property(strong,nonatomic)NSString *assignmentFileContent;
@property(strong,nonatomic)NSData *contentData;

@property(strong,nonatomic)NSString *fileName;
@property(strong,nonatomic)NSString *fileDescription;
@property(strong,nonatomic)NSString *fileType;

@property(strong,nonatomic)NSString *subjectID;
@property(strong,nonatomic)NSString *subjectName;

@property(assign,nonatomic)NSInteger selectedSubjectInCurrent;
@property(assign,nonatomic)NSInteger selectedSubjectInHistory;
@property(strong,nonatomic)NSString *assignmentType;

+(AssignmentInfoModal *)parseAssignmentInfo:(NSDictionary*)assignmentDictionary;

@end
