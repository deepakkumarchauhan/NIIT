//
//  ContactUsTableViewCell.h
//  ParentApp
//
//  Created by Deepak Chauhan on 01/12/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraints;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;

@end
