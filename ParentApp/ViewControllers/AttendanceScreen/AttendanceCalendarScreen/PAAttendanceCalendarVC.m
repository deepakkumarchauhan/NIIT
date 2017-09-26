//
//  PAAttendanceCalendarVC.m
//  ParentApp
//
//  Created by Yogesh Pal on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PAAttendanceCalendarVC.h"
#import "CKCalendarView.h"
#import "PAUtility.h"
#import "PAAttendanceSummary.h"

@interface PAAttendanceCalendarVC () <CKCalendarDelegate>
{
    NSInteger increaseCount;
}

//Data Source Calendar
@property (nonatomic, strong) CalendarSummary *calendarSummary;

//UITableView
@property (strong, nonatomic) IBOutlet UITableView *tableViewAttendanceCalendar;

//CalendarView
@property (strong, nonatomic) IBOutlet UIView *calendarView;

@property (strong, nonatomic) CKCalendarView *calendar;

//Footer View
@property(nonatomic, strong) IBOutlet UIView *footerView;

@property(nonatomic, strong) IBOutlet UILabel *presentCount;
@property(nonatomic, strong) IBOutlet UILabel *absentCount;
@property(nonatomic, strong) IBOutlet UILabel *leaveCount;
@property(nonatomic, strong) IBOutlet UILabel *firstHalfCount;
@property(nonatomic, strong) IBOutlet UILabel *secondHalfCount;

@end

@implementation PAAttendanceCalendarVC
@synthesize calendarSummary;

#pragma mark - View Life Cycles Actions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //UINavigation
    self.navigationItem.title = NSLocalizedString(@"Attendance", nil);
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self,@"back");
    
    //Inital Actions
    [self setupDefaults];
}

#pragma mark - Initial Actions

-(void)setupDefaults
{
    //Adding Automatic Adjust for ScrollView Insets
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableViewAttendanceCalendar.alwaysBounceVertical = NO;
    
    //Adding notification observer for height change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarHeightChanged:) name:kCalendarFrameChangeNotification object:nil];
    
    increaseCount = -1;

    [self callAPIForGetttingAttendanceCalendar:self.monthTag];
}

#pragma mark - Back Button Action

- (void)leftBarButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updatePresenceCountToFooterView
{
    self.presentCount.text = calendarSummary.presentCount;
    self.absentCount.text = calendarSummary.absentCount;
    self.leaveCount.text = calendarSummary.leaveCount;
    self.firstHalfCount.text = calendarSummary.firstHalfCount;
    self.secondHalfCount.text = calendarSummary.secondHalfCount;
}

-(void)updateHeaderView
{
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.monthNum == %@",[NSString stringWithFormat:@"%ld",(long)self.monthTag]];
    NSArray *foundArray = [self.attendanceSummary.dataSourceAttendance filteredArrayUsingPredicate:bPredicate];
   Attendance *attendanceForMonth =  [foundArray firstObject];
    
    NSInteger initialMonth = [[[self.attendanceSummary.dataSourceAttendance firstObject] monthNum] integerValue];
    NSInteger lastMonth = [[[self.attendanceSummary.dataSourceAttendance lastObject] monthNum] integerValue];

    self.calendar = [[CKCalendarView alloc] initWithStartDay:startSunday andComingDate:[PAUtility convertJSONDateIntoNSDate:attendanceForMonth.attendanceDate] andSelectedMonthNum:self.monthTag andInitialMonthNum:initialMonth andLastMonthNum:lastMonth];
    self.calendar.delegate = self;
    
    self.calendar.onlyShowCurrentMonth = NO;
    self.calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
   // self.calendar.frame = CGRectMake(0, 0, WINWIDTH, 320);
    self.calendar.backgroundColor = [UIColor whiteColor];
    [self.calendarView addSubview:self.calendar];
    
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

//Calendar height Change Notification

-(void)calendarHeightChanged:(NSNotification *)notificationObj {
    
    NSString *strCalendarHeight = notificationObj.object;
    
    [self.calendarView setFrame:CGRectMake(0, 0, WINWIDTH,[strCalendarHeight integerValue]-50)];
    self.tableViewAttendanceCalendar.tableHeaderView = self.calendarView;
    self.tableViewAttendanceCalendar.tableFooterView = self.footerView;
    
    [self.tableViewAttendanceCalendar reloadData];
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.monthNum == %@",[NSString stringWithFormat:@"%ld",(long)self.monthTag]];
    NSArray *foundArray = [self.attendanceSummary.dataSourceAttendance filteredArrayUsingPredicate:bPredicate];
    Attendance *attendanceForMonth =  [foundArray firstObject];
    
    if ([calendar date:[PAUtility convertJSONDateIntoNSDate:attendanceForMonth.attendanceDate] isSameDayAsDate:date])
        increaseCount = 0;

    if (increaseCount != -1) {
        if ([calendarSummary.dataSourceCalendarMonthWise count]>increaseCount) {
            Calendar *obj = [calendarSummary.dataSourceCalendarMonthWise objectAtIndex:increaseCount];
            
            if (obj.status.intValue == 0) {
                dateItem.backgroundColor = RGBCOLOR(52.0, 189.0, 52.0, 1);
                dateItem.textColor = [UIColor whiteColor];
            }
            else if (obj.status.intValue == 1){
                dateItem.backgroundColor =  RGBCOLOR(0.0, 157.0, 217.0, 1);
                dateItem.textColor = [UIColor whiteColor];
            }
            else if (obj.status.intValue == 2){
                dateItem.backgroundColor =  RGBCOLOR(102.0, 51.0, 104.0, 1);
                dateItem.textColor = [UIColor whiteColor];
            }
            else if (obj.status.intValue == 3){
                dateItem.backgroundColor =  RGBCOLOR(220.0, 14.0, 14.0, 1);
                dateItem.textColor = [UIColor whiteColor];
            }
            else if (obj.status.intValue == 4){
                dateItem.backgroundColor=  RGBCOLOR(196.0, 196.0, 14.0, 1);
                dateItem.textColor = [UIColor whiteColor];
            }else {
                dateItem.backgroundColor =  [UIColor whiteColor];
                dateItem.textColor = [UIColor blackColor];
            }
        }
        increaseCount ++;
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {

}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {

    _calendar.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didChangeToMonth:(NSDate *)date andMonthNumber:(NSInteger)monthNum;
{
    [self callAPIForGetttingAttendanceCalendar:monthNum];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
     else
        return YES;
}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    return NO;
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCalendarFrameChangeNotification object:[NSString stringWithFormat:@"%f",frame.size.height]];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForGetttingAttendanceCalendar:(NSInteger)monthNum {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    self.monthTag = monthNum;

    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.monthNum == %@",[NSString stringWithFormat:@"%ld",(long)self.monthTag]];
    NSArray *foundArray = [self.attendanceSummary.dataSourceAttendance filteredArrayUsingPredicate:bPredicate];
    Attendance *attendanceForMonth =  [foundArray firstObject];
    
    [params setValue:[NSString stringWithFormat:@"%ld",(long)monthNum] forKey:pMonthNumber];
    [params setValue:[PAUtility getYearFromDate:[PAUtility convertJSONDateIntoNSDate:attendanceForMonth.attendanceDate]] forKey:@"year"];
    
    [calendarSummary.dataSourceCalendarMonthWise removeAllObjects];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiAttendanceCalendar andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            increaseCount = -1;
            
            self.tableViewAttendanceCalendar.tableHeaderView = self.calendarView;
            self.tableViewAttendanceCalendar.tableFooterView = self.footerView;
            
            calendarSummary = [CalendarSummary parseCalendarSummaryMonthWiseWith:result];
            
            [self.calendar removeFromSuperview];
            [self updateHeaderView];
            [self updatePresenceCountToFooterView];
            [self.tableViewAttendanceCalendar reloadData];

        }else
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
    }];
}

#pragma Memeory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIView Deallocation Actions

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCalendarFrameChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSCurrentLocaleDidChangeNotification object:nil];
}

@end
