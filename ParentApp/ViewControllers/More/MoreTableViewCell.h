//
//  MoreTableViewCell.h
//  ParentApp
//
//  Created by Prince Kadian on 14/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttomLabel;

@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeftConstraint;

@end
