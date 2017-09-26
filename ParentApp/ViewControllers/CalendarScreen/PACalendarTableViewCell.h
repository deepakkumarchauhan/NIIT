//
//  PACalendarTableViewCell.h
//  ParentApp
//
//  Created by Deepak Chauhan on 21/04/17.
//  Copyright © 2017 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PACalendarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;

@end
