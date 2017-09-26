//
//  PAAddSchoolViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PAAddSchoolViewController.h"
#import "PAUtility.h"

@interface PAAddSchoolViewController ()<UITextFieldDelegate> {
    PAUserInfo        *modalObj;

    NSInteger         invalidRowNumber;
    NSMutableArray    *addSchoolArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *addSchoolCollectionView;

@property (weak, nonatomic) IBOutlet UITableView *addSchoolTableView;

@property (strong, nonatomic) IBOutlet UIView *addSchoolHeaderView;

@property (strong, nonatomic) IBOutlet UIImageView *schoolURL;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonHieghtConstraint;


@end

@implementation PAAddSchoolViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self customInitialization];
}

#pragma MARK: Helper Methods

-(void)customInitialization{
    
    //Set Naviagtion Properties
    self.title = @"Add School";
    
    //Set BAck button icon for different cases
    if (_isFromLogin) {
        self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
        self.submitButton.hidden = NO;
        self.addButtonHieghtConstraint.constant = 62;
        
    }else{
        self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");
        self.submitButton.hidden = YES;
        self.addButtonHieghtConstraint.constant = 8;
    }

    //Register Table View Cell
    [self.addSchoolTableView registerNib:[UINib nibWithNibName:@"PAAddSchoolTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAAddSchoolTableViewCell"];
    self.addSchoolTableView.tableHeaderView = self.addSchoolHeaderView;
    self.addSchoolTableView.alwaysBounceVertical = NO;

    //Register collection cell
        [self.addSchoolCollectionView registerNib:[UINib nibWithNibName:@"AddSchoolCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AddSchoolCollectionViewCell"];

    //Alloc Modal Class
    modalObj = [PAUserInfo new];
    modalObj.selectedSchool = -1;
    invalidRowNumber = -1;

    addSchoolArray = [NSMutableArray new];
    
    [self.schoolURL setImage:[UIImage imageNamed:@"NGURU-01 (1)"]];

    [self loginChangeDataAccordingTOSelectSchool];
}

-(void)loginChangeDataAccordingTOSelectSchool {
    
    //Set School URL
    NSMutableArray *schoolArray = [NSUSERDEFAULT valueForKey:@"schoolInformation"];
    [addSchoolArray removeAllObjects];
    for (NSDictionary *schoolDict in schoolArray)
        [addSchoolArray addObject:[schoolDict objectForKeyNotNull:pSchoolNickName expectedObj:@""]];
}

#pragma MARK : UITextfield Delegate Methods

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view layoutIfNeeded];
    
    switch (textField.tag) {
        case 300:
            modalObj.addedSchoolURL = textField.text;
            break;
            
        case 301:
            modalObj.addedSchoolNickName = textField.text;
            break;
            
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if(invalidRowNumber != -1) {
        invalidRowNumber = -1;
        
        [self.addSchoolTableView reloadData];
        
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
    }
    else if (textField.returnKeyType == UIReturnKeyDone)
        [textField resignFirstResponder];

        return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
    {
        return NO;
    }
    
    switch (textField.tag) {
        case 300:
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            
            return (newLength > 100) ? NO : YES;
        } case 301:
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            
            return (newLength > 20) ? NO : YES;
        }
            
            
        default:
            return YES;
    }
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (invalidRowNumber == indexPath.row) {
        return 75;
    } else
        return 65;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PAAddSchoolTableViewCell *cell = (PAAddSchoolTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PAAddSchoolTableViewCell" forIndexPath:indexPath];
    cell.addSchoolTextField.delegate = self;
    
    cell.addSchoolTextField.tag = indexPath.row + 300;
    cell.errorLabel.tag = 400 +indexPath.row;
    
    if (invalidRowNumber == indexPath.row) {
        
        cell.errorLabel.hidden = NO;
        cell.errorLabel.text = modalObj.strAlertMsg;
        cell.addSchoolTextField.layer.borderWidth = 1;
        cell.addSchoolTextField.layer.borderColor =  AppRedColor.CGColor;
        
    } else {
        
        cell.errorLabel.hidden = YES;
        cell.addSchoolTextField.layer.borderWidth = 2;
        cell.addSchoolTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.addSchoolTextField.keyboardType = UIKeyboardTypeURL;
            if (modalObj.addedSchoolURL.length == 0){
            cell.addSchoolTextField.text = @"" ;
            [cell.addSchoolTextField setPlaceHolderTextLightGray: @"Add Your School URL *"];
            }
            else
            cell.addSchoolTextField.text = modalObj.addedSchoolURL;
            [cell.addSchoolTextField setPaddingIcon:[UIImage imageNamed:@"icon2"]];
            cell.addSchoolTextField.returnKeyType = UIReturnKeyNext;
            break;
        case 1:
            if (modalObj.addedSchoolNickName.length == 0){
                cell.addSchoolTextField.text = @"" ;
                [cell.addSchoolTextField setPlaceHolderTextLightGray:@"Nickname *"];
            }
            else
            cell.addSchoolTextField.text = modalObj.addedSchoolNickName;
            [cell.addSchoolTextField setPaddingIcon:[UIImage imageNamed:@"profile"]];
            cell.addSchoolTextField.returnKeyType = UIReturnKeyDone;
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [addSchoolArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *schoolNickName = [addSchoolArray objectAtIndex:indexPath.row];
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
    
    AddSchoolCollectionViewCell* cell = [self.addSchoolCollectionView  dequeueReusableCellWithReuseIdentifier:@"AddSchoolCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell.addSchoolRadioButton setTitle:[addSchoolArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == modalObj.selectedSchool)
        cell.addSchoolRadioButton.selected = YES;
    else
        cell.addSchoolRadioButton.selected = NO;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    
    modalObj.selectedSchool = indexPath.row;
    invalidRowNumber = -1;

    //Set School URL
    NSMutableArray *schoolArray = [NSUSERDEFAULT valueForKey:@"schoolInformation"];
    
    NSDictionary *studentInfoDict = [schoolArray objectAtIndex:modalObj.selectedSchool];
   // [self.schoolURL sd_setImageWithURL:[studentInfoDict objectForKeyNotNull:pSchoolPhoto expectedObj:@""] placeholderImage:[UIImage imageNamed:@"NGURU-01 (1)"]];
    
    if ([[studentInfoDict objectForKeyNotNull:pSchoolPhoto expectedObj:@""] length]) {
        
        NSData* data = [[NSData alloc] initWithBase64EncodedString:[studentInfoDict objectForKeyNotNull:pSchoolPhoto expectedObj:@""] options:0];
        self.schoolURL.image = [UIImage imageWithData:data];
    }else
        self.schoolURL.image = [UIImage imageNamed:@"NGURU-01 (1)"];

    modalObj.addedSchoolURL = [studentInfoDict objectForKeyNotNull:pSchoolURL expectedObj:@""];
    modalObj.addedSchoolNickName = [studentInfoDict objectForKeyNotNull:pSchoolNickName expectedObj:@""];

    [self.addSchoolTableView reloadData];
    [self.addSchoolCollectionView reloadData];
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

#pragma MARK: Button Actions


- (IBAction)submitButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    BOOL isAlreadyExist = NO;
    if (modalObj.selectedSchool == -1) {
        
        NSMutableArray *schoolArray = [[NSUSERDEFAULT valueForKey:@"schoolInformation"] mutableCopy];
     
        for (NSMutableDictionary *studentDetail  in schoolArray) {
           NSString *schoolURL =  [studentDetail valueForKey:pSchoolURL];
            if ([schoolURL isEqualToString:modalObj.addedSchoolURL]) {
                isAlreadyExist = YES;
                
                [OPRequestTimeOutView showWithMessage:@"The school URL you are trying to add, already exists." forTime:3.0 andController:self];
            }
        }
    }
    if ([self allTextFieldValidations] && !isAlreadyExist)
        [self callAPIAddSchool:NO];
    else
        [self.addSchoolTableView reloadData];
}

- (IBAction)addButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    BOOL isAlreadyExist = NO;
    if (modalObj.selectedSchool == -1) {
        
        NSMutableArray *schoolArray = [[NSUSERDEFAULT valueForKey:@"schoolInformation"] mutableCopy];
        
        for (NSMutableDictionary *studentDetail  in schoolArray) {
            NSString *schoolURL =  [studentDetail valueForKey:pSchoolURL];
            if ([schoolURL isEqualToString:modalObj.addedSchoolURL]) {
                isAlreadyExist = YES;
                
                [OPRequestTimeOutView showWithMessage:@"The school URL you are trying to add, already exists." forTime:3.0 andController:self];
            }
        }
    }
    
    if ([self allTextFieldValidations] && !isAlreadyExist)
        [self callAPIAddSchool:YES];
    else
        [self.addSchoolTableView reloadData];
}

-(void)leftBarButtonAction:(UIButton*)sender{
    
    if (_isFromLogin)
        [self.navigationController popViewControllerAnimated:YES];
    else
    {
        ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
        [itrSideMenu presentLeftMenuViewController];
    }
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIAddSchool :(BOOL)isComingFromAdd {
    
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

            NSMutableArray *schoolArray = [[NSUSERDEFAULT valueForKey:@"schoolInformation"] mutableCopy];
            
            if (modalObj.selectedSchool == -1)
                [schoolArray addObject:studentDetail];
            else
                [schoolArray replaceObjectAtIndex:modalObj.selectedSchool withObject:studentDetail];
            
            [NSUSERDEFAULT setValue:schoolArray forKey:@"schoolInformation"];
            [NSUSERDEFAULT synchronize];
            
            if (!isComingFromAdd) {
                if (modalObj.selectedSchool != -1)
                    [self.delegate getBackSelectedIndex:modalObj.selectedSchool];
                
                   [self.navigationController popViewControllerAnimated:YES];
            }else {
                modalObj.selectedSchool = -1;
                modalObj.addedSchoolURL = @"";
                modalObj.addedSchoolNickName = @"";
                
                [self loginChangeDataAccordingTOSelectSchool];
                
                [self.addSchoolTableView reloadData];
                [self.addSchoolCollectionView reloadData];
            }
        }else {
           // [OPRequestTimeOutView showWithMessage:@"Please enter correct URL." forTime:3.0 andController:self];

            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
