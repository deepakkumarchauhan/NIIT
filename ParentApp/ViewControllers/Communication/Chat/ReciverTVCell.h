//
//  ReciverTVCell.h
//  ParentApp
//
//  Created by Prince Kadian on 19/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReciverTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *recieverImage;
@property (weak, nonatomic) IBOutlet UIImageView *recieverImageView;

@property (strong, nonatomic) IBOutlet UILabel *reciverTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *reciverTimeLabel;

@end
