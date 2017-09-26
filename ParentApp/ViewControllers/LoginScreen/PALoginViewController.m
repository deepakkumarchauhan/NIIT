
//
//  PALoginViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PALoginViewController.h"
#import "PAPasswordErrorViewController.h"
#import "PAUserInfo.h"
#import "PAUtility.h"

@interface PALoginViewController ()<UITextFieldDelegate>{
    PAUserInfo   *modalObj1;

    NSInteger    invalidRowNumber;
    NSMutableArray *savedSchoolArray;
}

@property (weak, nonatomic) IBOutlet UITableView *loginTableView;
@property (strong, nonatomic) IBOutlet UIView *loginHeaderView;
@property (weak, nonatomic) IBOutlet UICollectionView *schoolNickNameCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (strong, nonatomic) IBOutlet UIImageView *schoolURL;

@end

@implementation PALoginViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    
    [self customInitialization];
}

#pragma MARK: Helper Methods

-(void)customInitialization{
    
    //Set Navigation Properties
    self.title = @"Login";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"");

    //Register TableView
    [self.loginTableView registerNib:[UINib nibWithNibName:@"PALoginTableViewCell" bundle:nil] forCellReuseIdentifier:@"PALoginTableViewCell"];
    self.loginTableView.tableHeaderView = self.loginHeaderView;
    self.loginTableView.alwaysBounceVertical = NO;

    //Register collection cell
    [self.schoolNickNameCollectionView registerNib:[UINib nibWithNibName:@"AddSchoolCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AddSchoolCollectionViewCell"];
    
    //Alloc Modal Class
    modalObj1 = [[PAUserInfo alloc]init];
    modalObj1.selectedSchool = 0;
    invalidRowNumber = -1;

    savedSchoolArray = [[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    if (self.navigationController.hidesBarsWhenKeyboardAppears) {
        self.navigationController.hidesBarsWhenKeyboardAppears = NO;
        [self.navigationController pushViewController:[APPDELEGATE setMenu] animated:NO];
    }else {
        //Set naviagtion properties
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationItem.hidesBackButton = YES;
        
        [self loginChangeDataAccordingTOSelectSchool];
    }
}

-(void)loginChangeDataAccordingTOSelectSchool {
    
    //Set School URL
    NSMutableArray *schoolArray = [NSUSERDEFAULT valueForKey:@"schoolInformation"];
    
    NSDictionary *studentInfoDict = [schoolArray objectAtIndex:modalObj1.selectedSchool];
//    [self.schoolURL sd_setImageWithURL:[studentInfoDict objectForKeyNotNull:pSchoolPhoto expectedObj:@""] placeholderImage:[UIImage imageNamed:@"NGURU-01 (1)"]];
//    
    if ([[studentInfoDict objectForKeyNotNull:pSchoolPhoto expectedObj:@""] length]) {
        
        NSData* data = [[NSData alloc] initWithBase64EncodedString:[studentInfoDict objectForKeyNotNull:pSchoolPhoto expectedObj:@""] options:0];
        self.schoolURL.image = [UIImage imageWithData:data];
    }else
        self.schoolURL.image = [UIImage imageNamed:@"NGURU-01 (1)"];


    modalObj1.addedSchoolURL = [studentInfoDict objectForKeyNotNull:pSchoolURL expectedObj:@""];
    
    //For clearing password field after logout
    modalObj1.password = @"";
    [self.loginTableView reloadData];
    
    [savedSchoolArray removeAllObjects];
    for (NSDictionary *schoolDict in schoolArray)
        [savedSchoolArray addObject:[schoolDict objectForKeyNotNull:pSchoolNickName expectedObj:@""]];
    
    [self.schoolNickNameCollectionView reloadData];
}

#pragma MARK : UITextfield Delegate Methods

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view layoutIfNeeded];
    
    switch (textField.tag) {
        case 200:
            modalObj1.userName = textField.text;
            break;
            
        case 201:
            modalObj1.password = textField.text;
            break;
            
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    

    if(invalidRowNumber != -1) {
        
        invalidRowNumber = -1;
        [self.loginTableView reloadData];
        
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [textField becomeFirstResponder];
        });
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    if(range.length + range.location > textField.text.length  && textField.tag == 201)
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
    
    switch (textField.tag) {
        case 200:
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            
            return (newLength > 50) ? NO : YES;
        } case 201:
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            
            return (newLength > 32) ? NO : YES;
        }
            
            
        default:
            return YES;
    }
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if(textField.returnKeyType == UIReturnKeyNext) {
        UITextField *next = [self.view viewWithTag:textField.tag+1];
        
        [next becomeFirstResponder];
    }
    else if (textField.returnKeyType == UIReturnKeyDone)
        [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (invalidRowNumber == indexPath.row)
        return 75;
    else
        return 65;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PALoginTableViewCell *cell = (PALoginTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PALoginTableViewCell" forIndexPath:indexPath];
    cell.loginTextField.delegate = self;
    
    cell.loginTextField.tag = indexPath.row +200;
    cell.errorLabel.tag = 400 +indexPath.row;
    
    if (invalidRowNumber == indexPath.row) {
        cell.errorLabel.hidden = NO;
        cell.errorLabel.text = modalObj1.strAlertMsg;
        cell.loginTextField.layer.borderWidth = 1;
        cell.loginTextField.layer.borderColor =  AppRedColor.CGColor;
        
    } else {
        cell.errorLabel.hidden = YES;
        cell.loginTextField.layer.borderWidth = 2;
        cell.loginTextField.layer.borderColor= [UIColor whiteColor].CGColor;
    }

    switch (indexPath.row) {
        case 0:
            [cell.loginTextField setPaddingIcon:[UIImage imageNamed:@"profile"]];
            [cell.loginTextField setPlaceHolderTextLightGray: @"Username *"];
            cell.loginTextField.text = modalObj1.userName;
            cell.loginTextField.returnKeyType = UIReturnKeyNext;
            cell.loginTextField.secureTextEntry = NO;
            
            break;
        case 1:
            [cell.loginTextField setPaddingIcon:[UIImage imageNamed:@"lock"]];
            [cell.loginTextField setPlaceHolderTextLightGray:@"Password *"];
            cell.loginTextField.text = modalObj1.password;
            cell.loginTextField.returnKeyType = UIReturnKeyDone;
            cell.loginTextField.secureTextEntry = YES;
            
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


#pragma mark: UICollectionView Delegate and Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [savedSchoolArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *schoolNickName = [savedSchoolArray objectAtIndex:indexPath.row];
    CGSize calCulateSizze = [schoolNickName sizeWithAttributes:NULL];
    //NSLog(@"%f     %f",calCulateSizze.height, calCulateSizze.width);
    calCulateSizze.width = calCulateSizze.width+70;
    calCulateSizze.height = 35;
    
    return calCulateSizze;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AddSchoolCollectionViewCell* cell = [self.schoolNickNameCollectionView  dequeueReusableCellWithReuseIdentifier:@"AddSchoolCollectionViewCell" forIndexPath:indexPath];

    [cell.addSchoolRadioButton setTitle:[savedSchoolArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == modalObj1.selectedSchool)
        cell.addSchoolRadioButton.selected = YES;
    else
        cell.addSchoolRadioButton.selected = NO;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    modalObj1.selectedSchool = indexPath.row;
    
    //Set School URL
    NSMutableArray *schoolArray = [NSUSERDEFAULT valueForKey:@"schoolInformation"];

    NSDictionary *studentInfoDict = [schoolArray objectAtIndex:modalObj1.selectedSchool];
    //[self.schoolURL sd_setImageWithURL:[studentInfoDict objectForKeyNotNull:pSchoolPhoto expectedObj:@""] placeholderImage:[UIImage imageNamed:@"NGURU-01 (1)"]];
    
    if ([[studentInfoDict objectForKeyNotNull:pSchoolPhoto expectedObj:@""] length]) {
        
        NSData* data = [[NSData alloc] initWithBase64EncodedString:[studentInfoDict objectForKeyNotNull:pSchoolPhoto expectedObj:@""] options:0];
        self.schoolURL.image = [UIImage imageWithData:data];
    }else
        self.schoolURL.image = [UIImage imageNamed:@"NGURU-01 (1)"];

    
    modalObj1.addedSchoolURL = [studentInfoDict objectForKeyNotNull:pSchoolURL expectedObj:@""];

    [self.schoolNickNameCollectionView reloadData];
}

#pragma mark-validation  methods

-(BOOL)allTextFieldValidations {
    
    BOOL isVerified = NO;
   // prefix = [fullString substringToIndex:3];
    NSString *string = modalObj1.password;

    unichar firstChar = 0;
    unichar lastChar = 0;
    
    if (modalObj1.password.length) {
        firstChar = [[modalObj1.password uppercaseString] characterAtIndex:0];
        lastChar = [[modalObj1.password uppercaseString] characterAtIndex:modalObj1.password.length-1];
    }

    if ([modalObj1.userName length] == 0) {

        modalObj1.strAlertMsg = BLANK_USERNAME;
        invalidRowNumber = 0;
    }
    else if ([PAFValidatesField validateUsername:modalObj1.userName]){

        modalObj1.strAlertMsg = VALID_USERNAME;
        invalidRowNumber = 0;
    }
    else if ([modalObj1.password length] == 0) {

        modalObj1.strAlertMsg = BLANK_PASSWORD;
        invalidRowNumber = 1;
        
    }
//    else if ([string containsString:modalObj1.userName]) {
//        
//        modalObj1.strAlertMsg = VALID_ALL_PASSWORD;
//        invalidRowNumber = 1;
//        
//    }
//    else if ([modalObj1.password length]<8) {
//        
//        modalObj1.strAlertMsg = VALID_PASSWORD_LENGTH;
//        invalidRowNumber = 1;
//        
//    }
//    else if ([PAFValidatesField validatePassword:modalObj1.password]) {
//        
//        modalObj1.strAlertMsg = VALID_ALL_PASSWORD;
//        invalidRowNumber = 1;
//        
//    }else if (!((firstChar >= 'A' && firstChar <= 'Z') && (lastChar >= 'A' && lastChar <= 'Z'))) {
//        
//        modalObj1.strAlertMsg = VALID_ALL_PASSWORD;
//        invalidRowNumber = 1;
//        
//    }
    else
        isVerified = YES;
    
    return isVerified;
}

#pragma MARK: Button Actions

- (IBAction)loginButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self allTextFieldValidations])
        [self callAPISchoolLogin];
    else
        [self.loginTableView reloadData];
}

- (IBAction)addSchoolButtonAction:(id)sender {
    
    [self.view endEditing:YES];

    PAAddSchoolViewController *addSchoolVCObj = [[PAAddSchoolViewController alloc]initWithNibName:@"PAAddSchoolViewController" bundle:nil];
    addSchoolVCObj.isFromLogin = YES;
    addSchoolVCObj.delegate = self;

    [self.navigationController pushViewController:addSchoolVCObj animated:YES];
}

-(void)leftBarButtonAction:(UIButton*)sender {

}

- (IBAction)helpButtonAction:(id)sender {
    
    PAPasswordErrorViewController *passVC = [[PAPasswordErrorViewController alloc]initWithNibName:@"PAPasswordErrorViewController" bundle:nil];
    passVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:passVC animated:NO completion:nil];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPISchoolLogin {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:modalObj1.addedSchoolURL forKey:pSchoolURL];
    [params setValue:modalObj1.userName forKey:pUsername];
    [params setValue:modalObj1.password forKey:pPassword];
    [APPDELEGATE setSchoolURL:modalObj1.addedSchoolURL];

    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiLogin andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            NSDictionary *studentDict = [result objectForKeyNotNull:pStudentProfile expectedObj:[NSDictionary dictionary]];
            NSMutableDictionary *studentDetail = [NSMutableDictionary dictionary];
            
            [studentDetail setValue:modalObj1.userName forKey:@"userName"];
            
            [studentDetail setValue:[studentDict objectForKeyNotNull:@"classTeacherName" expectedObj:@""] forKey:@"teacherName"];
            [studentDetail setValue:[studentDict objectForKeyNotNull:@"classTeacherId" expectedObj:@""] forKey:@"teacherId"];

            [studentDetail setValue:[studentDict objectForKeyNotNull:@"notificationStatus" expectedObj:@""] forKey:@"notificationStatus"];
            [studentDetail setValue:[studentDict objectForKeyNotNull:@"classTeacherPhoto" expectedObj:@""] forKey:@"teacherPhoto"];
            
            [studentDetail setValue:[result objectForKeyNotNull:cpUserID expectedObj:@""] forKey:cpUserID];
            [studentDetail setValue:[result objectForKeyNotNull:cpSchoolID expectedObj:@""] forKey:cpSchoolID];
            [studentDetail setValue:[studentDict objectForKeyNotNull:cpSessionID expectedObj:@""] forKey:cpSessionID];
            [studentDetail setValue:[studentDict objectForKeyNotNull:cpStudentID expectedObj:@""] forKey:cpStudentID];
            [studentDetail setValue:[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] forKey:pPIStudentPicture];
            [studentDetail setValue:[studentDict objectForKeyNotNull:pSessionStartDate expectedObj:@""] forKey:pSessionStartDate];
            [studentDetail setValue:[studentDict objectForKeyNotNull:pSessionEndDate expectedObj:@""] forKey:pSessionEndDate];

            [studentDetail setValue:[studentDict objectForKeyNotNull:pPIStudentName expectedObj:@""] forKey:pPIStudentName];
            [studentDetail setValue:modalObj1.addedSchoolURL forKey:pSchoolURL];

            [NSUSERDEFAULT setValue:studentDetail forKey:@"studentInformation"];
            [NSUSERDEFAULT synchronize];
            
            [self.navigationController pushViewController:[APPDELEGATE setMenu] animated:YES];

        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}

-(void)getBackSelectedIndex:(NSInteger)sleectedIndex {
    modalObj1.selectedSchool = sleectedIndex;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
