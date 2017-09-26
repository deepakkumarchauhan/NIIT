//
//  ExaminationVC.m
//  ParentApp
//
//  Created by PRIYANKA JAISWAL on 03/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "ExaminationVC.h"
#import "PAExamination.h"
#import "Pagination.h"
#import "PAUtility.h"

static NSString *CellIdentifier = @"ExaminationTVCell";

@interface ExaminationVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *examDataSource;
    Pagination *pagination;
}

@property (strong, nonatomic) IBOutlet UITableView *examinationTableView;

@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

@end

@implementation ExaminationVC

#pragma mark - View Life Cycles Actions

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self initialSetUp];
    // Do any additional setup after loading the view from its nib.
}

-(void)initialSetUp {
    
    //Naviagtion set up
    self.title = @"Examination";
    if (self.fromNotification) {
        self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    }
    else
        self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");
    
    //Table Register
    [self.examinationTableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    _examinationTableView.alwaysBounceVertical = NO;
    
    //Method to call when orientation is changed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedPDFData:) name:@"PDFDATA" object:nil];
    
    //Examination array
    examDataSource = [NSMutableArray array];
    
    //Initalise For Pagination
    pagination = [[Pagination alloc] init];
    pagination.pageNumber = 0;
    
    [self.seeMoreButton setHidden:YES];

    //Call Api for Examination
    [self callAPIForExaminationList:pagination];
}

#pragma mark - Back Button Action

-(void)leftBarButtonAction:(UIButton *)sender {
    
    if (self.fromNotification) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
        [itrSideMenu presentLeftMenuViewController];
    }

}

#pragma mark - Table View Datasource.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [examDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExaminationTVCell *examCell = (ExaminationTVCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(indexPath.row%2==0)
        examCell.backgroundColor = [UIColor whiteColor];
    else
        examCell.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    examCell.saveButton.tag = indexPath.row + 1000;
    [examCell.saveButton addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    
    PAExamination *objExams = [examDataSource objectAtIndex:indexPath.row];
    examCell.examinationaTitleLabel.text = objExams.reportCaption;
    
    if (objExams.reportIsPublished) {
        [examCell.saveButton setAlpha:1];
       [examCell.saveButton setEnabled:YES];
    }
    else {
        [examCell.saveButton setAlpha:0.5];
        [examCell.saveButton setEnabled:NO];
    }
   
    return examCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //PAExamination *objExam = [examDataSource objectAtIndex:indexPath.row];
    //[self viewExamDetail:indexPath.row];
}

#pragma mark - UITableView Delegate Method.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark - UIButton Action.

-(void)saveButton:(UIButton *)sender {

    PAExamination *objExams = [examDataSource objectAtIndex:sender.tag-1000];
    
    if ([objExams.reportURL length]) {
        AssignmentContentVC *receiptVCObj = [[AssignmentContentVC alloc]initWithNibName:@"AssignmentContentVC" bundle:nil];
        receiptVCObj.objExamModal = objExams;
        [self.navigationController pushViewController:receiptVCObj animated:YES];
    }
    else
        [OPRequestTimeOutView showWithMessage:@"Data not available." forTime:3.0 andController:self];
}

- (IBAction)seeMoreButton:(id)sender {
    if (pagination.pageNumber < pagination.maxPages)
        [self callAPIForExaminationList:pagination];
}

#pragma mark - Chart Navigation Action

-(void)viewExamDetail:(NSInteger)index
{
//    PAExamination *objExam = [examDataSource objectAtIndex:index];
//    
//    ExamChartViewController *charObject  = [[ExamChartViewController alloc] initWithNibName:@"ExamChartViewController" bundle:nil];
//    charObject.objExamSelected = objExam;
//    [self.navigationController pushViewController:charObject animated:YES];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForExaminationList:(Pagination *)page {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:[NSString stringWithFormat:@"%ld",(long)page.pageNumber+1] forKey:cpPageNumber];
    [params setValue:@"5" forKey:cpPageSize];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiExamination andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            //For Presenting data instantly
            self.examinationTableView.delegate = self;
            self.examinationTableView.dataSource = self;
            
            if (pagination.pageNumber == 0)
                [examDataSource removeAllObjects];
            
            pagination = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            
            NSArray *examListArray = [result objectForKeyNotNull:pReport expectedObj:[NSArray array]];
            
            for (NSDictionary *examDict in examListArray)
                [examDataSource addObject:[PAExamination  parseExamData:examDict]];
            
            if ([examDataSource count] == 0) {
                UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.examinationTableView.bounds.size.width,  self.examinationTableView.bounds.size.height)];
                noDataLabel.text             = [result objectForKey:cpResponseMessage];
                noDataLabel.textColor        = [UIColor darkGrayColor];
                noDataLabel.textAlignment    = NSTextAlignmentCenter;
                self.examinationTableView.backgroundView = noDataLabel;
            }else
                self.examinationTableView.backgroundView = nil;

            if (pagination.pageNumber >= pagination.maxPages)
                [self.seeMoreButton setHidden:YES];
            else
                [self.seeMoreButton setHidden:NO];
            
            [self.examinationTableView reloadData];
        }else
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
    }];
}

#pragma Memeory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadedPDFData :(NSNotificationCenter *)notificationInfo {
    [self.examinationTableView reloadData];
}

@end
