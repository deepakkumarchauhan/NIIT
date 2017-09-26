//
//  DesciplineViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 03/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PADesciplineViewController.h"
#import "PAUtility.h"

@interface PADesciplineViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{

    NSMutableArray   *desciplineRecentArray;
    NSMutableArray   *desciplinePreviousArray;
    
    NSInteger selectedIndex;
}

@property (weak, nonatomic) IBOutlet UITableView  *desciplineTableView;
@property (weak, nonatomic) IBOutlet UIView       *segmentView;

@property (weak, nonatomic) IBOutlet UIButton     *recentButton;
@property (weak, nonatomic) IBOutlet UIButton     *previousButton;

@end

@implementation PADesciplineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self intialSetUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}


#pragma MARK: Helper Methods

-(void)intialSetUp {
    
    //Navigation
    self.title = @"Discipline";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");

    //Register Cell
    [self.desciplineTableView registerNib:[UINib nibWithNibName:@"DesciplineTableViewCell" bundle:nil] forCellReuseIdentifier:@"DesciplineTableViewCell"];
    self.desciplineTableView.alwaysBounceVertical = NO;
    
    //Set Segement Item color and layout
    self.segmentView.layer.cornerRadius=18.0f;
    self.segmentView.clipsToBounds = YES;
    self.recentButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(189.0/255.0) blue:(250.0/255.0) alpha:1.0f];
    
    [self.previousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.recentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.previousButton.backgroundColor = [UIColor clearColor];
    
    //Itialise the discipline Array
    desciplineRecentArray = [NSMutableArray array];
    desciplinePreviousArray = [NSMutableArray array];
    selectedIndex = 0;
    
    //Call Api for Recent Discipline
    [self callAPIForDisciplineList];
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedIndex == 0)
        return [desciplineRecentArray count];
   else
    return [desciplinePreviousArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DesciplineTableViewCell *disciplineCell = (DesciplineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DesciplineTableViewCell" forIndexPath:indexPath];
    
    if(indexPath.row%2 == 0)
        disciplineCell.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    else
        disciplineCell.backgroundColor = [UIColor whiteColor];

    PADesciplineInfo *disciplineInfo = (selectedIndex == 0)?[desciplineRecentArray objectAtIndex:indexPath.row]:[desciplinePreviousArray objectAtIndex:indexPath.row];

    disciplineCell.dateLabel.text = disciplineInfo.date;
    disciplineCell.actionLabel.text = disciplineInfo.actionPoints;
    disciplineCell.reasonLabel.text = disciplineInfo.reason;
    disciplineCell.teacherLabel.text = disciplineInfo.techerName;
    disciplineCell.cardLabel.text = disciplineInfo.card;
    
    return disciplineCell;
}

#pragma MARK: UIButton Action

- (IBAction)segmentBtnAction:(UIButton *)sender {

    if(sender.tag == 2)
    {
        selectedIndex = 1;
        self.previousButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(189.0/255.0) blue:(250.0/255.0) alpha:1.0f];
        [self.recentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.previousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.recentButton.backgroundColor = [UIColor clearColor];
    }
    
    else if (sender.tag == 1)
    {
        selectedIndex = 0;
        self.recentButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(189.0/255.0) blue:(250.0/255.0) alpha:1.0f];
        [self.previousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.recentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.previousButton.backgroundColor = [UIColor clearColor];
    }

    if (selectedIndex == 0 && [desciplineRecentArray count] == 0) {
        [self setLabelBetweenTable:MessageWhenNoData];
        [self callAPIForDisciplineList];

    }
    else if (selectedIndex == 1 && [desciplinePreviousArray count] == 0) {
        [self setLabelBetweenTable:MessageWhenNoData];
        [self callAPIForDisciplineList];

    }
    else {
        self.desciplineTableView.backgroundView = nil;
        [_desciplineTableView reloadData];
    }
}

#pragma MARK: UIButtonActions

-(void)leftBarButtonAction:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForDisciplineList {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:[NSString stringWithFormat:@"%ld",(long)selectedIndex] forKey:cpType];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiDiscipline andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
       
            //For Presenting data instantly
            self.desciplineTableView.delegate = self;
            self.desciplineTableView.dataSource = self;
            self.segmentView.hidden = NO;
            
            //For Set Data on previous and recent tab
            NSArray *disciplineListArray = [result objectForKeyNotNull:pDisciplineList expectedObj:[NSArray array]];
            
            for (NSDictionary *disciplineDict in disciplineListArray) {
                if (selectedIndex == 0)
                    [desciplineRecentArray addObject:[PADesciplineInfo getDesciplineInfo:disciplineDict]];
                else  if (selectedIndex == 1)
                    [desciplinePreviousArray addObject:[PADesciplineInfo getDesciplineInfo:disciplineDict]];
            }
            
            //Set Message if data is blank
            if (selectedIndex == 0 && [desciplineRecentArray count] == 0)
                [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
            else if (selectedIndex == 1 && [desciplinePreviousArray count] == 0)
                [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
            else
                self.desciplineTableView.backgroundView = nil;
            
            //Show data on UI
            [self.desciplineTableView reloadData];
        }else
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
    }];
}

#pragma mark - Show Message On Data Blank

-(void)setLabelBetweenTable:(NSString *)displayMessage {
    
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.desciplineTableView.bounds.size.width,  self.desciplineTableView.bounds.size.height)];
        noDataLabel.text             = displayMessage;
        noDataLabel.textColor        = [UIColor darkGrayColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.desciplineTableView.backgroundView = noDataLabel;
}

@end
