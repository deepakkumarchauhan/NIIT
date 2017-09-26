//
//  SenderTVCell.m
//  ParentApp
//
//  Created by Prince Kadian on 19/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "SenderTVCell.h"
#import "PAUtility.h"

@implementation SenderTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];

    getRoundedImageView(self.senderImageView);
    self.senderImageView.layer.borderWidth = 1.0;
    self.senderImageView.layer.borderColor = ([UIColor lightGrayColor]).CGColor;
    
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
    
    // Set Image
    if ([[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] length]) {
        
        NSData* data = [[NSData alloc] initWithBase64EncodedString:[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] options:0];
        self.senderImageView.image = [UIImage imageWithData:data];
        
    }else
        self.senderImageView.image = [UIImage imageNamed:@"dummy"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
