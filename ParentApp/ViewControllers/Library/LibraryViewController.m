//
//  LibraryViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 15/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "Header.h"

static NSString *pOneLabel = @"oneLabel";
static NSString *pOneDetailLabel = @"oneDetailLabel";
static NSString *pTwoLabel = @"twoLabel";
static NSString *pTwoDetailLabel = @"twoDetailLabel";
static NSString *pThreeLabel = @"threeLabel";
static NSString *pThreeDetailLabel = @"threeDetailLabel";
static NSString *pFourLabel = @"fourLabel";
static NSString *pFourDetailLabel = @"fourDetailLabel";
static NSString *pImage = @"image";

@interface LibraryViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,reserveProtocol> {
    
    NSInteger selectedIndex;
    NSDictionary *dataDict;
    LibraryModal *libraryInfo;
    Pagination * bookDetailPagination;
    Pagination * issueBookPagination;
    Pagination * reservePagination;
    NSString *bookName;
    NSString *authorName;
    NSString *keyword;
    int searchType;
    UILabel *notificationCount;
   // UILabel *noDataLabel;
}

@property (weak, nonatomic) IBOutlet UITableView *libraryTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *segmentView;

@property (weak, nonatomic) IBOutlet UIButton *tabHistory;
@property (weak, nonatomic) IBOutlet UIButton *tabReserve;
@property (weak, nonatomic) IBOutlet UIButton *tabIssuedBooks;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

@property (strong, nonatomic) NSMutableArray            *dataSourceArrayForBooks;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@property (weak, nonatomic) IBOutlet UITextField *bookNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *editorTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchFirstButton;

@property (weak, nonatomic) IBOutlet UIButton *searchSecondButton;
@property (weak, nonatomic) IBOutlet UIButton *searchThirdButton;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@property (weak, nonatomic) IBOutlet UIView *firstSearchView;
@property (weak, nonatomic) IBOutlet UIView *secondSearchView;
@property (weak, nonatomic) IBOutlet UIView *thirdSearchView;

@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@end

@implementation LibraryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self customInitialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)customInitialization{
    
    //Navigation Bar
    self.title = @"Library";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");
    
    self.seeMoreButton.hidden = YES;
    self.searchBar.hidden = YES;
    //Set Segement Item color and layout
    selectedIndex = 1;
    getCornerView(self.segmentView, 18.0f);
    [self.tabIssuedBooks setBackgroundColor:RGBCOLOR(51, 189, 250, 1)];
    [self.tabHistory setBackgroundColor:[UIColor clearColor]];
    [self.tabReserve setBackgroundColor:[UIColor clearColor]];
    
    //Allocate Dummy Data
    self.dataSourceArrayForBooks = [NSMutableArray array];

    // Alloc Modal Class
    libraryInfo = [[LibraryModal alloc]init];
    bookDetailPagination = [[Pagination alloc]init];
    issueBookPagination = [[Pagination alloc]init];
    reservePagination = [[Pagination alloc]init];
    issueBookPagination.pageNumber = 1;
    
    
    // Set Search TextField and Search Button Corner
    self.firstSearchView.layer.cornerRadius = 5.0;
    self.secondSearchView.layer.cornerRadius = 5.0;
    self.thirdSearchView.layer.cornerRadius = 5.0;
    
    self.firstSearchView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.secondSearchView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.thirdSearchView.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    self.firstSearchView.layer.borderWidth = 1.0;
    self.secondSearchView.layer.borderWidth = 1.0;
    self.thirdSearchView.layer.borderWidth = 1.0;
    
    self.searchFirstButton.layer.cornerRadius = 5.0;
    self.searchSecondButton.layer.cornerRadius = 5.0;
    self.searchThirdButton.layer.cornerRadius = 5.0;

    // Add TableView Header
    self.libraryTableView.tableHeaderView = nil;

    //Register Cells
    [self.libraryTableView registerNib:[UINib nibWithNibName:@"LibraryTableViewCell" bundle:nil] forCellReuseIdentifier:@"LibraryTableViewCell"];
    self.libraryTableView.estimatedRowHeight = 120.0;
    [self.libraryTableView setAlwaysBounceVertical:NO];
    
    [self callAPIForGetIssueBookList:issueBookPagination];
    }


#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataSourceArrayForBooks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LibraryTableViewCell *cell = (LibraryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LibraryTableViewCell" forIndexPath:indexPath];
    
    libraryInfo = [self.dataSourceArrayForBooks objectAtIndex:indexPath.row];

    if (selectedIndex == 0) {
    cell.oneLabel.text = @"Accession No.";
    cell.twoLabel.text = @"Book Name";
    cell.threeLabel.text = @"Issue Date";
    cell.fourLabel.text = @"Return Date";
    cell.bookButton.hidden = YES;
    cell.oneDetailLabel.text = libraryInfo.strAccessionNumber;
    cell.twoDetailLabel.text = libraryInfo.strBookName;
    cell.threeDetailLabel.text = libraryInfo.issueDate;
    cell.fourDetailLabel.text = libraryInfo.returnDate;
    }
    else if (selectedIndex == 1) {
        cell.oneLabel.text = @"Accession No.";
        cell.twoLabel.text = @"Book Name";
        cell.threeLabel.text = @"Issue Date";
        cell.fourLabel.text = @"Due Date";
        cell.bookButton.hidden = YES;

        cell.oneDetailLabel.text = libraryInfo.strAccessionNumber;
        cell.twoDetailLabel.text = libraryInfo.strBookName;
        cell.threeDetailLabel.text = libraryInfo.issueDate;
        cell.fourDetailLabel.text = libraryInfo.dueDate;
    }
    else {
        cell.oneLabel.text = @"Book Name";
        cell.twoLabel.text = @"Author Name";
        cell.threeLabel.text = @"Status";
        cell.fourLabel.text = @"Publisher Name";
        cell.bookButton.hidden = NO;

        cell.oneDetailLabel.text = libraryInfo.strBookName;
        cell.twoDetailLabel.text = libraryInfo.authorName;
        cell.threeDetailLabel.text = libraryInfo.status;
        cell.fourDetailLabel.text = libraryInfo.publisherName;
        
        if ([libraryInfo.status isEqualToString:@"Available"]){
            
            if ([libraryInfo.isBooked isEqualToString:@"0"]) {
                cell.bookButton.userInteractionEnabled = YES;
                cell.bookButton.alpha = 1.0;
            }
            else {
                cell.bookButton.userInteractionEnabled = NO;
                cell.bookButton.alpha = 0.5;
            }
        }
        else {
            cell.bookButton.userInteractionEnabled = NO;
            cell.bookButton.alpha = 0.5;
        }

    }
    
    cell.bookButton.tag = indexPath.row;
    [cell.bookButton addTarget:self action:@selector(bookButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(indexPath.row%2 == 0) {
        cell.bookImageView.image = [UIImage imageNamed:@"blue"];
        cell.backgroundColor = [UIColor whiteColor];
    }
    else {
        cell.bookImageView.image = [UIImage imageNamed:@"red"];
        cell.backgroundColor = RGBCOLOR(238, 238, 238, 1);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        [self.view endEditing:YES];
        BookDetailsViewController *detailsVCObj = [[BookDetailsViewController alloc]initWithNibName:@"BookDetailsViewController" bundle:nil];
        detailsVCObj.delegate = self;
        libraryInfo = [self.dataSourceArrayForBooks objectAtIndex:indexPath.row];
    if (selectedIndex == 2)
        detailsVCObj.isReserve = YES;
    else
        detailsVCObj.isReserve = NO;

        detailsVCObj.libraryInfo = libraryInfo;
        detailsVCObj.bookNumber =  [NSString stringWithFormat:@"%ld",(long)(indexPath.row%2)];
        [self.navigationController pushViewController:detailsVCObj animated:YES];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 600:
            bookName = textField.text;
            break;
        case 601:
            keyword = textField.text;
            break;
        case 602:
            authorName = textField.text;
            break;
            
        default:
            break;
    }
}



#pragma MARK: UIButton Action

-(void)leftBarButtonAction:(UIButton*)sender {
    
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
}

- (IBAction)segmentBtnAction:(UIButton *)sender {
    
    [self.tabHistory setBackgroundColor:[UIColor clearColor]];
    [self.tabIssuedBooks setBackgroundColor:[UIColor clearColor]];
    [self.tabReserve setBackgroundColor:[UIColor clearColor]];
    [self.dataSourceArrayForBooks removeAllObjects];
    self.seeMoreButton.hidden = YES;
    self.noDataLabel.hidden = YES;
    self.bookNameTextField.text = @"";
    self.editorTextField.text = @"";
    self.authorTextField.text = @"";
    bookName = @"";
    keyword = @"";
    authorName = @"";

    if(sender.tag == 1)
    {
        self.navigationItem.rightBarButtonItem = nil;
        selectedIndex = 0;
        self.libraryTableView.tableHeaderView = nil;
        _searchBar.text = @"";
        bookDetailPagination = [[Pagination alloc]init];
        bookDetailPagination.pageNumber = 1;
        [self.view endEditing:YES];
        [self.tabHistory setBackgroundColor:RGBCOLOR(51, 189, 250, 1)];
        [self.tableViewTopConstraint setConstant:0];
        [self callAPIForGetBookHistoryList:bookDetailPagination];
    }
    else if (sender.tag == 2)
    {
        self.navigationItem.rightBarButtonItem = nil;
        self.libraryTableView.tableHeaderView = nil;
        selectedIndex = 1;
        _searchBar.text = @"";
        issueBookPagination = [[Pagination alloc]init];
        issueBookPagination.pageNumber = 1;
        [self.view endEditing:YES];
        [self.tabIssuedBooks setBackgroundColor:RGBCOLOR(51, 189, 250, 1)];
        [self.tableViewTopConstraint setConstant:0];
        [self callAPIForGetIssueBookList:issueBookPagination];
    }
    else if (sender.tag == 3)
    {
        self.navigationItem.rightBarButtonItem = [self rightBarButtonForController:self andImageStr:@"search"];

        self.libraryTableView.tableHeaderView = self.tableHeaderView;
        selectedIndex = 2;
        [self.view endEditing:YES];
        [self.tabReserve setBackgroundColor:RGBCOLOR(51, 189, 250, 1)];
        [self.tableViewTopConstraint setConstant:0];
    }
    [self.libraryTableView reloadData];
}

-(void)bookButtonAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    libraryInfo = [self.dataSourceArrayForBooks objectAtIndex:sender.tag];

    BookDetailsViewController *bookDetailVCObj = [[BookDetailsViewController alloc]initWithNibName:@"BookDetailsViewController" bundle:nil];
    bookDetailVCObj.delegate = self;
    bookDetailVCObj.libraryInfo = libraryInfo;
    
    bookDetailVCObj.bookButtonFromLibrary = YES;
    bookDetailVCObj.isReserve = YES;
    [self.navigationController pushViewController:bookDetailVCObj animated:YES];
}

#pragma mark - Custom Delegate Method

-(void)callLibraryDetailApi {
    
    reservePagination = [[Pagination alloc]init];
    reservePagination.pageNumber = 1;
    [self.dataSourceArrayForBooks removeAllObjects];
    [self callAPIForGetReserveList:reservePagination];
}


#pragma mark - API Method

-(void)callAPIForGetBookHistoryList:(Pagination *)page  {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *prm = [NSUSERDEFAULT valueForKey:@"studentInformation"];
//    [params setValue:@"http://172.16.16.149/sps_app" forKey:pSchoolURL];
    
    //   [params setValue:[prm valueForKey:@"schoolURL"] forKey:pSchoolURL];
    [params setValue:[prm valueForKey:@"userID"] forKey:cpUserID];
    [params setValue:[prm valueForKey:@"schoolID"] forKey:cpSchoolID];
    [params setValue:[prm valueForKey:@"studentID"] forKey:cpStudentID];
    [params setValue:[prm valueForKey:@"sessionID"] forKey:cpSessionID];
    
    [params setValue:@"10" forKey:cpPageSize];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)page.pageNumber] forKey:cpPageNumber];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiGetBookHistory andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            if (bookDetailPagination.pageNumber == 0) {
                [self.dataSourceArrayForBooks removeAllObjects];
                
            }
            bookDetailPagination = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            
            NSArray *bookDetailArray = [result objectForKeyNotNull:pLibraryhistory expectedObj:[NSArray new]];
            
            for (NSMutableDictionary * bookDict in bookDetailArray) {
                [self.dataSourceArrayForBooks addObject:[LibraryModal parseLibraryInfo:bookDict]];
                self.libraryTableView.tableHeaderView = nil;

                if (bookDetailPagination.pageNumber  < bookDetailPagination.maxPages)
                    self.seeMoreButton.hidden = NO;
                else
                    self.seeMoreButton.hidden = YES;
            }

            [self.libraryTableView reloadData];
            
            if ([self.dataSourceArrayForBooks count] == 0) {
                [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
                self.noDataLabel.hidden = NO;
            }
            else
                self.noDataLabel.hidden = YES;
            
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}


-(void)callAPIForGetIssueBookList:(Pagination *)page  {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *prm = [NSUSERDEFAULT valueForKey:@"studentInformation"];
    [params setValue:@"http://172.16.16.149/sps" forKey:pSchoolURL];
    
    //   [params setValue:[prm valueForKey:@"schoolURL"] forKey:pSchoolURL];
    [params setValue:[prm valueForKey:@"userID"] forKey:cpUserID];
    [params setValue:[prm valueForKey:@"schoolID"] forKey:cpSchoolID];
    [params setValue:[prm valueForKey:@"studentID"] forKey:cpStudentID];
    [params setValue:[prm valueForKey:@"sessionID"] forKey:cpSessionID];
    
    [params setValue:@"10" forKey:cpPageSize];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)page.pageNumber] forKey:cpPageNumber];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiIssueBook andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            if (issueBookPagination.pageNumber == 0) {
                [self.dataSourceArrayForBooks removeAllObjects];
                
            }
            issueBookPagination = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            
            NSArray *bookIssueArray = [result objectForKeyNotNull:pLibraryIssue expectedObj:[NSArray new]];
            
            for (NSMutableDictionary * bookDict in bookIssueArray) {
                [self.dataSourceArrayForBooks addObject:[LibraryModal parseLibraryInfo:bookDict]];
                
                self.libraryTableView.tableHeaderView = nil;

                if (issueBookPagination.pageNumber  < issueBookPagination.maxPages)
                    self.seeMoreButton.hidden = NO;
                else
                    self.seeMoreButton.hidden = YES;
                
            }
            [self.libraryTableView reloadData];
            
            if ([self.dataSourceArrayForBooks count] == 0) {
            [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
                self.noDataLabel.hidden = NO;
            }
        else
            self.noDataLabel.hidden = YES;
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}

-(void)callAPIForGetReserveList:(Pagination *)page  {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:(keyword.length)?(keyword):@"" forKey:cpKeyword];
    
    [params setValue:(bookName.length)?(bookName):@"" forKey:cpBookName];
    [params setValue:(authorName.length)?(authorName):@"" forKey:cpAuthorName];

//    if (searchType == 1)
//        [params setValue:@"1" forKey:cpType];
//    else if (searchType == 2)
//        [params setValue:@"2" forKey:cpType];
//    else
//        [params setValue:@"3" forKey:cpType];

    [params setValue:@"10" forKey:cpPageSize];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)page.pageNumber] forKey:cpPageNumber];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiSearchBook andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            if (reservePagination.pageNumber == 0) {
                [self.dataSourceArrayForBooks removeAllObjects];
                
            }
            reservePagination = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            
            NSArray *bookIssueArray = [result objectForKeyNotNull:pLibrarySearch expectedObj:[NSArray new]];
            
            for (NSMutableDictionary * bookDict in bookIssueArray) {
                [self.dataSourceArrayForBooks addObject:[LibraryModal parseLibraryInfo:bookDict]];
                
                self.libraryTableView.tableHeaderView = nil;
            }
            
            if (reservePagination.pageNumber  < reservePagination.maxPages)
                self.seeMoreButton.hidden = NO;
            else
                self.seeMoreButton.hidden = YES;
            
            [self.libraryTableView reloadData];

            if ([self.dataSourceArrayForBooks count] == 0) {
               // [self setLabelBetweenTable:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""]];
                [self setLabelBetweenTable:@"No book is found. Please try again."];
                self.noDataLabel.hidden = NO;

            }
            else
                self.noDataLabel.hidden = YES;
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}


#pragma mark - UIButton Action

- (IBAction)seeMoreButtonAction:(id)sender {
    
        if (bookDetailPagination.pageNumber  < bookDetailPagination.maxPages && selectedIndex == 0) {
            
            bookDetailPagination.pageNumber += 1;
            [self callAPIForGetBookHistoryList:bookDetailPagination];
        }
        else if (issueBookPagination.pageNumber  < issueBookPagination.maxPages && selectedIndex == 1) {
            
            issueBookPagination.pageNumber += 1;
            [self callAPIForGetIssueBookList:issueBookPagination];
        }
        else if (reservePagination.pageNumber  < reservePagination.maxPages && selectedIndex == 2){
            reservePagination.pageNumber += 1;
            [self callAPIForGetReserveList:reservePagination];
    }
}

- (IBAction)searchButtonAction:(UIButton*)sender {
    
     reservePagination = [[Pagination alloc]init];
    reservePagination.pageNumber = 1;
    [self.view endEditing:YES];
    if (sender.tag == 100) {
        //libraryInfo.bookName = self.bookNameTextField.text;
        //self.editorTextField.text = @"";
        //self.authorTextField.text = @"";
        searchType = 1;
    }
    else if (sender.tag == 101){
        //libraryInfo.keyword = self.editorTextField.text;
       // self.bookNameTextField.text = @"";
        //self.authorTextField.text = @"";
        searchType = 2;
    }
    else {
        //libraryInfo.bookAuthorName = self.authorTextField.text;
       // self.bookNameTextField.text = @"";
        //self.editorTextField.text = @"";
        searchType = 3;
    }
    
    if (!bookName.length && !keyword.length && !authorName.length) {
        [OPRequestTimeOutView showWithMessage:@"Please enter search text." forTime:3.0 andController:self];
     }
    
//    if (!libraryInfo.bookName.length && sender.tag == 100) {
//        [OPRequestTimeOutView showWithMessage:@"Please enter book name." forTime:3.0 andController:self];
//    }
//    else if (!libraryInfo.keyword.length && sender.tag == 101) {
//        [OPRequestTimeOutView showWithMessage:@"Please enter keyword." forTime:3.0 andController:self];
//    }
//    else if (!libraryInfo.bookAuthorName.length && sender.tag == 102) {
//        [OPRequestTimeOutView showWithMessage:@"Please enter author." forTime:3.0 andController:self];
//    }
    else {
        [self.dataSourceArrayForBooks removeAllObjects];
        [self callAPIForGetReserveList:reservePagination];
    }
}



#pragma mark - Bar Button

-(UIBarButtonItem *) rightBarButtonForController : (id) controller andImageStr:(NSString *)imgStr {
    
    UIImage *buttonImage = [UIImage imageNamed:imgStr];
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 22.0f, 30.0f);
    [barButton setImage:buttonImage forState:UIControlStateNormal];
    [barButton setImage:buttonImage forState:UIControlStateSelected];
    [barButton setImage:buttonImage forState:UIControlStateHighlighted];
    
    notificationCount = [[UILabel alloc]initWithFrame:CGRectMake(12, -3, 18, 18)];
    [notificationCount setBackgroundColor:[UIColor redColor]];
    [notificationCount setFont:AppFont(10)];
    [notificationCount setTextAlignment:NSTextAlignmentCenter];
    [notificationCount setTextColor:[UIColor whiteColor]];
    notificationCount.hidden = YES;
    
    getRoundedLabel(notificationCount);
    [barButton addSubview:notificationCount];
    
    [barButton addTarget:controller action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    return barButtonItem;
}

- (void)rightBarButtonAction:(id)sender {
    
    self.libraryTableView.tableHeaderView = self.tableHeaderView;
}


#pragma mark - Show Message On Data Blank

-(void)setLabelBetweenTable:(NSString *)displayMessage {
    
    self.noDataLabel.text             = displayMessage;
}

@end
