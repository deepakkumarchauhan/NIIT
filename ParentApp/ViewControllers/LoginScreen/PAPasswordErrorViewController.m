//
//  PAPasswordErrorViewController.m
//  ParentApp
//
//  Created by Deepak Chauhan on 15/02/17.
//  Copyright © 2017 Yogesh Pal. All rights reserved.
//

#import "PAPasswordErrorViewController.h"
#import "Macro.h"

@interface PAPasswordErrorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixthLabel;

@end

@implementation PAPasswordErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstLabel.text  = @"1. Password should be minimum of 8 characters.";
    self.secondLabel.text = @"2. Password should contain one alphabetic and one numeric character.";
    self.thirdLabel.text  = @"3. Password should begin and end with an alphabet.";
    self.fourthLabel.text = @"4. Password should not have more than 2 identical consecutive characters.";
    self.fifthLabel.text = @"5. Password should not contain User id(User name) as part of password.";
    self.sixthLabel.text = @"6. Password should be different from last 4 passwords.";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)okButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
