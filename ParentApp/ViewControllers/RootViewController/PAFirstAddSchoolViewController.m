//
//  PARootViewController.m
//  ParentApp
//
//  Created by Yogesh Pal on 31/08/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "Header.h"

@interface PAFirstAddSchoolViewController ()<UITextFieldDelegate> {
    
    PAUserInfo   *modalObj;
    NSInteger    invalidRowNumber;
}

@property (weak, nonatomic) IBOutlet UITableView *firstAddSchoolTableView;
@property (strong, nonatomic) IBOutlet UIView *loginHeaderView;


@end

@implementation PAFirstAddSchoolViewController


#pragma MARK: View Controller Life Cycle

- (void)viewDidLoad {
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    
    [self customInitialization];
}

#pragma MARK: Helper Methods

-(void)customInitialization{

    //Naviagtion title
    self.title = @"School Login";
    
    //Register TableView Cell
    [self.firstAddSchoolTableView registerNib:[UINib nibWithNibName:@"PAFirstAddSchoolTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAFirstAddSchoolTableViewCell"];
    self.firstAddSchoolTableView.tableHeaderView = self.loginHeaderView;
    self.firstAddSchoolTableView.alwaysBounceVertical = NO;

    invalidRowNumber = -1;

    //Alloc Modal Class
    modalObj = [[PAUserInfo alloc]init];
}

#pragma MARK : UITextfield Delegate Methods

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view layoutIfNeeded];
    switch (textField.tag) {
        case 100:{
            modalObj.addedSchoolURL = textField.text;
        }
            break;
        case 101:{
            modalObj.addedSchoolNickName = textField.text;
        }
            break;
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(invalidRowNumber != -1){
        invalidRowNumber = -1;
        [self.firstAddSchoolTableView reloadData];
        
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [textField becomeFirstResponder];
        });
    }
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.returnKeyType == UIReturnKeyNext) {
        
        UITextField *next = [self.view viewWithTag:textField.tag+1];
        [next becomeFirstResponder];
        
    }else if (textField.returnKeyType == UIReturnKeyDone)
        [textField resignFirstResponder];

        return YES;
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (invalidRowNumber == indexPath.row){
        return 72;
    }else
        return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PAFirstAddSchoolTableViewCell *cell = (PAFirstAddSchoolTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PAFirstAddSchoolTableViewCell" forIndexPath:indexPath];
    cell.firstAddSchoolTextField.delegate = self;
    cell.firstAddSchoolTextField.returnKeyType = UIReturnKeyNext;

    cell.errorLabel.tag = 400 + indexPath.row;
    cell.firstAddSchoolTextField.tag = indexPath.row +100;
    
    if (invalidRowNumber == indexPath.row) {

        cell.errorLabel.hidden = NO;
        cell.errorLabel.text = modalObj.strAlertMsg;
        cell.firstAddSchoolTextField.layer.borderWidth = 1;
        [cell.firstAddSchoolTextField setPaddingValue:25];
        UIColor *errorColor = AppRedColor;
        cell.firstAddSchoolTextField.layer.borderColor = errorColor.CGColor;
        
    } else {
        
        cell.errorLabel.hidden = YES;
        cell.firstAddSchoolTextField.layer.borderWidth = 2;
        cell.firstAddSchoolTextField.layer.borderColor= [UIColor whiteColor].CGColor;
    }
    
    
    switch (indexPath.row) {
        case 0:
            [cell.firstAddSchoolTextField setPaddingIcon:[UIImage imageNamed:@"icon2"]];
            [cell.firstAddSchoolTextField setPlaceHolderTextLightGray: @"Add Your School URL *"];
            cell.firstAddSchoolTextField.keyboardType = UIKeyboardTypeURL;
            
            break;
            
        case 1:
            [cell.firstAddSchoolTextField setPaddingIcon:[UIImage imageNamed:@"profile"]];
            [cell.firstAddSchoolTextField setPlaceHolderTextLightGray:@"Nickname *"];
            cell.firstAddSchoolTextField.returnKeyType = UIReturnKeyDone;
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
    {
        return NO;
    }
    
    switch (textField.tag) {
        case 100:
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            
            return (newLength > 100) ? NO : YES;
        } case 101:
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            
            return (newLength > 20) ? NO : YES;
        }
            
            
        default:
            return YES;
    }
}

#pragma mark-validation  methods

-(BOOL)allTextFieldValidations {
    
    BOOL isVerified = NO;
    
    if ([TRIMSPACE(modalObj.addedSchoolURL) length] == 0) {

        modalObj.strAlertMsg = BLANK_URL;
        invalidRowNumber = 0;
    }

    else if ([PAFValidatesField validateUrl:modalObj.addedSchoolURL]) {
        
        modalObj.strAlertMsg = VALID_URL;
        invalidRowNumber = 0;
    }
    else if ([TRIMSPACE(modalObj.addedSchoolNickName) length] == 0) {
        
        modalObj.strAlertMsg = BLANK_NICKNAME;
        invalidRowNumber = 1;
    }
    else
        isVerified = YES;
    
    return isVerified;
}

#pragma MARK: Button Action Methods

- (IBAction)submitButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self allTextFieldValidations])
          [self callAPIAddSchool];
    else
        [self.firstAddSchoolTableView reloadData];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIAddSchool {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:modalObj.addedSchoolURL forKey:pSchoolURL];
    [APPDELEGATE setSchoolURL:modalObj.addedSchoolURL];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiSchoolDetail andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            NSMutableDictionary *studentDetail = [NSMutableDictionary dictionary];
            
            [studentDetail setValue:[result objectForKeyNotNull:pSchoolPhoto expectedObj:@""] forKey:pSchoolPhoto];
            [studentDetail setValue:[result objectForKeyNotNull:cpSchoolID expectedObj:@""] forKey:cpSchoolID];
            
            [studentDetail setValue:modalObj.addedSchoolNickName forKey:pSchoolNickName];
            [studentDetail setValue:modalObj.addedSchoolURL forKey:pSchoolURL];
            
            NSMutableArray *schoolDetailArray = [NSMutableArray arrayWithObjects:studentDetail, nil];
            [NSUSERDEFAULT setValue:schoolDetailArray forKey:@"schoolInformation"];
            [NSUSERDEFAULT synchronize];
            
            PALoginViewController *examVCObj = [[PALoginViewController alloc]initWithNibName:@"PALoginViewController" bundle:nil];
            [self.navigationController pushViewController:examVCObj animated:YES];
            
        } else
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
            //[OPRequestTimeOutView showWithMessage:@"Please enter correct URL." forTime:3.0 andController:self];
    }];
}

#pragma mark - Memory Managment 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
