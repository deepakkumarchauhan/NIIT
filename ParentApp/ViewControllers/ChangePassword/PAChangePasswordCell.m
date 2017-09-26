//
//  CDLoginCell.m
//  CanUDevelop
//
//  Created by Priyanka Sahu on 11/02/16.
//  Copyright © 2016 Priyanka Sahu. All rights reserved.
//

#import "PAChangePasswordCell.h"

@implementation PAChangePasswordCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.textFieldLogin.layer.cornerRadius = 5.0f;
    self.textFieldLogin.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.textFieldLogin.layer.borderWidth = 1.0f;
    [self.textFieldLogin setClipsToBounds:YES];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
