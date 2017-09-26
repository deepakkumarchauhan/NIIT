//
//  ShowDescriptionWebView.h
//  ParentApp
//
//  Created by Abhishek Agarwal on 22/12/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AssignmentInfoModal;
@class CircularModel;

@interface ShowDescriptionWebView : UIViewController

@property (strong,nonatomic) AssignmentInfoModal *assignmentDescription;
@property (strong,nonatomic) CircularModel       *circularDescriptionObj;

@end
