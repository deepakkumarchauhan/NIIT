//
//  SenderTVCell.h
//  ParentApp
//
//  Created by Prince Kadian on 19/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenderTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *senderImage;
@property (weak, nonatomic) IBOutlet UIImageView *senderImageView;
@property (strong, nonatomic) IBOutlet UILabel *senderTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *senderTimeLabel;

@end
