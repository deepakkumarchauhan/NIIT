//
//  BookDetailsViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 17/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "Header.h"

@interface BookDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    LibraryModal   *modalObj;
    NSMutableArray *bookDetails;
    BOOL isTableRelode;
}

@property (weak, nonatomic) IBOutlet UITableView *bookDetailsTableView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintTableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;

@end

@implementation BookDetailsViewController

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
    self.title = @"Book Details";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    
    //Method to call when orientation is changed
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    //Register Cells
    [self.bookDetailsTableView registerNib:[UINib nibWithNibName:@"StudentProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"StudentProfileTableViewCell"];
    
    [self.bookDetailsTableView setAlwaysBounceVertical:NO];
    
    self.bookDetailsTableView.estimatedRowHeight = 45;
    self.bookDetailsTableView.rowHeight = UITableViewAutomaticDimension;
    
    isTableRelode = NO;
    
    self.bookDetailsTableView.hidden = YES;
    self.imageView.hidden = YES;
    
    //Allocations
    modalObj = [[LibraryModal alloc]init];
    bookDetails = [NSMutableArray new];
    
    
    if ([_libraryInfo.isBooked isEqualToString:@"0"]) {
        self.bookButton.hidden = NO;
    }
    else {
        self.bookButton.hidden = YES;
    }
    
    if ([self.bookNumber isEqualToString:@"0"])
        self.imageView.image = [UIImage imageNamed:@"blue"];
    else
        self.imageView.image = [UIImage imageNamed:@"red"];
    
    if(!self.isReserve) {
        [self callAPIForGetBookDetail];
        self.bookButton.hidden = YES;
    }
    else {
        self.bookDetailsTableView.alwaysBounceVertical = NO;
        self.bookDetailsTableView.delegate = self;
        self.bookDetailsTableView.dataSource = self;
        [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];

//        dispatch_async(dispatch_get_main_queue(), ^{
//            //This code will run in the main thread:
//            CGRect frame = self.bookDetailsTableView.frame;
//            frame.size.height = self.bookDetailsTableView.contentSize.height;
//            self.bookDetailsTableView.frame = frame;
//        });
        self.bookDetailsTableView.hidden = NO;
        self.imageView.hidden = NO;
    }
    
}


#pragma mark - tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isTableRelode)
        return 10;
    else if(self.isReserve && [_libraryInfo.isBooked isEqualToString:@"0"])
        return 4;
    else if (self.isReserve && [[_libraryInfo isBooked] intValue]>0)
        return 5;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StudentProfileTableViewCell *cell = (StudentProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"StudentProfileTableViewCell"];
    
    if (self.isReserve) {
        switch (indexPath.row) {
                
            case 0: {
                cell.headingLabel.text = @"Book Name";
                cell.detailsLabel.text = self.libraryInfo.strBookName;
            }
                break;
                
            case 1: {
                cell.headingLabel.text = @"Author Name";
                cell.detailsLabel.text = self.libraryInfo.authorName;
            }
                break;
                
            case 2: {
                cell.headingLabel.text = @"Publisher";
                cell.detailsLabel.text = self.libraryInfo.publisherName;
            }
                break;
                
            case 3: {
                cell.headingLabel.text = @"Issued Date";
                cell.detailsLabel.text = self.libraryInfo.issueDate;
            }
                break;
                
            case 4: {
                cell.headingLabel.text = @"Due Date";
                cell.detailsLabel.text = self.libraryInfo.returnDate;
            }
                break;

                
            default:
                break;
        }
    }
    else {
        
        LibraryModal *info = [bookDetails objectAtIndex:0];

        switch (indexPath.row) {
                
            case 0: {
                cell.headingLabel.text = @"Library Name";
                cell.detailsLabel.text = info.libraryName;
            }
                break;
                
            case 1: {
                cell.headingLabel.text = @"Accession Number";
                cell.detailsLabel.text = info.strAccessionNumber;
            }
                break;
                
            case 2: {
                cell.headingLabel.text = @"Book Name";
                cell.detailsLabel.text = info.strBookName;
            }
                break;
                
            case 3: {
                cell.headingLabel.text = @"Author Name";
                cell.detailsLabel.text = info.authorName;
            }
                break;
                
            case 4: {
                cell.headingLabel.text = @"Publisher";
                cell.detailsLabel.text = info.publisher;
            }
                break;
                
            case 5: {
                cell.headingLabel.text = @"Fine Amount";
                cell.detailsLabel.text = info.fineAmount;
            }
                break;
                
            case 6: {
                cell.headingLabel.text = @"Issued Date";
                cell.detailsLabel.text = info.issueDate;
            }
                break;
                
            case 7: {
                cell.headingLabel.text = @"Due Date";
                cell.detailsLabel.text = info.dueDate;
            }
                break;
                
            case 8: {
                cell.headingLabel.text = @"Return Date";
                cell.detailsLabel.text = info.returnDate;
            }
                break;
                
            case 9: {
                cell.headingLabel.text = @"Issued For";
                cell.detailsLabel.text = info.issuedFor;
            }
                break;
            default:
                break;
        }
    }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark: UIButton Action

-(void)leftBarButtonAction:(UIButton*)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma MARK: Orientation Check

- (void)orientationChanged:(NSNotification *)notification {
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    self.heightConstraintTableView.constant = self.bookDetailsTableView.contentSize.height +10;
}

-(void)customOrientationCheck {
    self.heightConstraintTableView.constant = self.bookDetailsTableView.contentSize.height +10;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (IBAction)bookButtonAction:(id)sender {
    
    [self callAPIToBook];
}



#pragma mark - API Method

-(void)callAPIForGetBookDetail {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:_libraryInfo.bookID forKey:pBookId];
    [params setValue:@"1" forKey:cpType];
    [params setValue:_libraryInfo.strAccessionNumber forKey:pAccessionNo];
    [params setValue:_libraryInfo.issueReturnId forKey:pIssueReturnId];
    [params setValue:_libraryInfo.type forKey:cpType];

    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiLibraryGetDetail andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            

            NSArray *bookIssueArray = [result objectForKeyNotNull:pLibrary expectedObj:[NSArray new]];
            
            for (NSMutableDictionary * bookDict in bookIssueArray) {
                [bookDetails addObject:[LibraryModal parseLibraryInfo:bookDict]];
                isTableRelode = YES;
                self.bookDetailsTableView.hidden = NO;
                self.imageView.hidden = NO;

            }
            self.bookDetailsTableView.delegate = self;
            self.bookDetailsTableView.dataSource = self;
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    //This code will run in the main thread:
//                        CGRect frame = self.bookDetailsTableView.frame;
//                        frame.size.height = self.bookDetailsTableView.contentSize.height;
//                        self.bookDetailsTableView.frame = frame;
//                });
//            
            [self.bookDetailsTableView reloadData];
            [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];

            
           if ([bookDetails count] == 0)
              [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
        
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}


#pragma mark - API Method

-(void)callAPIToBook {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:_libraryInfo.bookID forKey:pBookId];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiReservation andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
            
            [self.delegate callLibraryDetailApi];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}


-(void)afterSomeTime {
    self.tableHeightConstraint.constant = self.bookDetailsTableView.contentSize.height;

}


#pragma mark - Show Message On Data Blank

-(void)setLabelBetweenTable:(NSString *)displayMessage {
    
    UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,  self.view.bounds.size.height)];
    noDataLabel.text             = displayMessage;
    noDataLabel.textColor        = [UIColor darkGrayColor];
    noDataLabel.textAlignment    = NSTextAlignmentCenter;
    [self.view addSubview:noDataLabel];
  //  self.view.backgroundView = noDataLabel;
}


@end
