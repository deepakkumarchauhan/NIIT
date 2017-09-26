//
//  FeesTableViewCell.h
//  ParentApp
//
//  Created by Prince Kadian on 03/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAFeesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *paymentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *colorStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *installmentNumberLabel;

@property (strong, nonatomic) IBOutlet UILabel *paidAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *receiptNumberLabel;

@end
