//
//  LoginWithURLTableViewCell.h
//  ParentApp
//
//  Created by Prince Kadian on 31/08/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CATextField.h"

@interface PAFirstAddSchoolTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CATextField *firstAddSchoolTextField;

@property (weak, nonatomic) IBOutlet UIButton *pickerButton;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end
