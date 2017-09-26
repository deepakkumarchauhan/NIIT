//
//  PACalendarEventCell.h
//  ParentApp
//
//  Created by Abhishek Agarwal on 06/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PACalendarEventCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) IBOutlet UILabel *eventValue;

@property (strong, nonatomic) IBOutlet UILabel *upperLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowerLabel;

@end
