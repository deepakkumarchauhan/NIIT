//
//  NotificationTVCell.m
//  ParentApp
//
//  Created by PRIYANKA JAISWAL on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "NotificationTVCell.h"
#import "PAUtility.h"

@implementation NotificationTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    getRoundedImageView(self.notificationImageView);

    [self layoutIfNeeded];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
