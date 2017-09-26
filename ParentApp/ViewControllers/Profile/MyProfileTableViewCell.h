//
//  MyProfileTableViewCell.h
//  ParentApp
//
//  Created by Prince Kadian on 06/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttomLabel;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelConstraint;

@property (weak, nonatomic) IBOutlet UITextField *editTextField;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;

@end
