//
//  MTCustomButton.m
//  MyTeam
//
//  Created by Abhishek on 02/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "CustomButton.h"
#import "Macro.h"

@implementation CustomButton

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 20);
}

- (void)setColorOnSelection {
    
    UIColor *textfieldColor = TextFieldColorAtBeginEditing;
    self.layer.borderColor = textfieldColor.CGColor;
    [[self titleLabel] setTextColor:textfieldColor];
}

- (void)setColorOnDismiss {
    
    UIColor *textfieldColor = TextFieldColor;
    self.layer.borderColor = textfieldColor.CGColor;
    [[self titleLabel] setTextColor:[UIColor darkGrayColor]];
}

@end
