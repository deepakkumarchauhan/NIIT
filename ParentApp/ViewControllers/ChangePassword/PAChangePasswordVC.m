//
//  CDChangePasswordVC.m
//  CanUDevelop
//
//  Created by Priyanka Sahu on 11/02/16.
//  Copyright © 2016 Priyanka Sahu. All rights reserved.
//

#import "PAChangePasswordVC.h"
#import "PAPasswordErrorViewController.h"
#import "PAUserInfo.h"
#import "PAUtility.h"

static NSString *simpleTableIdentifier = @"Cell";

@interface PAChangePasswordVC()<UITextFieldDelegate> {
    
    int    txtTag;
    PAUserInfo *objUserInfo;
    NSString *username;

}

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderVw;

@property (weak, nonatomic) IBOutlet UITableView *tableView_ChangePwd;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end

@implementation PAChangePasswordVC

#pragma mark - Application life Cycle methods -

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupinitials];
}


-(void)setupinitials
{
    //Current User
    objUserInfo = [[PAUserInfo alloc] init];
    
    //tableview cell
    [self.tableView_ChangePwd registerNib:[UINib nibWithNibName:@"PAChangePasswordCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
    self.tableView_ChangePwd.alwaysBounceVertical = NO;
    
    //Setting Navigation bar
    self.title = @"Change Password";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    
    [self.tableView_ChangePwd setTableHeaderView:_tableHeaderVw];
    [self.tableView_ChangePwd setTableFooterView:_footerView];
    
    txtTag = -1;
    
    self.resetButton.layer.cornerRadius = 5.0f;
    [self.resetButton setClipsToBounds:YES];
    
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
    username = [studentDict valueForKey:@"userName"];
    
}

#pragma mark - tableview delegate and datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows.
    return  3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PAChangePasswordCell *cell = (PAChangePasswordCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell.textFieldLogin.tag = indexPath.row + 100;
    [cell.textFieldLogin setSecureTextEntry:NO];
    [cell.textFieldLogin setDelegate:self];
    
    if (txtTag == indexPath.row) {
        cell.labelErrorAlert.hidden = NO;
        cell.textFieldLogin.layer.borderWidth = 1;
        cell.textFieldLogin.layer.borderColor = [UIColor redColor].CGColor;
        
    }else {
        cell.labelErrorAlert.hidden = YES;
        cell.textFieldLogin.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    
    if (indexPath.row == 0) {
        [cell.textFieldLogin setPlaceHolderTextLightGray:@"Old Password *"];
        cell.textFieldLogin.text = objUserInfo.password;
        cell.textFieldLogin.returnKeyType = UIReturnKeyNext;
        cell.labelErrorAlert.text =  objUserInfo.strAlertMsg;
        [cell.textFieldLogin setSecureTextEntry:YES];
        
        
    }else if(indexPath.row == 1)
    {
        [cell.textFieldLogin setPlaceHolderTextLightGray:@"New Password *"];
        cell.textFieldLogin.text = objUserInfo.strNewPassword;
        cell.textFieldLogin.returnKeyType = UIReturnKeyNext;
        cell.labelErrorAlert.text =  objUserInfo.strAlertMsg;
        [cell.textFieldLogin setSecureTextEntry:YES];
        
    }
    else{
        [cell.textFieldLogin setPlaceHolderTextLightGray:@"Confirm New Password *"];
        cell.textFieldLogin.text = objUserInfo.strCnfrmNewPassword;
        cell.textFieldLogin.returnKeyType = UIReturnKeyDone;
        cell.labelErrorAlert.text =  objUserInfo.strAlertMsg;
        [cell.textFieldLogin setSecureTextEntry:YES];
    }
    
    return cell;
}

#pragma mark - Delegate of Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (txtTag == indexPath.row){
        return 70;
    }else
        return 50;
}

#pragma mark - UITextField Delegate Method

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
//    if(range.length + range.location > textField.text.length)
//    {
//        return NO;
//    }
//
//    NSUInteger newLength = [textField.text length] + [string length] - range.length;
//    return newLength <= 25;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
    {
        return NO;
    }
    
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    return (newLength > 32) ? NO : YES;
}


- (BOOL)textFieldShouldReturn:(CATextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        [[self.tableView_ChangePwd viewWithTag:textField.tag+1] becomeFirstResponder];
    }else
        [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(CATextField *)textField {
    

    if (txtTag != -1) {
        txtTag = -1;
        [self.tableView_ChangePwd reloadData];
    }
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [textField becomeFirstResponder];
    });

}

- (void)textFieldDidEndEditing:(CATextField *)textField {
    
    switch (textField.tag) {
        case 100:
            objUserInfo.password = textField.text;
            break;
        case 101:
            objUserInfo.strNewPassword = textField.text;
            break;
        case 102:
            objUserInfo.strCnfrmNewPassword = textField.text;
            break;
        default:
            break;
    }
 //   [self.tableView_ChangePwd reloadData];
}

#pragma mark - Validation method

-(BOOL)isLoginFieldsVerified {
    
    BOOL isVerified = YES;
    
    unichar newFirstChar = 0;
    unichar newLastChar = 0;
  //  unichar conFirstChar = 0;
   // unichar conLastChar = 0;
    NSCharacterSet *letter;
    
    NSString *newPassword = TRIMSPACE([CDTextFiled(101) text]);

    if ([TRIMSPACE([CDTextFiled(101) text]) length]) {
        newFirstChar = [[TRIMSPACE([CDTextFiled(101) text]) uppercaseString] characterAtIndex:0];
        newLastChar = [[TRIMSPACE([CDTextFiled(101) text]) uppercaseString] characterAtIndex:TRIMSPACE([CDTextFiled(101) text]).length-1];
         letter = [NSCharacterSet letterCharacterSet];
    }
    
    if (![TRIMSPACE([CDTextFiled(100) text]) length]) {
        objUserInfo.strAlertMsg = BLANK_OLD_PASSWORD;
        txtTag = 0;
        
    }else if ([TRIMSPACE([CDTextFiled(100) text]) length]<8){
        objUserInfo.strAlertMsg = VALID_OLD_PASSWORD;
        txtTag = 0;
        
    }else if (![TRIMSPACE([CDTextFiled(101) text]) length]) {
        objUserInfo.strAlertMsg = BLANK_NEW_PASSWORD;
        txtTag = 1;
        
    }else if ([newPassword containsString:username] && username.length) {
        objUserInfo.strAlertMsg = VALID_NEW_ALL_PASSWORD;
        txtTag = 1;
        
    }
    else if ([TRIMSPACE([CDTextFiled(101) text]) length]<8){
        objUserInfo.strAlertMsg = VALID_NEW_ALL_PASSWORD;
        txtTag = 1;
        
    }else if ([PAFValidatesField validatePassword:TRIMSPACE([CDTextFiled(101) text])]) {
    
        objUserInfo.strAlertMsg = VALID_NEW_ALL_PASSWORD;
        txtTag = 1;
        
    }else if (!([letter characterIsMember:newFirstChar] && [letter characterIsMember:newLastChar])) {
        
        objUserInfo.strAlertMsg = VALID_NEW_ALL_PASSWORD;
        txtTag = 1;
        
    }else if (![TRIMSPACE([CDTextFiled(102) text]) length]) {
        objUserInfo.strAlertMsg = BLANK_CONFIRM_PASSWORD;
        txtTag = 2;
    
    }
    else if (![[CDTextFiled(101) text] isEqualToString:[CDTextFiled(102) text]]) {
        objUserInfo.strAlertMsg = MATCH_PASSWORD;
        txtTag = 2;
    }else {
        txtTag = -1;
        isVerified = NO;
    }
    
    return isVerified;
}

#pragma mark-IBAction

- (IBAction)resetPasswordAction:(id)sender {
    [self.view endEditing:YES];

    if (![self isLoginFieldsVerified]) {
        [self callAPIForChangePassword];
    }else
    [self.tableView_ChangePwd reloadData];
}

-(void)leftBarButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)helpButtonAction:(id)sender {
    
    PAPasswordErrorViewController *passVC = [[PAPasswordErrorViewController alloc]initWithNibName:@"PAPasswordErrorViewController" bundle:nil];
    passVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:passVC animated:NO completion:nil];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForChangePassword {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:objUserInfo.password forKey:pOldPassword];
    [params setValue:objUserInfo.strNewPassword forKey:pNewPassword];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiChangePassword andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        if ([[result valueForKey:cpResponseCode] integerValue] == 200)
            [self.navigationController popViewControllerAnimated:YES];
    }];

}

#pragma mark- memory management method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
