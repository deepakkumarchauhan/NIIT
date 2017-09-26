//
//  PALoginTableViewCell.h
//  ParentApp
//
//  Created by Prince Kadian on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CATextField;

@interface PALoginTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet CATextField *loginTextField;

@end
