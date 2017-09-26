//
//  CircularTableViewCell.h
//  ParentApp
//
//  Created by Krati Agarwal on 15/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *circularNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *noOfCircularLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *circularImageView;

@end
