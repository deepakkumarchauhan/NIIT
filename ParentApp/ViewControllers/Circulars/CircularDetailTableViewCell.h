//
//  CircularDetailTableViewCell.h
//  ParentApp
//
//  Created by Krati Agarwal on 15/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *circularDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *circularDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *circularSubjectLabel;

@property (weak, nonatomic) IBOutlet UIButton *viewAndSaveButton;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet UIImageView *circularImageView;


@end
