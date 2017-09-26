//
//  LibraryTableViewCell.h
//  ParentApp
//
//  Created by Prince Kadian on 15/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *oneDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;

@property (weak, nonatomic) IBOutlet UIButton *bookButton;



@end
