//
//  PACalendarViewController.m
//  ParentApp
//
//  Created by Yogesh Pal on 03/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PACalendarViewController.h"
#import "CKCalendarView.h"
#import "PACalendarTableViewCell.h"
#import "Event.h"
#import "PAUtility.h"

//static NSString *CELLIDENTIFIER = @"PACalendarEventCell";

static NSString *CELLIDENTIFIER = @"calendarCellId";



@interface PACalendarViewController () <CKCalendarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    //For Month
    NSInteger monthTag;
    
    //For Selected Date
    NSDate *selectedDate;
    
    //Handle Yellow Color
    BOOL isDateYellow;
    
    //Particular date info
    Event *selectedDateEvent;
    
    //Calendar Date Info
    NSMutableArray *calendarDataSource;
    NSMutableArray *selectedDataSource;

}

//UITableView
@property (strong, nonatomic) IBOutlet UITableView *tableView_Calendar;

//CalendarView
@property(nonatomic, strong) CKCalendarView *calendar;

@property (strong, nonatomic) IBOutlet UIView *calendarView;

//Footer View
@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UIView *detailView;

@property (nonatomic, strong) IBOutlet UILabel *eventName;
@property (nonatomic, strong) IBOutlet UILabel *eventDetail;
@property (nonatomic, strong) IBOutlet UILabel *eventStartDate;
@property (nonatomic, strong) IBOutlet UILabel *eventEndDate;

@end

@implementation PACalendarViewController

#pragma mark - View Life Cycles Actions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //UINavigation
    self.navigationItem.title = @"Calendar";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");
    
    //Inital Actions
    [self setupDefaults];
}

#pragma mark - Initial Actions
-(void)setupDefaults
{
    //Data Source
    calendarDataSource = [[NSMutableArray alloc] init];
    selectedDate = [NSDate date];
    
    selectedDataSource = [NSMutableArray array];
    
    monthTag = [PAUtility getMonthNumber:[NSDate date] andMonthChnage:0];
    isDateYellow = NO;

    //TableView
    //self.tableView_Calendar.tableHeaderView = self.calendarView;
    
    //Footer Detail View
    self.detailView.layer.borderWidth = 1.0f;
    self.detailView.layer.cornerRadius = 5.0f;
    
    //Register Cell
//    [self.tableView_Calendar registerNib:[UINib nibWithNibName:@"PACalendarEventCell" bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];
//    self.tableView_Calendar.alwaysBounceVertical = NO;
    
    [self.tableView_Calendar registerNib:[UINib nibWithNibName:@"PACalendarTableViewCell" bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];
    self.tableView_Calendar.alwaysBounceVertical = NO;
    
    self.tableView_Calendar.estimatedRowHeight = 181.0;
    //Adding Automatic Adjust for ScrollView Insets
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    //Adding notification observer for height change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarHeightChanged:) name:kCalendarFrameChangeNotification object:nil];
    
   [self callAPIForGetttingEventCalendar:monthTag];
}

#pragma mark - Back Button Action

-(void)leftBarButtonAction:(UIButton *)sender {
    
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
}

-(void)updateHeaderView
{
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
    NSString *startDateString = [studentDict objectForKeyNotNull:pSessionStartDate expectedObj:@""];
    NSString *endDateString = [studentDict objectForKeyNotNull:pSessionEndDate expectedObj:@""];
    
    self.calendar = [[CKCalendarView alloc] initWithStartDay:startSunday andComingDate:selectedDate andSelectedMonthNum:monthTag andInitialMonthNum:[PAUtility getMonthNumber:[PAUtility convertJSONDateIntoNSDate:startDateString] andMonthChnage:0] andLastMonthNum:[PAUtility getMonthNumber:[PAUtility convertJSONDateIntoNSDate:endDateString] andMonthChnage:0]];
    _calendar.delegate = self;

    _calendar.onlyShowCurrentMonth = NO;
    _calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    _calendar.frame = CGRectMake(0, 0, WINWIDTH, 320);
    [self.calendarView addSubview:_calendar];
    
    self.calendar.backgroundColor = [UIColor whiteColor];
    
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

//Calendar height Change Notification

-(void)calendarHeightChanged:(NSNotification *)notificationObj {
    
    NSString *strCalendarHeight = notificationObj.object;
    
    [self.calendarView setFrame:CGRectMake(0, 0, WINWIDTH,[strCalendarHeight integerValue])];
    self.tableView_Calendar.tableHeaderView = self.calendarView;

    [self.tableView_Calendar reloadData];
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    for (Event *objEvent in calendarDataSource) {
        if ([objEvent.eventDate compare:date] == NSOrderedSame && objEvent.status &&![dateItem.textColor isEqual:[UIColor lightGrayColor]]) {
            dateItem.backgroundColor =  RGBCOLOR(196.0, 196.0, 14.0, 1);
            dateItem.textColor = [UIColor whiteColor];
        }
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {

    [selectedDataSource removeAllObjects];
    for (Event *objEvent in calendarDataSource) {
        if ([objEvent.eventDate compare:date] == NSOrderedSame && objEvent.status) {
            selectedDateEvent  = objEvent;
            isDateYellow = YES;
            [selectedDataSource addObject:objEvent];
           // break;
        }else
            isDateYellow = NO;
    }
    
        [self.tableView_Calendar reloadData];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    
    _calendar.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didChangeToMonth:(NSDate *)date andMonthNumber:(NSInteger)monthNum;
{
    NSInteger addMinusNumber = 0;
    if (monthNum == 1 && monthTag == 12)
        addMinusNumber = 1;
    else if (monthNum == 12 && monthTag == 1)
        addMinusNumber = -1;
    else if (monthTag > monthNum)
        addMinusNumber = -1;
    else
        addMinusNumber = 1;
    
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    [comps setMonth:addMinusNumber];
    selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:selectedDate options:0];

    monthTag = monthNum;
    isDateYellow = NO;

    [self callAPIForGetttingEventCalendar:monthTag];
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

#pragma mark - ***Table View DataSource Methods *******************-

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (isDateYellow) {
        return selectedDataSource.count;
//    }else
//         return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
  PACalendarTableViewCell *calendarCell = (PACalendarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
    Event *eventInfo = [selectedDataSource objectAtIndex:indexPath.row];
    
    calendarCell.eventNameLabel.text = eventInfo.eventName;
    calendarCell.detailLabel.text = eventInfo.eventDetail;
    calendarCell.fromLabel.text = eventInfo.eventStartDate;
    calendarCell.toLabel.text = eventInfo.eventEndDate;

//    PACalendarEventCell *calendarCell = (PACalendarEventCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
//    
//    switch (indexPath.row) {
//        case 0: {
//            calendarCell.eventTitle.text = @"Event      :";
//            calendarCell.eventValue.text = selectedDateEvent.eventName;
//            calendarCell.lowerLabel.backgroundColor = RGBCOLOR(215, 215, 215, 1);
//            calendarCell.lowerLabel.hidden = NO;
//            calendarCell.upperLabel.hidden = NO;
//        }
//            break;
//        case 1: {
//            calendarCell.eventTitle.text = @"Details    :";
//            calendarCell.eventValue.text = selectedDateEvent.eventDetail;
//            calendarCell.lowerLabel.backgroundColor = RGBCOLOR(215, 215, 215, 1);
//            calendarCell.lowerLabel.hidden = NO;
//            calendarCell.upperLabel.hidden = YES;
//        }
//            break;
//        case 2: {
//            calendarCell.eventTitle.text = @"From       :";
//            calendarCell.eventValue.text = selectedDateEvent.eventStartDate;
//            calendarCell.lowerLabel.backgroundColor = RGBCOLOR(215, 215, 215, 1);
//            calendarCell.lowerLabel.hidden = NO;
//            calendarCell.upperLabel.hidden = YES;
//
//        }
//            break;
//        case 3: {
//            calendarCell.eventTitle.text = @"To           :";
//            calendarCell.eventValue.text = selectedDateEvent.eventEndDate;
//            calendarCell.upperLabel.hidden = YES;
//            calendarCell.lowerLabel.hidden = NO;
//            calendarCell.lowerLabel.backgroundColor = RGBCOLOR(98, 119, 240, 1);
//        }
//            break;
//        default:
//            break;
//    }
    return calendarCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 0.0f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1f;
//}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForGetttingEventCalendar:(NSInteger)monthNumber {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%d",(int)monthNumber] forKey:pMonthNumber];

    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiCalendarEvent andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            //Data Source
            [calendarDataSource  addObjectsFromArray:[Event parseEventDataWith:result]];
           
            [self.calendar removeFromSuperview];

            [self updateHeaderView];
            [self.tableView_Calendar reloadData];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
