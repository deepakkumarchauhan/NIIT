//
//  NotificationTVCell.h
//  ParentApp
//
//  Created by PRIYANKA JAISWAL on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *notificationImageView;

@property (strong, nonatomic) IBOutlet UILabel *notificationTitlelabel;
@property (strong, nonatomic) IBOutlet UILabel *notificationDateTimelabel;
@property (strong, nonatomic) IBOutlet UILabel *notificationDescriptionlabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notificationDateWidthConstraint;

@end
