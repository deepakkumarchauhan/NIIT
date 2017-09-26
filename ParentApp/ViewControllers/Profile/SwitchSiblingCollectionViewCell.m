//
//  SwitchSiblingCollectionViewCell.m
//  ParentApp
//
//  Created by Prince Kadian on 09/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "SwitchSiblingCollectionViewCell.h"
#import "PAUtility.h"

@implementation SwitchSiblingCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    getRoundedImageView(self.studentImageView);
}

@end
