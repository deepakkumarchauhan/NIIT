//
//  MyProfileSecondTableViewCell.m
//  ParentApp
//
//  Created by Prince Kadian on 06/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "MyProfileSecondTableViewCell.h"
#import "PAUtility.h"

@implementation MyProfileSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
     getRoundedImageView(self.profileTeacherImageView);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
