//
//  FeedbackViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 14/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "FeedbackViewController.h"
#import "CATextField.h"
#import "PAUtility.h"

@interface FeedbackViewController ()<UITextFieldDelegate>{
    PAUserInfo   *modalObj;
    BOOL           isErrorValid;
    NSInteger      invalidRowNumber;
}
@property (weak, nonatomic) IBOutlet UITableView *feedbackTableView;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self customInitialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customInitialization{
    
    //Navigation Bar
    self.title = @"Feedback";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    self.navigationController.navigationBarHidden = NO;
    
    //Register Cells
    [self.feedbackTableView registerNib:[UINib nibWithNibName:@"PAFirstAddSchoolTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAFirstAddSchoolTableViewCell"];
    [self.feedbackTableView setAlwaysBounceVertical:NO];
    
    //Alloc Modal Class
    modalObj = [[PAUserInfo alloc]init];

}

#pragma MARK : UITextfield Delegate Methods

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view layoutIfNeeded];
    switch (textField.tag) {
        case 900:{
            modalObj.feedbackName = textField.text;
        }
            break;
        case 901:{
            modalObj.feedbackEmail = textField.text;
        }
            break;
        case 902:{
            modalObj.feedbackMessage = textField.text;
        }
            break;
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(isErrorValid){
        isErrorValid = NO;
        [self.feedbackTableView reloadData];
        
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [textField becomeFirstResponder];
        });
    }
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType==UIReturnKeyNext) {
        UITextField *next = [self.view viewWithTag:textField.tag+1];
        [next becomeFirstResponder];
    }
    else if (textField.returnKeyType==UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isErrorValid && invalidRowNumber == indexPath.row){
        return 72;
    }else
        return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PAFirstAddSchoolTableViewCell *cell = (PAFirstAddSchoolTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PAFirstAddSchoolTableViewCell" forIndexPath:indexPath];
    
    cell.errorLabel.tag = 400 +indexPath.row;
    cell.firstAddSchoolTextField.delegate = self;
    cell.firstAddSchoolTextField.tag = indexPath.row +900;
    [cell.firstAddSchoolTextField setPaddingValue:10];

    
    if (isErrorValid && invalidRowNumber == indexPath.row) {
        
        cell.errorLabel.hidden = NO;
        cell.errorLabel.text = modalObj.strAlertMsg;
        cell.firstAddSchoolTextField.layer.borderWidth=1;
        cell.firstAddSchoolTextField.layer.borderColor= AppRedColor.CGColor;
        
    } else {
        
        cell.errorLabel.hidden = YES;
        cell.firstAddSchoolTextField.layer.borderWidth=2;
        cell.firstAddSchoolTextField.layer.borderColor= RGBCOLOR(238, 238, 238, 1).CGColor;
    }
    
    [cell.firstAddSchoolTextField setHidden:NO];
    [cell.pickerButton setHidden:YES];
    [cell.firstAddSchoolTextField setFont:AppFont(18)];
    [cell.firstAddSchoolTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    switch (indexPath.row) {
        case 0:
            [cell.firstAddSchoolTextField setPlaceHolderTextLightGray: @"Name"];
            [cell.firstAddSchoolTextField setKeyboardType:UIKeyboardTypeAlphabet];
            [cell.firstAddSchoolTextField setReturnKeyType:UIReturnKeyNext];
            break;
        case 1:
            [cell.firstAddSchoolTextField setPlaceHolderTextLightGray:@"Email"];
            [cell.firstAddSchoolTextField setKeyboardType:UIKeyboardTypeURL];
            [cell.firstAddSchoolTextField setReturnKeyType:UIReturnKeyNext];
            break;
        case 2:
            [cell.firstAddSchoolTextField setPlaceHolderTextLightGray:@"Please enter message"];
            [cell.firstAddSchoolTextField setKeyboardType:UIKeyboardTypeAlphabet];
            [cell.firstAddSchoolTextField setReturnKeyType:UIReturnKeyDone];
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



#pragma mark-validation  methods
    
-(void)leftBarButtonAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)allTextFieldValidations {
    
    BOOL isVerified = NO;
    
    if ([modalObj.feedbackName length] == 0) {
        
        modalObj.strAlertMsg = BLANK_NAME;
        invalidRowNumber = 0;
        isErrorValid = YES;
    }
    else if ([modalObj.feedbackEmail length] == 0){
        
        modalObj.strAlertMsg = BLANK_EMAIL;
        invalidRowNumber = 1;
        isErrorValid = YES;
    }
//    else if ([PAFValidatesField validateUrl:modalObj.feedbackEmail]){
//        
//        modalObj.strAlertMsg = VALID_URL;
//        invalidRowNumber = 1;
//        isErrorValid = YES;
//    }
    else if ([PAFValidatesField validateEmailAddress:modalObj.feedbackEmail]){
        
        modalObj.strAlertMsg = VALID_EMAIL;
        invalidRowNumber = 1;
        isErrorValid = YES;
    }
    else if ([modalObj.feedbackMessage length] == 0){
        
        modalObj.strAlertMsg = BLANK_MESSAGE;
        invalidRowNumber = 2;
        isErrorValid = YES;
    }
    else{
        isVerified=YES;
        
    }
    [self.feedbackTableView reloadData];
    return isVerified;
}

- (IBAction)sendFeedbackButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    if ([self allTextFieldValidations]) {
        [self callAPIForActivityList];
    }
}

#pragma mark - API Method

-(void)callAPIForActivityList {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //NSMutableDictionary *prm = [NSUSERDEFAULT valueForKey:@"studentInformation"];
    [params setValue:@"http://172.16.16.149/sps" forKey:pSchoolURL];
    
    //  [params setValue:[prm valueForKey:@"schoolURL"] forKey:pSchoolURL];
    [params setValue:modalObj.feedbackEmail forKey:pStudentEmailID];
    [params setValue:modalObj.feedbackName forKey:cpNeme];
    [params setValue:modalObj.feedbackMessage forKey:cpMessage];
    
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiFeedback andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:2.0 andController:self.navigationController];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}


@end
