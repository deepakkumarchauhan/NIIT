//
//  BookReserveViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 17/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "Header.h"

@interface BookReserveViewController ()<UITextFieldDelegate> {
    
    LibraryModal   *modalObj;
    NSInteger      invalidRowNumber;
    NSMutableArray *reservationArray;
    BOOL relodeTable;
}

@property (weak, nonatomic) IBOutlet UIButton *bookButton;
@property (weak, nonatomic) IBOutlet UITableView *bookReserveTableView;

@end

@implementation BookReserveViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self customInitialization];
}

-(void)customInitialization{
    
    //Navigation Bar
    self.title = @"Reservation";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    
    //Register Cells
    [self.bookReserveTableView registerNib:[UINib nibWithNibName:@"PAFirstAddSchoolTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAFirstAddSchoolTableViewCell"];
    [self.bookReserveTableView setAlwaysBounceVertical:NO];
    
    invalidRowNumber = -1;
    //relodeTable = NO;
    
    self.bookButton.hidden = NO;
    
    reservationArray= [NSMutableArray array];
    //Alloc Modal Class
    modalObj = [LibraryModal new];
    
   // [self callAPIForGetBookDetail];
}

#pragma MARK : UITextfield Delegate Methods

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view layoutIfNeeded];
    
    switch (textField.tag) {
            
        case 800:
            modalObj.bookID = textField.text;
            break;
        case 801:
            modalObj.bookTitle = textField.text;
            break;
        case 802:
            modalObj.authorName = textField.text;
            break;
        case 803:
            modalObj.publisher = textField.text;
            break;
        case 804:
            modalObj.details = textField.text;
            break;
        case 805:
            modalObj.issueDate = textField.text;
            break;
        case 806:
            modalObj.returnDate = textField.text;
            break;
        case 807:
            modalObj.noOfBooks = textField.text;
            break;
            
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if(invalidRowNumber != -1) {
        invalidRowNumber = -1;
        [self.bookReserveTableView reloadData];
        
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [textField becomeFirstResponder];
        });
    }
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField {

    if(textField.returnKeyType == UIReturnKeyNext && textField.tag < 804) {
        UITextField *next = [self.view viewWithTag:textField.tag+1];
        [next becomeFirstResponder];
        
    }else if (textField.returnKeyType == UIReturnKeyNext && textField.tag == 804){
        [self.view endEditing:YES];
        UIButton *issueButton = [UIButton new];
        issueButton.tag = 5;
        [self pickerCommonAction:issueButton];
        
    }else if (textField.returnKeyType == UIReturnKeyDone)
        [textField resignFirstResponder];

    return YES;
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (invalidRowNumber == indexPath.row){
        return 65;
    }else
        return 55;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // if (relodeTable)
        return 5;
    //return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PAFirstAddSchoolTableViewCell *cell = (PAFirstAddSchoolTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PAFirstAddSchoolTableViewCell" forIndexPath:indexPath];
  //  LibraryModal *reservationInfo = [reservationArray objectAtIndex:0];
    cell.firstAddSchoolTextField.delegate = self;

    cell.errorLabel.tag = 400 +indexPath.row;
    cell.firstAddSchoolTextField.tag = indexPath.row +800;
    [cell.firstAddSchoolTextField setPaddingValue:10];
    
    if (invalidRowNumber == indexPath.row) {
        
        cell.errorLabel.hidden = NO;
        cell.errorLabel.text = modalObj.strAlertMsg;
        cell.firstAddSchoolTextField.layer.borderWidth = 1;
        cell.firstAddSchoolTextField.layer.borderColor =  AppRedColor.CGColor;
        
    } else {
        
        cell.errorLabel.hidden = YES;
        cell.firstAddSchoolTextField.layer.borderWidth = 2;
        cell.firstAddSchoolTextField.layer.borderColor = RGBCOLOR(238, 238, 238, 1).CGColor;
    }
    
    [cell.pickerButton setTag:indexPath.row];
    [cell.firstAddSchoolTextField setHidden:NO];
    [cell.pickerButton setHidden:YES];
    [cell.firstAddSchoolTextField setKeyboardType:UIKeyboardTypeDefault];
    [cell.firstAddSchoolTextField setReturnKeyType:UIReturnKeyNext];
    [cell.pickerButton addTarget:self action:@selector(pickerCommonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.firstAddSchoolTextField.userInteractionEnabled = NO;
    cell.pickerButton.userInteractionEnabled = NO;

    switch (indexPath.row) {
 
        case 0: {
            [cell.firstAddSchoolTextField setPlaceHolderTextLightGray:@"Book Name *"];
            cell.firstAddSchoolTextField.text = self.libraryInfo.strBookName;
        }
            break;
        case 1: {
            [cell.firstAddSchoolTextField setPlaceHolderTextLightGray:@"Author Name *"];
            cell.firstAddSchoolTextField.text = self.libraryInfo.authorName;
        }
            break;
        case 2: {
            [cell.firstAddSchoolTextField setPlaceHolderTextLightGray:@"Publisher *"];
            cell.firstAddSchoolTextField.text = self.libraryInfo.publisherName;
        }
            break;
//        case 4: {
//            [cell.firstAddSchoolTextField setPlaceHolderTextLightGray:@"Details *"];
//            cell.firstAddSchoolTextField.text = reservationInfo.details;
//        }
//            break;
        case 3: {
            [cell.firstAddSchoolTextField setPlaceHolderTextLightGray:@"Issue Date *"];
            [cell.firstAddSchoolTextField setText:self.libraryInfo.issueDate];
            [cell.pickerButton setHidden:NO];
        }
            break;
        case 4: {
            [cell.firstAddSchoolTextField setPlaceHolderTextLightGray:@"Return Date *"];
            [cell.firstAddSchoolTextField setText:self.libraryInfo.returnDate];
            [cell.pickerButton setHidden:NO];
        }
            break;
//             case 7: {
//            [cell.firstAddSchoolTextField setPlaceHolderTextLightGray:@"No. of Books *"];
//            [cell.firstAddSchoolTextField setText:reservationInfo.noOfBooks];
//            [cell.pickerButton setHidden:NO];
//        }
//            break;
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

-(BOOL)allTextFieldValidations {
    
    BOOL isVerified = NO;
    
    modalObj = [reservationArray objectAtIndex:0];
    if ([modalObj.bookID length] == 0) {
        
        modalObj.strAlertMsg = BLANK_BOOKID;
        invalidRowNumber = 0;
    }
    else if ([modalObj.strBookName length] == 0){
        
        modalObj.strAlertMsg = BLANK_BOOKTITLE;
        invalidRowNumber = 1;
    }
    else if ([modalObj.authorName length] == 0){
        
        modalObj.strAlertMsg = BLANK_AUTHOR_NAME;
        invalidRowNumber = 2;
    }
    else if ([modalObj.publisher length] == 0){
        
        modalObj.strAlertMsg = BLANK_PUBLISHER;
        invalidRowNumber = 3;
    }
//    else if ([modalObj.details length] == 0){
//        
//        modalObj.strAlertMsg = BLANK_DETAILS;
//        invalidRowNumber = 4;
//    }
    else if ([modalObj.issueDate length] == 0){
        
        modalObj.strAlertMsg = BLANK_ISSUE_DATE;
        invalidRowNumber = 5;
    }
    else if ([modalObj.returnDate length] == 0){
        
        modalObj.strAlertMsg = BLANK_RETURN_DATE;
        invalidRowNumber = 6;
    }
//    else if ([modalObj.noOfBooks length] == 0){
//        
//        modalObj.strAlertMsg = BLANK_NO_OF_BOOKS;
//        invalidRowNumber = 7;
//    }
    else
        isVerified = YES;
        
    return isVerified;
}

#pragma MARK: UIbutton Actions

-(void)pickerCommonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 5:
        {
            [[DatePickerManager dateManager] showDatePicker:self completionBlock:^(NSDate *date) {
                modalObj.issueDate = [PAUtility getStringFromDate:date];
                [self.bookReserveTableView reloadData];
            }];
        }
            break;
        case 6:
        {
            [[DatePickerManager dateManager] showDatePicker:self completionBlock:^(NSDate *date) {
                modalObj.returnDate = [PAUtility getStringFromDate:date];
                [self.bookReserveTableView reloadData];
            }];
        }
            break;
        case 7:
        {
            [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:@[@"1",@"2", @"3", @"4",@"5"] andselectedIndex:0 AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
                modalObj.noOfBooks = selectedText;
                [self.bookReserveTableView reloadData];
            }];
        }
            break;
        default:
            break;
    }
}

- (IBAction)bookButtonAction:(id)sender {
    
    [self.view endEditing:YES];
//    
//    if ([self allTextFieldValidations]) {
       // [self callAPIToBook];
//    }else
        [self.bookReserveTableView reloadData];
}

-(void)leftBarButtonAction:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark : Memory Management

- (void)didReceiveMemoryWarning {
[super didReceiveMemoryWarning];
// Dispose of any resources that can be recreated.
}


#pragma mark - API Method

//-(void)callAPIToBook {
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    
//    [params setValue:_libraryInfo.bookID forKey:pBookId];
//    
//    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiReservation andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
//        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
//
//            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
//            
//            [self.delegate callLibraryDetailApi];
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }else {
//            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
//        }
//    }];
//}
//

-(void)callAPIForGetBookDetail {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *prm = [NSUSERDEFAULT valueForKey:@"studentInformation"];
    [params setValue:@"http://172.16.16.149/sps_app" forKey:pSchoolURL];
    
    //   [params setValue:[prm valueForKey:@"schoolURL"] forKey:pSchoolURL];
    [params setValue:[prm valueForKey:@"userID"] forKey:cpUserID];
    [params setValue:[prm valueForKey:@"schoolID"] forKey:cpSchoolID];
    [params setValue:[prm valueForKey:@"studentID"] forKey:cpStudentID];
    [params setValue:[prm valueForKey:@"sessionID"] forKey:cpSessionID];
    [params setValue:_libraryInfo.bookID forKey:pBookId];
    
    [params setValue:_libraryInfo.strAccessionNumber forKey:pAccessionNo];
    [params setValue:_libraryInfo.issueReturnId forKey:pIssueReturnId];
    [params setValue:@"1" forKey:cpType];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiLibraryGetDetail andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            
            NSArray *bookIssueArray = [result objectForKeyNotNull:pLibrary expectedObj:[NSArray new]];
            
            for (NSMutableDictionary * bookDict in bookIssueArray) {
                [reservationArray addObject:[LibraryModal parseLibraryInfo:bookDict]];
                relodeTable = YES;
                self.bookButton.hidden = NO;
            }
            [self.bookReserveTableView reloadData];
            
            if ([reservationArray count] == 0)
                [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}



-(void)setLabelBetweenTable:(NSString *)displayMessage {
    
    UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bookReserveTableView.bounds.size.width,  self.bookReserveTableView.bounds.size.height)];
    noDataLabel.text             = displayMessage;
    noDataLabel.textColor        = [UIColor darkGrayColor];
    noDataLabel.textAlignment    = NSTextAlignmentCenter;
    self.bookReserveTableView.backgroundView = noDataLabel;
}


@end
