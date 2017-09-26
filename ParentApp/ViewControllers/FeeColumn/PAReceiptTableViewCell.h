//
//  PAReceiptTableViewCell.h
//  ParentApp
//
//  Created by Prince Kadian on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAReceiptTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttomLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomLabelConstraint;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@end
