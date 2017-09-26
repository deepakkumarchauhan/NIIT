//
//  ExaminationCustomAlertView.h
//  ParentApp
//
//  Created by PRIYANKA JAISWAL on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExamResult;

@interface TimetableCustomAlertView : UIView

@property (strong, nonatomic) IBOutlet UILabel *label_TeacherName;
@property (strong, nonatomic) IBOutlet UILabel *label_SubjectName;
@property (strong, nonatomic) IBOutlet UILabel *label_Remark;
@property (strong, nonatomic) ExamResult *examResult;

@end
