//
//  CDLoginCell.h
//  CanUDevelop
//
//  Created by Priyanka Sahu on 11/02/16.
//  Copyright © 2016 Priyanka Sahu. All rights reserved.
//
#import "Header.h"
@class CATextField;

@interface PAChangePasswordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelErrorAlert;
@property (strong, nonatomic) IBOutlet CATextField *textFieldLogin;

@end
