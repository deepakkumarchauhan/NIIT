//
//  CircularViewController.m
//  ParentApp
//
//  Created by Krati Agarwal on 15/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "CircularViewController.h"
#import "Pagination.h"
#import "CircularModel.h"
#import "PAUtility.h"

@interface CircularViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray   *circularRecentArray;
    NSMutableArray   *circularPreviousArray;
    
    Pagination *recentPagination;
    Pagination *previousPagination;
}

// Table View
@property (weak, nonatomic) IBOutlet UITableView *circularTableView;

@property (weak, nonatomic) IBOutlet UIButton *currentButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *monthPickerButton;

@property (weak, nonatomic) IBOutlet UIView *segmentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@property (strong, nonatomic) CircularModel *circular;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

@end

@implementation CircularViewController

#pragma mark - UIViewController Life cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customInitialization];
}

#pragma mark - Private Method

-(void)customInitialization {
    
    //Navigation Bar
    self.title = @"Circulars";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    
    //Initalise modal class
    self.circular = [[CircularModel alloc] init];
    self.circular.segmentType = 0;

    //Register TableView Cell
    [self.circularTableView registerNib:[UINib nibWithNibName:@"CircularTableViewCell" bundle:nil] forCellReuseIdentifier:@"CircularTableViewCell"];
    self.circularTableView.alwaysBounceVertical = NO;
    
    //TableView Layout
    self.tableViewTopConstraint.constant = 13;
    
    //Initial Element Layout
    getCornerView(self.segmentView,18.0f);
    
    self.currentButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(189.0/255.0) blue:(250.0/255.0) alpha:1.0f];
    [self.previousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.previousButton.backgroundColor = [UIColor clearColor];
    
    //Initalise For Pagination
    recentPagination = [[Pagination alloc] init];
    recentPagination.pageNumber = 0;
    
    previousPagination = [[Pagination alloc] init];
    previousPagination.pageNumber = 0;
    
    //Itialise the discipline Array
    circularRecentArray = [NSMutableArray array];
    circularPreviousArray = [NSMutableArray array];
    
    //Call Circular List Api
    [self callAPIForCircularList:recentPagination];
}

#pragma mark - UIButton Actions

- (IBAction)seeMoreButtonAction:(id)sender {
    
    if (self.circular.segmentType == 0 && recentPagination.pageNumber < recentPagination.maxPages)
        [self callAPIForCircularList:recentPagination];
    else if (self.circular.segmentType == 1 && previousPagination.pageNumber < previousPagination.maxPages)
        [self callAPIForCircularList:previousPagination];
}

- (IBAction)segmentBtnAction:(id)sender {
    
    UIButton *segButton = sender;
    [self.currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.previousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if(segButton.tag == 2) {
        
        self.tableViewTopConstraint.constant = 65;
        self.circular.segmentType = 1;
        self.previousButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(189.0/255.0) blue:(250.0/255.0) alpha:1.0f];
        self.currentButton.backgroundColor =  [UIColor clearColor];

        //To get the previous month
        NSInteger modifiedMonth= [PAUtility getMonthNumber:[NSDate date] andMonthChnage:0];
        self.circular.month = [NSString stringWithFormat:@"%ld",(long)modifiedMonth];
        NSString *monthName = [[[[NSDateFormatter alloc] init] shortMonthSymbols] objectAtIndex:(modifiedMonth - 1)];
        [self.monthPickerButton setTitle:monthName forState:UIControlStateNormal];
        
        [self.circularTableView reloadData];

    } else if (segButton.tag == 1) {
        
        self.tableViewTopConstraint.constant = 13;
        self.circular.segmentType = 0;
        self.circular.month = [NSString string];
        self.currentButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(189.0/255.0) blue:(250.0/255.0) alpha:1.0f];
        self.previousButton.backgroundColor =  [UIColor clearColor];

        [self.circularTableView reloadData];
    }
    
    if (self.circular.segmentType == 0 && [circularRecentArray count] == 0 && recentPagination.pageNumber <= recentPagination.maxPages)
        [self callAPIForCircularList:recentPagination];
    else if (self.circular.segmentType == 1 && [circularPreviousArray count] == 0 && previousPagination.pageNumber <= previousPagination.maxPages)
        [self callAPIForCircularList:previousPagination];
    else if (self.circular.segmentType == 1 && [circularPreviousArray count] == 0) {
        
        [self setLabelBetweenTable:MessageWhenNoData];
        [self.circularTableView reloadData];
        
    }else if (self.circular.segmentType == 0 && [circularRecentArray count] == 0) {
        
        [self setLabelBetweenTable:MessageWhenNoData];
        [self.circularTableView reloadData];
    }
    else {
        self.circularTableView.backgroundView = nil;
        [self.circularTableView reloadData];
    }
}

- (IBAction)monthPickerButonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    NSArray *monthArray = [[self getAllMonths] mutableCopy];
    NSInteger selectedElementIndex = [monthArray indexOfObject:self.monthPickerButton.titleLabel.text];

    [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:monthArray andselectedIndex:selectedElementIndex AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
        [self.monthPickerButton setTitle:selectedText forState:UIControlStateNormal];
        
        if (selectedIndex <= 8)
            self.circular.month = [NSString stringWithFormat:@"%ld",(long)(selectedIndex + 3)];
        else
            self.circular.month = [NSString stringWithFormat:@"%ld",(long)selectedIndex - 9];

        previousPagination.pageNumber = 0;
        [self callAPIForCircularList:previousPagination];

        [self.circularTableView reloadData];
    }];
}


-(NSArray *)getAllMonths {
    
    NSMutableArray *monthArray = [NSMutableArray array];
    
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
    NSString *startDateString = [studentDict objectForKeyNotNull:pSessionStartDate expectedObj:@""];
    NSString *endDateString = [studentDict objectForKeyNotNull:pSessionEndDate expectedObj:@""];
    
    
    NSInteger endMonthNum = [PAUtility getMonthNumber:[PAUtility convertJSONDateIntoNSDate:endDateString] andMonthChnage:0];
    NSInteger startMonthNum = [PAUtility getMonthNumber:[PAUtility convertJSONDateIntoNSDate:startDateString] andMonthChnage:0];

    NSInteger endYearNum = [PAUtility getYearNumber:[PAUtility convertJSONDateIntoNSDate:endDateString]];
    NSInteger startYearNum = [PAUtility getYearNumber:[PAUtility convertJSONDateIntoNSDate:startDateString]];

    if ((endMonthNum == startMonthNum) && (endYearNum != startYearNum))
        endMonthNum = startMonthNum - 1;
    
    
    NSDate           *today           =  [PAUtility convertJSONDateIntoNSDate:startDateString];
    
    NSDateComponents *monthComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:today];
    int months  = 1;
    
    for(int m = (int)[monthComponents month]-1; months <= 12; m++){
        [monthArray addObject:[[[[NSDateFormatter alloc] init] shortMonthSymbols] objectAtIndex: m % 12]];
        
        if (endMonthNum-1 == m%12)
            break;
        
        months++;
    }
    
    return monthArray;
}

-(void)leftBarButtonAction:(UIButton*)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.circular.segmentType == 0)
        return [circularRecentArray count];
    else
        return [circularPreviousArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CircularTableViewCell *cell = (CircularTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CircularTableViewCell" forIndexPath:indexPath];
    
    // when api called
    CircularModel *circularData =  (self.circular.segmentType == 0)?[circularRecentArray objectAtIndex:indexPath.row]:[circularPreviousArray objectAtIndex:indexPath.row];
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = RGBCOLOR(238, 238, 238, 1);
    
    cell.circularNoLabel.text = [NSString stringWithFormat:@"Circular No : %@",circularData.circularNo];
    cell.noOfCircularLabel.text = [NSString stringWithFormat:@"No of circulars : %@",circularData.noOfCircular];
    cell.dateLabel.text = circularData.circularDate;
    cell.circularImageView.image = [UIImage imageNamed:@"img"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CircularDetailViewController *receiptVCObj = [[CircularDetailViewController alloc]initWithNibName:@"CircularDetailViewController" bundle:nil];
    CircularModel *circularData =  (self.circular.segmentType == 0)?[circularRecentArray objectAtIndex:indexPath.row]:[circularPreviousArray objectAtIndex:indexPath.row];
    receiptVCObj.circularId = circularData.circularId;
    [self.navigationController pushViewController:receiptVCObj animated:YES];
}

-(void)saveButtonAction:(UIButton *)sender
{
    
}


#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForCircularList:(Pagination *)page {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:[NSString stringWithFormat:@"%ld",(long)page.pageNumber+1] forKey:cpPageNumber];
    [params setValue:@"5" forKey:cpPageSize];
    
    [params setValue:self.circular.month forKey:pMonth];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)self.circular.segmentType] forKey:cpType];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiGetMainCirculars andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            //For Presenting data instantly
            self.circularTableView.delegate = self;
            self.circularTableView.dataSource = self;
            
            //For Remove the previous one if  calling 1 page again
            if (self.circular.segmentType == 0 && recentPagination.pageNumber == 0)
                [circularRecentArray removeAllObjects];
            
            else if (self.circular.segmentType == 1 && previousPagination.pageNumber == 0)
                [circularPreviousArray removeAllObjects];

            //for Pagination Detail
            if (self.circular.segmentType == 0)
                recentPagination = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            else if (self.circular.segmentType == 1)
                previousPagination = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            
            //For parse circular data
            if (self.circular.segmentType == 0) {
                [circularRecentArray addObjectsFromArray:[CircularModel parseCircular:[result valueForKey:pCircularList]]];
                
                if ([circularRecentArray count] == 0)
                    [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
                else
                    self.circularTableView.backgroundView = nil;
                
                if (previousPagination.pageNumber >= previousPagination.maxPages)
                    [self.seeMoreButton setHidden:YES];
                else
                    [self.seeMoreButton setHidden:NO];
                
            } else  if (self.circular.segmentType == 1) {
                
                [circularPreviousArray addObjectsFromArray:[CircularModel parseCircular:[result valueForKey:pCircularList]]];
                
                if ([circularPreviousArray count] == 0)
                    [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
                else
                    self.circularTableView.backgroundView = nil;
                
                if (previousPagination.pageNumber >= previousPagination.maxPages)
                    [self.seeMoreButton setHidden:YES];
                else
                    [self.seeMoreButton setHidden:NO];
            }
            
            [self.circularTableView reloadData];

        }else
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
    }];
}


#pragma mark - Show Message On Data Blank

-(void)setLabelBetweenTable:(NSString *)displayMessage {
    
    UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.circularTableView.bounds.size.width,  self.circularTableView.bounds.size.height)];
    noDataLabel.text             = displayMessage;
    noDataLabel.textColor        = [UIColor darkGrayColor];
    noDataLabel.textAlignment    = NSTextAlignmentCenter;
    self.circularTableView.backgroundView = noDataLabel;
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
