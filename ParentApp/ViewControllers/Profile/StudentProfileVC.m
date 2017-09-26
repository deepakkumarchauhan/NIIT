//
//  StudentProfileVC.m
//  ParentApp
//
//  Created by PRIYANKA JAISWAL on 31/08/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "Macro.h"

static NSString *CellIdentifier = @"StudentProfileTVCell";

@interface StudentProfileVC () <UITableViewDelegate, UITableViewDataSource >
{
    StudentProfileInfo * studentInfoObj;
}

@property (strong, nonatomic) IBOutlet UITableView *rootTableView;
@property (strong, nonatomic) IBOutlet UITableView *studentDetailTableView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIView *rootTableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *rootTableFooterView;

@end

@implementation StudentProfileVC

#pragma mark - View Life Cycle Method.

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initialLoad];
}

#pragma mark - Helper Methods.

-(void)initialLoad {
    
    self.title = @"Student Profile";

    _rootTableView.tableHeaderView = _rootTableHeaderView;
    _rootTableView.tableFooterView = _rootTableFooterView;
    self.studentDetailTableView.layer.borderWidth = 1.0;
    
    [self.studentDetailTableView.layer setBorderColor:[UIColor redColor].CGColor];
    [self.studentDetailTableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    self.studentDetailTableView.estimatedRowHeight = 44;
    
    [self callAPIForStudentDetail];
}

#pragma mark - Memory Management Method.

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Datasource.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StudentProfileTVCell *cell = (StudentProfileTVCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    switch (indexPath.row) {
        case 0: {
            cell.detailTitleLabel.text = @"Enrollment Number";
            cell.detailLabel.text = studentInfoObj.enrollmentNumber;
        }
            break;
        case 1: {
            cell.detailTitleLabel.text = @"Student Name";
           cell.detailLabel.text = studentInfoObj.studentName;
        }
            break;
        case 2: {
            cell.detailTitleLabel.text = @"Standard";
           cell.detailLabel.text = studentInfoObj.standard;
        }
            break;
        case 3: {
            cell.detailTitleLabel.text = @"Section";
           cell.detailLabel.text = studentInfoObj.section;
        }
            break;
        case 4: {
            cell.detailTitleLabel.text = @"Roll Number";
         cell.detailLabel.text = studentInfoObj.rollNumber;
        }
            break;
        case 5: {
            cell.detailTitleLabel.text = @"Date of Birth";
          cell.detailLabel.text = studentInfoObj.dOB;
        }
            break;
        case 6: {
            cell.detailTitleLabel.text = @"Parent Mobile Number";
          cell.detailLabel.text = studentInfoObj.parentMobileNumber;
        }
            break;
        case 7: {
            cell.detailTitleLabel.text = @"Address";
           cell.detailLabel.text = studentInfoObj.address;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate Method.

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
       return UITableViewAutomaticDimension;
}

#pragma mark - UIButton Action Methods.

- (IBAction)menuButtonAction:(UIButton *)sender {
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForStudentDetail {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"1311000001" forKey:cpStudentID];
    [params setValue:@"2015" forKey:cpSessionID];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiStudentDetail cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            studentInfoObj = [StudentProfileInfo parseStudentInfo:result];
            
            [self.studentDetailTableView reloadData];
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0];
        }
    }];
}

@end
