//
//  AssignmentViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 08/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//
#import "AssignmentContentVC.h"
#import <QuickLook/QuickLook.h>
#import "AssignmentViewController.h"
#import "MZDayPicker.h"
#import "Pagination.h"
#import "PAUtility.h"
#import "ShowDescriptionWebView.h"

@interface AssignmentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MZDayPickerDelegate, MZDayPickerDataSource, UITableViewDataSource, UITableViewDelegate> {
    
    AssignmentInfoModal   *modalObj;
    
    NSInteger                 segmentIndex;
    NSMutableArray        *subjectsArray;
    NSMutableArray        *subjectsArrayForHistory;

    NSMutableArray        *assignmentRecentArray;
    NSMutableArray        *assignmentPreviousArray;
    
    Pagination            *recentPagination;
    Pagination            *previousPagination;
    
    QLPreviewController   *previewController;
}

@property (weak, nonatomic) IBOutlet UIButton *currentButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

@property (weak, nonatomic) IBOutlet UICollectionView *subjectsCollectionView;
@property (weak, nonatomic) IBOutlet UITableView      *assignmentsTableView;

@property (weak, nonatomic) IBOutlet UIView      *segmentView;
@property (weak, nonatomic) IBOutlet MZDayPicker *dayPicker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subjectCollectionViewTopConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subjectCollectionViewHeight;

@end

@implementation AssignmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self customInitialization];   
}

- (void)viewDidUnload {
    [self setDayPicker:nil];
    [super viewDidUnload];
}

#pragma MARK: Helper Methods

-(void)customInitialization {
    
    //Navigation Bar
    self.title = @"Assignment";
    
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    
    //Initialize Modal Obj
    modalObj = [AssignmentInfoModal new];
    
    modalObj.assignmentType = @"0";
    modalObj.selectedSubjectInCurrent = 0;
    modalObj.selectedSubjectInHistory = 0;
    modalObj.assignmentDate = [PAUtility getStringFromDate:[NSDate date]];

    [self.seeMoreButton setHidden:YES];

    //Method to call when orientation is changed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedPDFData:) name:@"PDFDATA" object:nil];

    //Register collection cell
    [self.subjectsCollectionView registerNib:[UINib nibWithNibName:@"AssignmentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AssignmentCollectionViewCell"];
    
    //Register TableView Cell
    [self.assignmentsTableView registerNib:[UINib nibWithNibName:@"AssignmentTableViewCell" bundle:nil] forCellReuseIdentifier:@"AssignmentTableViewCell"];
    self.assignmentsTableView.alwaysBounceVertical = NO;
    
    //Initial Element Layout
    getCornerView(self.segmentView,18.0f);
    
    self.currentButton.backgroundColor =  [UIColor colorWithRed:(51.0/255.0) green:(189.0/255.0) blue:(250.0/255.0) alpha:1.0f];
    [self.historyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.historyButton.backgroundColor = [UIColor clearColor];
    self.subjectCollectionViewTopConstraint.constant = 45;
    self.dayPicker.hidden = YES;
    
    //Initialize Arrays
    subjectsArray = [NSMutableArray new];
    subjectsArrayForHistory = [NSMutableArray new];
    assignmentRecentArray = [NSMutableArray new];
    assignmentPreviousArray = [NSMutableArray new];
    segmentIndex = 0;
    
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    
    self.dayPicker.dayNameLabelFontSize = 13.0f;
    self.dayPicker.dayLabelFontSize = 13.0f;
    
    //Initalise For Pagination
    recentPagination = [Pagination new];
    recentPagination.pageNumber = 0;
    
    previousPagination = [Pagination new];
    previousPagination.pageNumber = 0;
    
    
    [self.dayPicker setStartDate:[self getPreviousDateFromCurrentDate:-2] endDate:[NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)]];
    [self.dayPicker setCurrentDate:[NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)] animated:NO];

    //Call Subject API
    [self callAPIForSubjectList:@"0"];
}

-(NSDate *)getPreviousDateFromCurrentDate:(NSInteger)previousMonth {
    
    NSDateComponents *comps = [NSDateComponents new];
    comps.month = previousMonth;

    return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:[NSDate date] options:0];
}

#pragma Picker Delegates

- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EE"];
    
    return [dateFormatter stringFromDate:day.date];
}

- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    modalObj.assignmentDate = [PAUtility getStringFromDate:day.date];
    
    previousPagination.pageNumber = 0;
    [assignmentPreviousArray removeAllObjects];
    
    [self callAPIForAssignmentList:previousPagination andSegmentType:[NSString stringWithFormat:@"%ld",(long)segmentIndex]];
}

- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
{
   // NSLog(@"Will select day %@",day.day);
}


#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (segmentIndex == 0)
        return [assignmentRecentArray count];
    else
        return [assignmentPreviousArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssignmentTableViewCell *cell = (AssignmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AssignmentTableViewCell" forIndexPath:indexPath];

    // when api called
    AssignmentInfoModal *assignmentObj =  (segmentIndex == 0)?[assignmentRecentArray objectAtIndex:indexPath.row]:[assignmentPreviousArray objectAtIndex:indexPath.row];
    
    cell.assignmentNameLabel.text  = assignmentObj.assignmentName;
    cell.assignmentImageView.image = [UIImage imageNamed:@"exam"];
    
    [cell.moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([assignmentObj.contentData length]) {
      [cell.saveButton setAlpha:1];
        [cell.saveButton setEnabled:YES];
    }
    else {
        [cell.saveButton setAlpha:0.5];
        [cell.saveButton setEnabled:NO];
    }

    cell.saveButton.tag = 100+ indexPath.row;
    [cell.saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.assignmentDescriptionLabel.text = assignmentObj.assignmentDescriptionWithoutDetail;

    [cell.moreButton setHidden: assignmentObj.isTextMore];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    AssignmentInfoModal *assignmentObj =  (segmentIndex == 0)?[assignmentRecentArray objectAtIndex:indexPath.row]:[assignmentPreviousArray objectAtIndex:indexPath.row];
    //
    //    [self showDescription:assignmentObj];
}

-(void)moreAction:(UIButton *)sender {
    
    CGPoint buttonPoint = [sender convertPoint:CGPointZero toView:self.assignmentsTableView];
    NSIndexPath *tappedIP = [self.assignmentsTableView indexPathForRowAtPoint:buttonPoint];
    
    AssignmentInfoModal *assignmentObj =  (segmentIndex == 0)?[assignmentRecentArray objectAtIndex:tappedIP.row]:[assignmentPreviousArray objectAtIndex:tappedIP.row];
    [self showDescription:assignmentObj];
}

-(void)showDescription:(AssignmentInfoModal *)assignmentDescription {
    
    if ([assignmentDescription.assignmentDetail length]) {
        
        ShowDescriptionWebView *showDescription = [[ShowDescriptionWebView alloc]initWithNibName:@"ShowDescriptionWebView" bundle:nil];
        
        showDescription.assignmentDescription = assignmentDescription;
        showDescription.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
        [self.navigationController presentViewController:showDescription animated:NO completion:nil];
    }
    else
        [OPRequestTimeOutView showWithMessage:@"Description not available." forTime:3.0 andController:self];
}

#pragma mark: UICollectionView Delegate and Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (segmentIndex == 0)
        return [subjectsArray count];
    else
        return [subjectsArrayForHistory count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AssignmentCollectionViewCell* cell = [self.subjectsCollectionView  dequeueReusableCellWithReuseIdentifier:@"AssignmentCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    if(indexPath.row%2==0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    SubjectInfoModal *subjectObj;
    
    if (segmentIndex == 0)
        subjectObj = [subjectsArray objectAtIndex:indexPath.row];
    else
        subjectObj = [subjectsArrayForHistory objectAtIndex:indexPath.row];
    
    cell.nameOfSubjectLabel.text = subjectObj.subjectName;
    
    if (segmentIndex && (indexPath.row == modalObj.selectedSubjectInHistory)) {
            cell.nameOfSubjectLabel.textColor = RGBCOLOR(51, 189, 250, 1);
            cell.colorLabel.backgroundColor = RGBCOLOR(51, 189, 250, 1);
    }
    else if (!segmentIndex && indexPath.row == modalObj.selectedSubjectInCurrent){
            cell.nameOfSubjectLabel.textColor = RGBCOLOR(51, 189, 250, 1);
            cell.colorLabel.backgroundColor = RGBCOLOR(51, 189, 250, 1);
        
    }else {
        cell.nameOfSubjectLabel.textColor = [UIColor blackColor];
        cell.colorLabel.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SubjectInfoModal *subjectObj;
    
    if (segmentIndex == 0)
        subjectObj = [subjectsArray objectAtIndex:indexPath.item];
    else
       subjectObj = [subjectsArrayForHistory objectAtIndex:indexPath.item];

    modalObj.subjectID = subjectObj.subjectID;
    
    if (segmentIndex){
        previousPagination.pageNumber = 0;
        modalObj.selectedSubjectInHistory = indexPath.item;
        [assignmentPreviousArray removeAllObjects];
        
        [self callAPIForAssignmentList:previousPagination andSegmentType:[NSString stringWithFormat:@"%ld",(long)segmentIndex]];
    }else {
        recentPagination.pageNumber = 0;
        modalObj.selectedSubjectInCurrent = indexPath.item;
        [assignmentRecentArray removeAllObjects];
        
        [self callAPIForAssignmentList:recentPagination andSegmentType:[NSString stringWithFormat:@"%ld",(long)segmentIndex]];
    }
}

#pragma mark: UIButton Action

-(void)saveButtonAction:(UIButton *)sender
{
    AssignmentInfoModal *assignmentObj =  (segmentIndex == 0)?[assignmentRecentArray objectAtIndex:(sender.tag-100)]:[assignmentPreviousArray objectAtIndex:(sender.tag-100)];

    if ([assignmentObj.contentData length]) {

    AssignmentContentVC *receiptVCObj = [[AssignmentContentVC alloc]initWithNibName:@"AssignmentContentVC" bundle:nil];
    receiptVCObj.assignmentObj = assignmentObj;

    [self.navigationController pushViewController:receiptVCObj animated:YES];
    }
    else
        [OPRequestTimeOutView showWithMessage:@"Data not available." forTime:3.0 andController:self];
}

- (IBAction)seeMoreButtonAction:(id)sender {
    
    if (segmentIndex == 0 && recentPagination.pageNumber <= recentPagination.maxPages)
        [self callAPIForAssignmentList:recentPagination andSegmentType:[NSString stringWithFormat:@"%ld",(long)segmentIndex]];
    else if (segmentIndex == 1 && previousPagination.pageNumber <= previousPagination.maxPages) {
        [self callAPIForAssignmentList:previousPagination andSegmentType:[NSString stringWithFormat:@"%ld",(long)segmentIndex]];
    }
}

- (IBAction)segmentBtnAction:(id)sender {
    
    UIButton *segButton = sender;
    
    [self.currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.historyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.currentButton.backgroundColor = [UIColor clearColor];
    self.historyButton.backgroundColor = [UIColor clearColor];

    if(segButton.tag == 2)
        
    {
        segmentIndex = 1;
        
        self.historyButton.backgroundColor=[UIColor colorWithRed:(51.0/255.0) green:(189.0/255.0) blue:(250.0/255.0) alpha:1.0f];
     
        if ([subjectsArrayForHistory count]) {
            [self.subjectCollectionViewHeight setConstant:45];
        }else {
            [self.subjectCollectionViewHeight setConstant:0];
        }
        
        self.subjectCollectionViewTopConstraint.constant = 110;
        self.dayPicker.hidden =  NO;
        modalObj.assignmentDate = [PAUtility getStringFromDate:[NSDate date]];
        
        [self.subjectsCollectionView reloadData];
        [_assignmentsTableView reloadData];
    }
    
    else if (segButton.tag == 1)
    {
        segmentIndex = 0;
        
        self.currentButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(189.0/255.0) blue:(250.0/255.0) alpha:1.0f];
        
        if ([subjectsArray count]) {
            [self.subjectCollectionViewHeight setConstant:45];
        }else {
            [self.subjectCollectionViewHeight setConstant:0];
        }
        self.subjectCollectionViewTopConstraint.constant = 45;
        self.dayPicker.hidden = YES;
        
        [self.subjectsCollectionView reloadData];
        [_assignmentsTableView reloadData];
    }
    
    if (segmentIndex == 0 && [assignmentRecentArray count] == 0 && recentPagination.pageNumber <= recentPagination.maxPages) {
        self.currentButton.enabled = NO;
        self.historyButton.enabled = NO;
        [self callAPIForAssignmentList:recentPagination andSegmentType:[NSString stringWithFormat:@"%ld",(long)segmentIndex]];
    }
    else if (segmentIndex == 1 && [assignmentPreviousArray count] == 0 && previousPagination.pageNumber <= previousPagination.maxPages) {
        
//        SubjectInfoModal *subjectObj = [subjectsArray firstObject];
//        modalObj.subjectID = subjectObj.subjectID;
        
        self.currentButton.enabled = NO;
        self.historyButton.enabled = NO;
        [self callAPIForSubjectList:@"1"];
        
    }else if (segmentIndex == 1 && [assignmentPreviousArray count] == 0) {
        
        [self setLabelBetweenTable:MessageWhenNoData];
        [self.subjectsCollectionView reloadData];
        [_assignmentsTableView reloadData];
        
    }else if (segmentIndex == 0 && [assignmentRecentArray count] == 0) {
        
        [self setLabelBetweenTable:MessageWhenNoData];
        [self.subjectsCollectionView reloadData];
        [_assignmentsTableView reloadData];
        
    }else {
        self.assignmentsTableView.backgroundView = nil;

        [self.subjectsCollectionView reloadData];
        [_assignmentsTableView reloadData];
    }
    
    //[self.dayPicker reloadData];
}

#pragma MARK: UIButtonActions

-(void)leftBarButtonAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForSubjectList:(NSString *)type {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:type forKey:@"type"];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiSubjectList andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            NSArray *subjectTempArray = [result objectForKeyNotNull:pSubjectList expectedObj:[NSArray array]];
            
            for (NSDictionary *subjectDict in subjectTempArray)
                [[type boolValue]?subjectsArrayForHistory:subjectsArray addObject:[SubjectInfoModal parseSubjectInfo:subjectDict]];
            
            if ([[type boolValue]?subjectsArrayForHistory:subjectsArray count]) {
                SubjectInfoModal *subjectObj = [[type boolValue]?subjectsArrayForHistory:subjectsArray firstObject];
                modalObj.subjectID = subjectObj.subjectID;
                
                [self.subjectsCollectionView reloadData];
                [self.subjectCollectionViewHeight setConstant:45];

                self.currentButton.enabled = NO;
                self.historyButton.enabled = NO;
                [self callAPIForAssignmentList:[type boolValue]?previousPagination:recentPagination andSegmentType:type];
                
            }else {
                [self.subjectsCollectionView reloadData];
                [self.subjectCollectionViewHeight setConstant:0];
                
                recentPagination.pageNumber = 1;

                [self setLabelBetweenTable:MessageWhenNoData];
                self.currentButton.enabled = YES;
                self.historyButton.enabled = YES;
            }
        }else
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
    }];
}

-(void)callAPIForAssignmentList:(Pagination *)page  andSegmentType:(NSString *)type{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:modalObj.subjectID      forKey:pSubjectID];
    [params setValue:modalObj.assignmentDate forKey:cpDate];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)segmentIndex] forKey:cpType];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)page.pageNumber+1] forKey:cpPageNumber];
    [params setValue:@"5" forKey:cpPageSize];
    
    [[[ServiceHelper alloc]init] PostAPICallWithParameter:params apiName:apiAssignmentList andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            //For Remove the previous one if  calling 1 page again
            if (segmentIndex == 0 && recentPagination.pageNumber == 0)
                [assignmentRecentArray removeAllObjects];
            
            else if (segmentIndex == 1 && previousPagination.pageNumber == 0)
                [assignmentPreviousArray removeAllObjects];
            
            NSArray *assignmentTempArray = [result objectForKeyNotNull:pAssignmentList expectedObj:[NSArray array]];
            
            for (NSDictionary *assignmentDict in assignmentTempArray)
                [(segmentIndex == 0)?assignmentRecentArray:assignmentPreviousArray addObject:[AssignmentInfoModal parseAssignmentInfo :assignmentDict]];
            
            //for Pagination Detail
            if (segmentIndex == 0)
                recentPagination = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            else if (segmentIndex == 1)
                previousPagination = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            
            if (segmentIndex == 0) {
           
                if (recentPagination.pageNumber >= recentPagination.maxPages)
                    [self.seeMoreButton setHidden:YES];
                else
                    [self.seeMoreButton setHidden:NO];
                
                //Set Message if data is blank
                if ([assignmentRecentArray count] == 0)
                    [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
                else
                    self.assignmentsTableView.backgroundView = nil;
                
            }else {
                
                if (previousPagination.pageNumber >= previousPagination.maxPages)
                    [self.seeMoreButton setHidden:YES];
                else
                    [self.seeMoreButton setHidden:NO];
                
                //Set Message if data is blank
                if ([assignmentPreviousArray count] == 0)
                    [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
                else
                    self.assignmentsTableView.backgroundView = nil;
            }
            
            self.currentButton.enabled = YES;
            self.historyButton.enabled = YES;
            
            if ([[type boolValue]?subjectsArrayForHistory:subjectsArray count]) {
                [self.subjectCollectionViewHeight setConstant:45];
            }else {
                [self.subjectCollectionViewHeight setConstant:0];
            }

            [self.subjectsCollectionView reloadData];
            [self.assignmentsTableView reloadData];
        }else
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
    }];
}

#pragma mark - Show Message On Data Blank

-(void)setLabelBetweenTable:(NSString *)displayMessage {
    
    UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.assignmentsTableView.bounds.size.width,  self.assignmentsTableView.bounds.size.height)];
    noDataLabel.text             = displayMessage;
    noDataLabel.textColor        = [UIColor darkGrayColor];
    noDataLabel.textAlignment    = NSTextAlignmentCenter;
    self.assignmentsTableView.backgroundView = noDataLabel;
}

-(void)loadedPDFData :(NSNotificationCenter *)notificationInfo {
    [self.assignmentsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PDFDATA" object:nil];
}

@end
