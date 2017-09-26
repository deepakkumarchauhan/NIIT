//
//  PAMenuCell.h
//  ParentApp
//
//  Created by Abhishek Agarwal on 03/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAMenuCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;

@property (strong, nonatomic) IBOutlet UILabel *itemNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *lowerSeperatorLabel;

@end
