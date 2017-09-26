//
//  AssignmentTableViewCell.h
//  ParentApp
//
//  Created by Prince Kadian on 08/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssignmentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *assignmentNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *assignmentImageView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) IBOutlet UILabel *assignmentDescriptionLabel;

@property (strong, nonatomic) IBOutlet UIButton *moreButton;

@end
