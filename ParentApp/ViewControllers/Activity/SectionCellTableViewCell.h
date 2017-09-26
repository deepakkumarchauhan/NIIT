//
//  SectionCellTableViewCell.h
//  ParentApp
//
//  Created by Prince Kadian on 13/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;

@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelHieghtConstraint;


@end
