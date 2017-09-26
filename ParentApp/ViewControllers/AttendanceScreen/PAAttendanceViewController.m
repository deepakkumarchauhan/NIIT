//
//  PAAttendanceViewController.m
//  ParentApp
//
//  Created by Yogesh Pal on 31/08/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PAAttendanceViewController.h"
#import "PAAttendanceSummary.h"
#import "UUChart.h"
#import "PAUtility.h"

@interface PAAttendanceViewController ()<UUChartDataSource>

//DataSouce Attendance
@property (nonatomic, strong) PAAttendanceSummary *attendanceSummary;

@property (weak, nonatomic) IBOutlet UILabel *admNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLabel;

//UITable View
@property (nonatomic, weak) IBOutlet UITableView *tableViewAttendance;

//Header View
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView_StudentProfile;
@property (nonatomic, weak) IBOutlet UILabel *label_enrollMentNumber;
@property (nonatomic, weak) IBOutlet UILabel *label_studentName;

//Footer View
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UIView *view_ChartView;
@property (strong, nonatomic)  UUChart *chartView;

@end

@implementation PAAttendanceViewController
@synthesize chartView;
@synthesize attendanceSummary;

#pragma mark - View Life Cycles Actions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //UINavigation
    self.navigationItem.title = NSLocalizedString(@"Attendance", nil);
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    
    //Inital Actions
    [self setupDefaults];
}

#pragma mark - Back Button Action

-(void)leftBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Initial Actions

-(void)setupDefaults
{
    if (IS_IPHONE_6) {
        self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y, self.footerView.frame.size.width, self.footerView.frame.size.height + 50);
        self.view_ChartView.frame = CGRectMake(self.view_ChartView.frame.origin.x, self.footerView.frame.origin.y, self.view_ChartView.frame.size.width, self.view_ChartView.frame.size.height + 50);
    }else if (IS_IPHONE_6P)
    {
        self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y, self.footerView.frame.size.width, self.footerView.frame.size.height + 100);
        self.view_ChartView.frame = CGRectMake(self.view_ChartView.frame.origin.x, self.footerView.frame.origin.y, self.view_ChartView.frame.size.width, self.view_ChartView.frame.size.height + 100);
    }else if (IS_IPAD_MINI_AIR)
    {
        self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y, self.footerView.frame.size.width, self.footerView.frame.size.height + 300);
        self.view_ChartView.frame = CGRectMake(self.view_ChartView.frame.origin.x, self.footerView.frame.origin.y, self.view_ChartView.frame.size.width, self.view_ChartView.frame.size.height + 300);
    }else if (IS_IPAD_PRO)
    {
        self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y, self.footerView.frame.size.width, self.footerView.frame.size.height + 600);
        self.view_ChartView.frame = CGRectMake(self.view_ChartView.frame.origin.x, self.footerView.frame.origin.y, self.view_ChartView.frame.size.width, self.view_ChartView.frame.size.height + 600);
    }
    
    self.tableViewAttendance.tableHeaderView = self.headerView;
    self.tableViewAttendance.tableFooterView = self.footerView;
    self.tableViewAttendance.alwaysBounceVertical = NO;
    
    //Get Chart Data
    [self callAPIForGetttingAttendanceSummary];
}

-(void)randerUserProfileData
{
//    if ([attendanceSummary.studentProfileImage length]) {
//        NSData* data = [[NSData alloc] initWithBase64EncodedString:attendanceSummary.studentProfileImage options:0];
//        self.imageView_StudentProfile.image = [UIImage imageWithData:data];
//    }else
//        self.imageView_StudentProfile.image = [UIImage imageNamed:@"dummy"];
    
    self.label_studentName.text = attendanceSummary.studentName;
    self.label_enrollMentNumber.text = attendanceSummary.studentEnrollmentNumber;
}

-(void)randerChartData
{
    //Chart View
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, self.view_ChartView.frame.size.height-20) withSource:self withStyle:UUChartBarStyle];
    
    [self.view_ChartView setClipsToBounds:YES];
    [chartView showInView:self.view_ChartView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
     else
        return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // do something before rotation
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // do something after rotation
    [self randerChartData];
}

#pragma mark - UUChart Delegate and Data Source
//Array abscissa title
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    return [self setXlabelArray];
}

//Numerical multiple arrays
- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
    
    NSMutableArray *yLabelDataArray = [NSMutableArray array];
    for (Attendance *attendance in attendanceSummary.dataSourceAttendance) {
        [yLabelDataArray addObject:attendance.attendanceScore];
    }
    return @[yLabelDataArray];
}

#pragma mark - @optional
//Array of Colors
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
   // return @[AppRedColor];
    
    //return rainbowColors;
    return @[UUGreen,UURed,UUBrown];
}

//Display Range Value
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    //return CGRangeMake(60, 10);
    return CGRangeZero;
}

#pragma mark Exclusive line graph function

//Label Value Region
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart
{
    return CGRangeZero;
}

//Analyzing display horizontal lines
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//Analyzing show maximum and minimum
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return YES;
}

//Bar Chart Click Action
-(void)barChartClickedAtIndex:(NSInteger)index
{
    PAAttendanceCalendarVC *calendarVCObject = [[PAAttendanceCalendarVC alloc] initWithNibName:@"PAAttendanceCalendarVC" bundle:nil];
    calendarVCObject.monthTag = [[[attendanceSummary.dataSourceAttendance objectAtIndex:index-1] monthNum] integerValue];
    calendarVCObject.attendanceSummary = attendanceSummary;
    [self.navigationController pushViewController:calendarVCObject animated:YES];
}

#pragma mark - UITableview Delegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Get Previous Six Month Action

-(NSMutableArray *)setXlabelArray {
    
    NSMutableArray *xLabelDataArray = [NSMutableArray array];
    
    for (Attendance *attendanceModal in attendanceSummary.dataSourceAttendance)
        [xLabelDataArray addObject:attendanceModal.monthName];
    
    return xLabelDataArray;
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForGetttingAttendanceSummary {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiAttendanceBar andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
               attendanceSummary = [PAAttendanceSummary parseAttendanceDetailWith:result];

            NSDictionary *studentDict = [[NSUSERDEFAULT valueForKey:@"studentInformation"] mutableCopy];
            
            if ([[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] length]) {
                NSData* data = [[NSData alloc] initWithBase64EncodedString:[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] options:0];
                self.imageView_StudentProfile.image = [UIImage imageWithData:data];
            }else
                self.imageView_StudentProfile.image = [UIImage imageNamed:@"dummy"];
            
            [self randerUserProfileData];
            [self randerChartData];
            [self.admNumberLabel setHidden:NO];
            getRoundedImageView(self.imageView_StudentProfile);
            self.seperatorLabel.hidden = NO;
            [self.tableViewAttendance reloadData];
        }else
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
    }];
}

#pragma Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
