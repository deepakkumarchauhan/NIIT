//
//  TimeTableViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 12/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "TimeTableViewController.h"
#import "PAUtility.h"
#import "TimeTableInfo.h"
#import "TimetableCustomAlertView.h"

static NSString *CellIdentifier = @"TimeTableCell";

@interface TimeTableViewController () <UITableViewDelegate,UITableViewDataSource,HistoryCellDelegate> {
    
    NSMutableArray *timeTableDataArray;
    NSMutableArray *timeTableAfterLunchArray;

    Pagination *pagination;
    
    BOOL cellAfterLunch;
}

@property (strong, nonatomic) IBOutlet UITableView *timeTableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@end

@implementation TimeTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self customInitialization];
}

-(void)customInitialization {
    
    //Navigation Bar
    self.title = @"Time Table";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");

    //Method to call when orientation is changed
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    //Table Register
    [self.timeTableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    self.timeTableView.alwaysBounceVertical = NO;
    
    timeTableDataArray = [NSMutableArray array];
    timeTableAfterLunchArray = [NSMutableArray array];
    self.dataSourceArray = [NSMutableArray array];

    cellAfterLunch = NO;
    
    // Alloc Modal Class
    pagination = [[Pagination alloc]init];
    pagination.pageNumber = 1;
    
    [self callAPIForTimeTable];
}

#pragma mark - Table View Datasource.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
   return self.dataSourceArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TimeTableInfo * obj = [self.dataSourceArray objectAtIndex:section];
    
    return obj.numberOfRow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeTableCell *timeCell = (TimeTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [timeCell.timeTableCollectionView registerNib:[UINib nibWithNibName:@"TimeTableCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"TimeTableCollectionViewCell"];
    
    timeCell.delegate = self;
    timeCell.indexPath = indexPath;

    TimeTableInfo * obj = [self.dataSourceArray objectAtIndex:indexPath.section];
    TimeTableValue *value = [obj.numberOfRow objectAtIndex:indexPath.row];

    [timeCell reloadCellwithData:[value getTimeTableValue:indexPath.row] andTimeTable:value];
    
    return timeCell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        TimeTableCell *timeCell = (TimeTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        timeCell.backgroundColor = AppDarkBlueColor;
        [timeCell.timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        timeCell.timeButton.titleLabel.font = AppFont(12);

        [timeCell reloadCellwithData:[self getHeaderTitle] andTimeTable:nil];
        
        return timeCell;
    }else {
        
        TimeTableInfo * obj = [self.dataSourceArray objectAtIndex:section];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINWIDTH, 40)];
        view.backgroundColor = AppDarkBlueColor;
        
        UILabel *lunchLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINWIDTH, 40)];
        
        lunchLabel.text = obj.sectionHeading;
        lunchLabel.textAlignment = NSTextAlignmentCenter;
        lunchLabel.textColor = [UIColor whiteColor];
        lunchLabel.font = AppFont(12);

        [view addSubview:lunchLabel];
        
        return view;
    }

    return nil;
}

-(NSArray *)getHeaderTitle
{
    return @[@"Period   (Time)",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
}

-(void)didSelectedIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableView Delegate Method.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma MARK: Orientation Check

- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    [self.timeTableView reloadData];
}

-(void)customOrientationCheck {
    
    [self.timeTableView reloadData];
}

- (void)leftBarButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - API Method

-(void)callAPIForTimeTable {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiTimeTable andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {

            NSArray *timeTableArray = [result objectForKeyNotNull:pTimeTable expectedObj:[NSArray new]];
        
            if ([timeTableArray count]) {
                self.timeTableView.backgroundView = nil;

                [self.dataSourceArray addObjectsFromArray:[TimeTableInfo parseTimeTableWithArray:timeTableArray]];

            }else {
                
                UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.timeTableView.bounds.size.width,  self.timeTableView.bounds.size.height)];
                noDataLabel.text             = [result objectForKey:cpResponseMessage];
                noDataLabel.textColor        = [UIColor darkGrayColor];
                noDataLabel.textAlignment    = NSTextAlignmentCenter;
                self.timeTableView.backgroundView = noDataLabel;
            }
           
            [self.timeTableView reloadData];
            
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


@end
