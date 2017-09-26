//
//  CircularDetailViewController.m
//  ParentApp
//
//  Created by Krati Agarwal on 15/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "Header.h"
#import "ShowDescriptionWebView.h"

@interface CircularDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *circularDetailsArray;
    Pagination *pagination;
}

// Table View
@property (weak, nonatomic) IBOutlet UITableView *circularDetailTableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

@end

@implementation CircularDetailViewController

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
    
    //Initalise
    circularDetailsArray = [NSMutableArray new];
    
    //Initalise For Pagination
    pagination = [[Pagination alloc] init];
    pagination.pageNumber = 0;
    
    //Register TableView Cell
    [self.circularDetailTableView registerNib:[UINib nibWithNibName:@"CircularDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"CircularDetailTableViewCell"];
    self.circularDetailTableView.alwaysBounceVertical = NO;
    self.circularDetailTableView.tableFooterView = self.headerView;
    
    //Call Circular List Api
    [self callAPIForCircularDetailList:pagination];
}

#pragma mark - UIButton Actions

- (IBAction)seeMoreButtonAction:(id)sender {
    
    if (pagination.pageNumber < pagination.maxPages)
        [self callAPIForCircularDetailList:pagination];
}

-(void)leftBarButtonAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [circularDetailsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CircularDetailTableViewCell *cell = (CircularDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CircularDetailTableViewCell" forIndexPath:indexPath];
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
        else
        cell.backgroundColor = RGBCOLOR(238, 238, 238, 1);

    cell.viewAndSaveButton.tag = indexPath.row + 1000;
    [cell.viewAndSaveButton addTarget:self action:@selector(viewButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //when api called
    CircularModel *circularData = [circularDetailsArray objectAtIndex:indexPath.row];
    
    cell.circularDescriptionLabel.text = circularData.circularDescription;
    cell.circularDateLabel.text = circularData.circularDate;
    cell.circularSubjectLabel.text = circularData.circularSubject;
    cell.circularImageView.image = [UIImage imageNamed:@"img"];

    [cell.moreButton setHidden:circularData.isTextMore];
    
    if ([circularData.convertedContentData length]) {
        [cell.viewAndSaveButton setAlpha:1];
        [cell.viewAndSaveButton setEnabled:YES];
    }
    else {
        [cell.viewAndSaveButton setAlpha:0.5];
        [cell.viewAndSaveButton setEnabled:NO];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    CircularModel *circularData = [circularDetailsArray objectAtIndex:indexPath.row];
    //
    //    [self showDescription:circularData];
}

-(void)moreAction:(UIButton *)sender {
    
    CGPoint buttonPoint = [sender convertPoint:CGPointZero toView:self.circularDetailTableView];
    NSIndexPath *tappedIP = [self.circularDetailTableView indexPathForRowAtPoint:buttonPoint];
    
    CircularModel *circularData = [circularDetailsArray objectAtIndex:tappedIP.row];
    
    [self showDescription:circularData];
}

-(void)showDescription:(CircularModel *)circularDescription {
    
    if ([circularDescription.circularDescription length]) {
        
        ShowDescriptionWebView *showDescription = [[ShowDescriptionWebView alloc]initWithNibName:@"ShowDescriptionWebView" bundle:nil];
        
        showDescription.circularDescriptionObj = circularDescription;
        showDescription.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
        [self.navigationController presentViewController:showDescription animated:NO completion:nil];
    }
    else
        [OPRequestTimeOutView showWithMessage:@"Description not available." forTime:3.0 andController:self];
}

-(void)viewButton:(UIButton *)sender {
    CircularModel *circularData = [circularDetailsArray objectAtIndex:sender.tag-1000];
    
    if ([circularData.convertedContentData length]) {
        AssignmentContentVC *receiptVCObj = [[AssignmentContentVC alloc]initWithNibName:@"AssignmentContentVC" bundle:nil];
        receiptVCObj.objCircularModal = circularData;
        
        [self.navigationController pushViewController:receiptVCObj animated:YES];
    }
    else
        [OPRequestTimeOutView showWithMessage:@"Data not available." forTime:3.0 andController:self];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForCircularDetailList:(Pagination *)page {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:[NSString stringWithFormat:@"%ld",(long)page.pageNumber+1] forKey:cpPageNumber];
    [params setValue:self.circularId forKey:pCircularID];
    [params setValue:@"5" forKey:cpPageSize];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiGetDetailsOfCirculars andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            //For Presenting data instantly
            _circularDetailTableView.delegate = self;
            _circularDetailTableView.dataSource = self;
            
            if (pagination.pageNumber == 0)
                [circularDetailsArray removeAllObjects];
            
            pagination = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            
            [circularDetailsArray addObjectsFromArray:[CircularModel parseCircularDetail:[result valueForKey:pCircularList]]];
            
            if ([circularDetailsArray count] == 0) {
                UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.circularDetailTableView.bounds.size.width,  self.circularDetailTableView.bounds.size.height)];
                noDataLabel.text             = [result objectForKey:cpResponseMessage];
                noDataLabel.textColor        = [UIColor darkGrayColor];
                noDataLabel.textAlignment    = NSTextAlignmentCenter;
                self.circularDetailTableView.backgroundView = noDataLabel;
            }else
                self.circularDetailTableView.backgroundView = nil;
            
            if (pagination.pageNumber >= pagination.maxPages)
                [self.seeMoreButton setHidden:YES];
            else
                [self.seeMoreButton setHidden:NO];
            
            [self.circularDetailTableView reloadData];
        } else
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
    }];
    
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
