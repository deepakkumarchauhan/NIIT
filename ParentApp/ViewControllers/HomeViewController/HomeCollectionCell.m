//
//  HomeCollectionCell.m
//  ParentApp
//
//  Created by Abhishek Agarwal on 03/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "HomeCollectionCell.h"

@implementation HomeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.layer.cornerRadius = 2.0;
    self.layer.borderColor = [UIColor clearColor].CGColor;
}

@end
