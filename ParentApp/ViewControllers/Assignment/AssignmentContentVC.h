//
//  AssignmentContentVC.h
//  ParentApp
//
//  Created by Prince Kadian on 08/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AssignmentInfoModal;
@class CircularModel;
@class PAExamination;

@interface AssignmentContentVC : UIViewController

@property (strong,nonatomic) AssignmentInfoModal *assignmentObj;
@property (strong,nonatomic) CircularModel       *objCircularModal;
@property (strong,nonatomic) PAExamination       *objExamModal;

@end
