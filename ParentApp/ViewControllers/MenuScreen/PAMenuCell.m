//
//  PAMenuCell.m
//  ParentApp
//
//  Created by Abhishek Agarwal on 03/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PAMenuCell.h"

@implementation PAMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    //_lowerSeperatorLabel.transform  = CGAffineTransformMakeRotation(4*M_PI/360);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
