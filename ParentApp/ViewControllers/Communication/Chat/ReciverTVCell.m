//
//  ReciverTVCell.m
//  ParentApp
//
//  Created by Prince Kadian on 19/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "ReciverTVCell.h"
#import "PAUtility.h"


@implementation ReciverTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    getRoundedImageView(self.recieverImageView);
    self.recieverImageView.layer.borderWidth = 1.0;
    self.recieverImageView.layer.borderColor = ([UIColor lightGrayColor]).CGColor;
    [self layoutIfNeeded];
    
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];

    // Set Image
    if ([[studentDict objectForKeyNotNull:@"teacherPhoto" expectedObj:@""] length]) {
        
        NSData* data = [[NSData alloc] initWithBase64EncodedString:[studentDict objectForKeyNotNull:@"teacherPhoto" expectedObj:@""] options:0];
        self.recieverImageView.image = [UIImage imageWithData:data];
        
    }else
        self.recieverImageView.image = [UIImage imageNamed:@"dummy"];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
