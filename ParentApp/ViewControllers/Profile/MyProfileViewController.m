//
//  MyProfileViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 06/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ProfileModalInfo.h"
#import "PAUtility.h"

@interface MyProfileViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    NSInteger          invalidRowNumber;
    ProfileModalInfo   *modalObj;
}

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UIView *profileHeaderView;

@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customInitialization];
    // Do any additional setup after loading the view from its nib.
}

#pragma MARK: Helper Methods

-(void)customInitialization {
    
    //Navigation Setup
    self.title = @"My Profile";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");
    
    self.profileTableView.estimatedRowHeight = 65.0;
    
    //Register Table View
    [self.profileTableView registerNib:[UINib nibWithNibName:@"MyProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyProfileTableViewCell"];
    [self.profileTableView registerNib:[UINib nibWithNibName:@"MyProfileSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyProfileSecondTableViewCell"];
    
    self.profileTableView.tableHeaderView = self.profileHeaderView;
    self.profileTableView.alwaysBounceVertical = NO;
    
    //For error
    invalidRowNumber = -1;
    
    [self callAPIForProfileInformation];
}

#pragma MARK : UITextfield Delegate Methods

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view layoutIfNeeded];
    
    switch (textField.tag) {
        case 500:
            modalObj.ciEmailID = textField.text;
            break;
        case 501:
            modalObj.ciPhoneNumber = textField.text;
            break;
        case 502:
            modalObj.ciAddress = textField.text;
            break;
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if(invalidRowNumber != -1) {
        
        invalidRowNumber = -1;
        [self.profileTableView reloadData];
        
        //For Again Cursor at error
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [textField becomeFirstResponder];
        });
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.returnKeyType==UIReturnKeyNext) {
        UITextField *next = [self.view viewWithTag:textField.tag+1];
        [next becomeFirstResponder];
    }
    else if (textField.returnKeyType==UIReturnKeyDone)
        [textField resignFirstResponder];

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
    {
        return NO;
    }
    
    switch (textField.tag) {
        case 500:
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            
            return (newLength > 64) ? NO : YES;
        } case 501:
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            
            NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            if (([string rangeOfCharacterFromSet:notDigits].location == NSNotFound ||  [string containsString:@","]))
                return (newLength > 21) ?NO : YES;
            else {
                return NO;
            }
        }case 502:
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            
            return (newLength > 300) ? NO : YES;
        }
            
            
        default:
            return YES;
    }
}

//#pragma mark-validation  methods
//
//-(BOOL)allTextFieldValidations {
//    
//    BOOL isVerified = NO;
//    
//    if ([TRIMSPACE(modalObj.ciEmailID)  length] == 0) {
//        modalObj.strAlertMsg = BLANK_EMAIL;
//        invalidRowNumber = 0;
//    }
//    else if ([PAFValidatesField validateEmailAddress:modalObj.ciEmailID]){
//        modalObj.strAlertMsg = VALID_EMAIL;
//        invalidRowNumber = 0;
//    }
//    else if ([TRIMSPACE(modalObj.ciPhoneNumber) length] == 0){
//        modalObj.strAlertMsg = BLANK_PHONE;
//        invalidRowNumber = 1;
//    }
//    else if ([TRIMSPACE(modalObj.ciAddress) length] == 0){
//        modalObj.strAlertMsg = BLANK_ADDRESS;
//        invalidRowNumber = 2;
//    }
//    else
//        isVerified = YES;
//
//    return isVerified;
//}

#pragma mark-validation  methods

-(BOOL)allTextFieldValidations {
    
    BOOL isVerified = NO;
    
    if ([TRIMSPACE(modalObj.ciEmailID)  length] == 0) {
        modalObj.strAlertMsg = BLANK_EMAIL;
        invalidRowNumber = 0;
    }
    else if ([PAFValidatesField validateEmailAddress:modalObj.ciEmailID]){
        modalObj.strAlertMsg = VALID_EMAIL;
        invalidRowNumber = 0;
    }
    else if ([TRIMSPACE(modalObj.ciPhoneNumber) length] == 0){
        modalObj.strAlertMsg = BLANK_PHONE;
        invalidRowNumber = 1;
    }else if ([TRIMSPACE(modalObj.ciPhoneNumber) length] < 21) {
        
        NSArray *phoneNumberArray = [TRIMSPACE(modalObj.ciPhoneNumber) componentsSeparatedByString:@","];
        
        NSString *firstNumber = [phoneNumberArray firstObject];
        
        if ([firstNumber length] != 10) {
            modalObj.strAlertMsg = VALID_PHONE;
            invalidRowNumber = 1;
        }else if ([phoneNumberArray count] == 2) {
            
            NSString *secondNumber = [phoneNumberArray objectAtIndex:1];
            
            if ([secondNumber length] != 10) {
                modalObj.strAlertMsg = VALID_PHONE;
                invalidRowNumber = 1;
            }else {
                isVerified = YES;
            }
        }else {
            isVerified = YES;
        }
    }
    else if ([TRIMSPACE(modalObj.ciAddress) length] == 0){
        modalObj.strAlertMsg = BLANK_ADDRESS;
        invalidRowNumber = 2;
    }
    else
        isVerified = YES;
    
    return isVerified;
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.row == 0 && indexPath.section == 3)
            return 140;
        else if (indexPath.section == 3 && indexPath.row == 4){
            return UITableViewAutomaticDimension;
        }
        else if(indexPath.section == 1) {
            
            if (invalidRowNumber == indexPath.row)
                return 65;
            else if (modalObj.userInteraction)
                return 45;
            else
                return UITableViewAutomaticDimension;
        }else
            return 45;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 8;
        case 1:
            return 3;
        case 2:
            return 6;
        case 3:
            return 5;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyProfileTableViewCell *profileDetailCell = (MyProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyProfileTableViewCell"];
    
    MyProfileSecondTableViewCell *teacherPhotoCell = (MyProfileSecondTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyProfileSecondTableViewCell"];

    profileDetailCell.editTextField.delegate = self;
    
    if (indexPath.section == 1) {
        profileDetailCell.editTextField.tag = indexPath.row + 500;
        profileDetailCell.editLabel.hidden = modalObj.userInteraction;
        profileDetailCell.editTextField.hidden = !modalObj.userInteraction;
    }else{
        profileDetailCell.editTextField.hidden = YES;
        profileDetailCell.editLabel.hidden = NO;
    }

    
    if (invalidRowNumber == indexPath.row && indexPath.section == 1) {
        
        profileDetailCell.errorLabel.hidden = NO;
        profileDetailCell.errorLabel.text = modalObj.strAlertMsg;
        
    } else {
        
        profileDetailCell.errorLabel.hidden = YES;
        profileDetailCell.topLabelConstraint.constant = 0;
        profileDetailCell.buttomLabelConstraint.constant = 0;
        profileDetailCell.topLabel.hidden = YES;
        profileDetailCell.buttomLabel.backgroundColor = RGBCOLOR(215, 215, 215, 1);
    }
    
    switch (indexPath.section) {
        case 0: {
            
            switch (indexPath.row) {
                case 0: {
                    [profileDetailCell.leftTitleLabel setText:@"Name"];
                    profileDetailCell.editLabel.text = modalObj.piStudentName;
                    profileDetailCell.topLabel.hidden = NO;
                    profileDetailCell.topLabelConstraint.constant = 2;
                }
                    break;
                case 1: {
                    [profileDetailCell.leftTitleLabel setText:@"Class"];
                    profileDetailCell.editLabel.text = modalObj.piClassName;
                }
                    break;
                case 2: {
                    [profileDetailCell.leftTitleLabel setText:@"Father Name"];
                    profileDetailCell.editLabel.text = modalObj.piFatherName;
                }
                    break;
                case 3: {
                    [profileDetailCell.leftTitleLabel setText:@"Mother Name"];
                    profileDetailCell.editLabel.text = modalObj.piMotherName;
                }
                    break;
                case 4: {
                    [profileDetailCell.leftTitleLabel setText:@"Admission No."];
                    profileDetailCell.editLabel.text = modalObj.piAddmissionNumber;
                }
                    break;
                case 5: {
                    [profileDetailCell.leftTitleLabel setText:@"Section"];
                    profileDetailCell.editLabel.text = modalObj.piSection;
                }
                    break;
                case 6: {
                    [profileDetailCell.leftTitleLabel setText:@"Blood Group"];
                    profileDetailCell.editLabel.text = modalObj.piBloodGroup;
                }
                    break;
                case 7: {
                    [profileDetailCell.leftTitleLabel setText:@"House"];
                    profileDetailCell.editLabel.text = modalObj.piHouse;
                    profileDetailCell.buttomLabel.backgroundColor = RGBCOLOR(83, 103, 197, 1);
                    profileDetailCell.buttomLabelConstraint.constant = 2;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            
            switch (indexPath.row) {
                case 0: {
                    [profileDetailCell.leftTitleLabel setText:@"Email *"];
                    [profileDetailCell.editTextField setText:modalObj.ciEmailID];
                    [profileDetailCell.editLabel setText:modalObj.ciEmailID];
                    [profileDetailCell.editTextField setKeyboardType:UIKeyboardTypeEmailAddress];
                    [profileDetailCell.editTextField setReturnKeyType:UIReturnKeyNext];
                    profileDetailCell.topLabel.hidden = NO;
                    profileDetailCell.topLabelConstraint.constant = 2;
                    
                }
                    break;
                case 1: {
                    [profileDetailCell.leftTitleLabel setText:@"Phone No. *"];
                    [profileDetailCell.editTextField setText:modalObj.ciPhoneNumber];
                    [profileDetailCell.editLabel setText:modalObj.ciPhoneNumber];
                    [profileDetailCell.editTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
                    [profileDetailCell.editTextField setReturnKeyType:UIReturnKeyNext];
                }
                    break;
                case 2: {
                    [profileDetailCell.leftTitleLabel setText:@"Address *"];
                    [profileDetailCell.editTextField setText:modalObj.ciAddress];
                    [profileDetailCell.editLabel setText:modalObj.ciAddress];
                    [profileDetailCell.editTextField setKeyboardType:UIKeyboardTypeEmailAddress];
                    [profileDetailCell.editTextField setReturnKeyType:UIReturnKeyDone];
                    profileDetailCell.buttomLabel.backgroundColor = RGBCOLOR(83, 103, 197, 1);
                    profileDetailCell.buttomLabelConstraint.constant = 2;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2: {
            
            switch (indexPath.row) {
                case 0: {
                    [profileDetailCell.leftTitleLabel setText:@"Pickup Route"];
                    profileDetailCell.editLabel.text = modalObj.tiPickRoute;
                    profileDetailCell.topLabel.hidden = NO;
                    profileDetailCell.topLabelConstraint.constant = 2;
                }
                    break;
                case 1: {
                    [profileDetailCell.leftTitleLabel setText:@"Pickup Time"];
                    profileDetailCell.editLabel.text = modalObj.tiPickupTime;
                }
                    break;
                case 2: {
                    [profileDetailCell.leftTitleLabel setText:@"Drop Route"];
                    profileDetailCell.editLabel.text = modalObj.tiDropRoute;
                }
                    break;
                case 3: {
                    [profileDetailCell.leftTitleLabel setText:@"Drop Time"];
                    profileDetailCell.editLabel.text = modalObj.tiDropTime;
                }
                    break;
                case 4: {
                    [profileDetailCell.leftTitleLabel setText:@"Transport In-charge"];
                    profileDetailCell.editLabel.text = modalObj.tiTransportIncharge;
                }
                    break;
                case 5: {
                    [profileDetailCell.leftTitleLabel setText:@"Bus No."];
                    profileDetailCell.editLabel.text = modalObj.tiBusNumber;
                    profileDetailCell.buttomLabel.backgroundColor = RGBCOLOR(83, 103, 197, 1);
                    profileDetailCell.buttomLabelConstraint.constant = 2;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3: {
            
            switch (indexPath.row) {
                case 0: {
                    if ([modalObj.ctTeacherImage  length]) {
                        NSData* data = [[NSData alloc] initWithBase64EncodedString:modalObj.ctTeacherImage options:0];
                        teacherPhotoCell.profileTeacherImageView.image = [UIImage imageWithData:data];
                    }else {
                        teacherPhotoCell.profileTeacherImageView.image = [UIImage imageNamed:@"dummy"];
                    }
                }
                    break;
                case 1: {
                    [profileDetailCell.leftTitleLabel setText:@"Class Teacher Name"];
                    profileDetailCell.editLabel.text = modalObj.classTeacherName;
                    profileDetailCell.topLabel.hidden = NO;
                    profileDetailCell.topLabelConstraint.constant = 5;
                }
                    break;
                case 2: {
                    [profileDetailCell.leftTitleLabel setText:@"Employee Code"];
                    profileDetailCell.editLabel.text = modalObj.ctEmployeeCode;
                }
                    break;
                case 3: {
                    [profileDetailCell.leftTitleLabel setText:@"Mobile Number"];
                    profileDetailCell.editLabel.text = modalObj.ctPhoneNumber;
                }
                    break;
                case 4: {
                    [profileDetailCell.leftTitleLabel setText:@"Email"];
                    profileDetailCell.editLabel.text = modalObj.ctEmailID;
                    profileDetailCell.buttomLabel.backgroundColor = RGBCOLOR(83, 103, 197, 1);
                    profileDetailCell.buttomLabelConstraint.constant = 2;
                }
                    break;
                default:
                    break;
            }
        }
            break;

        default:
            break;
    }
    
    if (indexPath.row == 0 && indexPath.section == 3)
            return teacherPhotoCell;
    
    return profileDetailCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 40.0)];
    [sectionHeaderView setBackgroundColor:AppDarkBlueColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, sectionHeaderView.frame.size.width-45, 20.0)];
    headerLabel.textColor = [UIColor whiteColor];
    [headerLabel setFont:[UIFont fontWithName:COMMON_APP_FONT size:16.0]];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(sectionHeaderView.frame.size.width-50, 8, 40, 24)];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont fontWithName:COMMON_APP_FONT size:14.0];
    [editButton setBackgroundColor:AppBlueColor];
    editButton.layer.cornerRadius = 5;
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(sectionHeaderView.frame.size.width-70-35, 8, 50, 24)];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:COMMON_APP_FONT size:14.0];
    [cancelButton setBackgroundColor:AppBlueColor];
    cancelButton.layer.cornerRadius = 5;

    if (modalObj.userInteraction) {
        
        [editButton setTitle:@"Save" forState:UIControlStateNormal];
        if (modalObj.userIsFirstTime) {

            modalObj.userIsFirstTime = !modalObj.userIsFirstTime;
            UITextField *text = (UITextField *)[self.view viewWithTag:500];
            [text becomeFirstResponder];
        }
    }
    else {
        [cancelButton setAlpha:0.5];
        [cancelButton setHidden:YES];
        [cancelButton setEnabled:NO];
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
    
    editButton.tag = section;
    cancelButton.tag = editButton.tag + 1000;
    
    [editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    switch (section) {
        case 0:
            headerLabel.text = @"Personal Information";
            [sectionHeaderView addSubview:headerLabel];
            break;
        case 1:
            headerLabel.text = @"Correspondence Information";
            [sectionHeaderView addSubview:editButton];
            [sectionHeaderView addSubview:cancelButton];
            [sectionHeaderView addSubview:headerLabel];
            break;
        case 2:
            headerLabel.text = @"Transport Information";
            [sectionHeaderView addSubview:headerLabel];
            break;
        case 3:
            headerLabel.text = @"Class Teacher Information";
            [sectionHeaderView addSubview:headerLabel];
            break;
        default:
            break;
    }
    
    return sectionHeaderView;
}

#pragma mark: UIButton Actions

- (IBAction)changePasswordButtonAction:(id)sender {
    
    PAChangePasswordVC *changePassword = [PAChangePasswordVC new];
    [self.navigationController pushViewController:changePassword animated:YES];
}

-(void)editButtonClicked:(UIButton*)sender
{
    [self.view endEditing:YES];

    UIButton *cancelButton = (UIButton *)[self.view viewWithTag:sender.tag+1000];
    
    if ([sender.titleLabel.text isEqualToString:@"Save"])
    {
        if ([self allTextFieldValidations])
            [self callAPIToUpdateProfileInformation];
        else
            [_profileTableView reloadData];
    }else {
        [cancelButton setAlpha:1];
        [cancelButton setHidden:NO];
        [cancelButton setEnabled:YES];

        modalObj.userInteraction = YES;
        modalObj.userIsFirstTime = YES;
        [_profileTableView reloadData];
    }
}

-(void)cancelButtonClicked:(UIButton *)sender {
    
    [self.view endEditing:YES];

     modalObj.ciAddress = modalObj.updatedAddress;
     modalObj.ciPhoneNumber =  modalObj.updatedPhoneNumber;
     modalObj.ciEmailID = modalObj.updatedEmailID;
    
    modalObj.userInteraction = NO;
    modalObj.userIsFirstTime = NO;
    invalidRowNumber = -1;
    
    [_profileTableView reloadData];
}

-(void)leftBarButtonAction:(UIButton*)sender
{
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
}

- (void)doneWithNumberPad
{
    UITextField *next = [self.view viewWithTag:502];
    [next becomeFirstResponder];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForProfileInformation {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiMyProfile andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            //For Presenting data instantly
            self.profileTableView.delegate = self;
            self.profileTableView.dataSource = self;
            self.changePasswordButton.hidden = NO;
            
            NSDictionary *studentDict = [[NSUSERDEFAULT valueForKey:@"studentInformation"] mutableCopy];
            getRoundedImageView(self.profileImageView);
            
            if ([[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] length]) {
                NSData* data = [[NSData alloc] initWithBase64EncodedString:[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] options:0];
                self.profileImageView.image = [UIImage imageWithData:data];
            }else
                self.profileImageView.image = [UIImage imageNamed:@"dummy"];
            
            modalObj = [ProfileModalInfo getProfileData:result];
            modalObj.userIsFirstTime = YES;
            
            [self.profileTableView reloadData];
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}

-(void)callAPIToUpdateProfileInformation {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:modalObj.ciEmailID forKey:pStudentEmailID];
    [params setValue:modalObj.ciPhoneNumber forKey:pCIPhoneNumber];
    [params setValue:modalObj.ciAddress forKey:pCIAddress];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiUpdateProfile andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {

        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            ///Code after getting response
            modalObj.userInteraction = NO;
            modalObj.userIsFirstTime = NO;
            invalidRowNumber = -1;

            modalObj.updatedAddress = modalObj.ciAddress;
            modalObj.updatedPhoneNumber = modalObj.ciPhoneNumber;
            modalObj.updatedEmailID = modalObj.ciEmailID;

            [_profileTableView reloadData];
        }else {
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
