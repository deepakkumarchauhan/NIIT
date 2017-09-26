//
//  FeesSecondTableViewCell.h
//  ParentApp
//
//  Created by Prince Kadian on 03/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeesSecondTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *payableDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *payableAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *paidAmountLabel;

@end
