//
//  NotificationVC.m
//  ParentApp
//
//  Created by PRIYANKA JAISWAL on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "NotificationVC.h"
#import "Pagination.h"
#import "PAUtility.h"

static NSString *CellIdentifier = @"NotificationTVCell";

@interface NotificationVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *notificationArray;
    Pagination *pagination;
}

@property (strong, nonatomic) IBOutlet UITableView *notificationTableView;
@property (strong, nonatomic) IBOutlet UIView *notificationfooterview;

@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

@end

@implementation NotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetUp];
}

-(void)initialSetUp {
    
    //Set navigation
    self.title = @"Notifications";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");

    //Register Cell and set footer
    _notificationTableView.tableFooterView = _notificationfooterview;
    [self.notificationTableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    self.notificationTableView.alwaysBounceVertical = NO;
    self.notificationTableView.estimatedRowHeight = 99.0;
    notificationArray = [NSMutableArray array];
    
    //Initalise For Pagination
    pagination = [Pagination new];
    pagination.pageNumber = 0;
    
    //Call Notification List
    [self callAPIForNotificationList:pagination];
}

#pragma mark - Table View Datasource.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [notificationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTVCell *cell = (NotificationTVCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = RGBCOLOR(238, 238, 238, 1);

    NotificationModal *notificationModal = [notificationArray objectAtIndex:indexPath.row];
    cell.notificationTitlelabel.text = notificationModal.notificationTitle;
    cell.notificationImageView.image = [UIImage imageNamed:@"notification2"];
    cell.notificationDescriptionlabel.text = notificationModal.notificationDescription;
    cell.notificationDateTimelabel.text = [NSString stringWithFormat:@"%@, %@",notificationModal.notificationDate,notificationModal.notificationTime];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationModal *notificationModal = [notificationArray objectAtIndex:indexPath.row];

    switch ([notificationModal.notificationType intValue]) {
        case 0: {
            // BirthDay VC
        }
            break;
        case 1: {
            ActivityViewController *activityVC = [[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
            activityVC.fromNotification = YES;
            [self.navigationController pushViewController:activityVC animated:YES];
        }
          break;
        case 2: {
            AssignmentViewController *assignmentVC = [[AssignmentViewController alloc] initWithNibName:@"AssignmentViewController" bundle:nil];
            [self.navigationController pushViewController:assignmentVC animated:YES];
        }
          break;
        case 3: {
            PAAttendanceViewController *examVCObj = [[PAAttendanceViewController alloc]initWithNibName:@"PAAttendanceViewController" bundle:nil];
            [self.navigationController pushViewController:examVCObj animated:YES];
        }
           break;
        case 4: {
            CircularViewController *circularVC = [[CircularViewController alloc] initWithNibName:@"CircularViewController" bundle:nil];
            [self.navigationController pushViewController:circularVC animated:YES];
        }
          break;
        case 5: {
            PADesciplineViewController *disciplineVC = [[PADesciplineViewController alloc]initWithNibName:@"PADesciplineViewController" bundle:nil];
            [self.navigationController pushViewController:disciplineVC animated:YES];
        }
          break;
        case 6: {
            ExaminationVC *examVC = [[ExaminationVC alloc] initWithNibName:@"ExaminationVC" bundle:nil];
            examVC.fromNotification = YES;
            [self.navigationController pushViewController:examVC animated:YES];
        }
          break;
        case 7: {
            PAFeesViewController *feesVC = [[PAFeesViewController alloc] initWithNibName:@"PAFeesViewController" bundle:nil];
            [self.navigationController pushViewController:feesVC animated:YES];
        }
         break;
        case 8: {
            InfirmaryViewController *infirmaryVC = [[InfirmaryViewController alloc] initWithNibName:@"InfirmaryViewController" bundle:nil];
            infirmaryVC.fromNotification = YES;
            [self.navigationController pushViewController:infirmaryVC animated:YES];
        }
           break; 
        case 10: {
            PARouteDetailsViewController *transportVC = [[PARouteDetailsViewController alloc] initWithNibName:@"PARouteDetailsViewController" bundle:nil];
            transportVC.fromNotification = YES;
            [self.navigationController pushViewController:transportVC animated:YES];
        }
            break;
        case 11: {
            CommunicationViewController *communicationVC = [[CommunicationViewController alloc] initWithNibName:@"CommunicationViewController" bundle:nil];
            communicationVC.fromNotification = YES;
            [self.navigationController pushViewController:communicationVC animated:YES];
        }
            break;
        case 12: {
            PAFeesViewController *feesVC = [[PAFeesViewController alloc] initWithNibName:@"PAFeesViewController" bundle:nil];
            [self.navigationController pushViewController:feesVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UITableView Delegate Method.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


-(void)leftBarButtonAction:(UIButton *)sender {
    
    [self.delegate callDashBoardApi];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)seeMoreButton:(id)sender {
    if (pagination.pageNumber < pagination.maxPages)
            [self callAPIForNotificationList:pagination];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForNotificationList:(Pagination *)page {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:[NSString stringWithFormat:@"%ld",(long)page.pageNumber+1] forKey:cpPageNumber];
    [params setValue:@"6" forKey:cpPageSize];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiNotification andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {

            //For Presenting data instantly
            self.notificationTableView.delegate = self;
            self.notificationTableView.dataSource = self;
            
            if (pagination.pageNumber == 0)
                [notificationArray removeAllObjects];
            
            pagination = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            
            NSArray *notificationListArray = [result objectForKeyNotNull:pNotificationList expectedObj:[NSArray array]];
            
            for (NSDictionary *notificationDict in notificationListArray)
                [notificationArray addObject:[NotificationModal parseNotificationList:notificationDict]];

            if ([notificationArray count] == 0) {
                UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.notificationTableView.bounds.size.width,  self.notificationTableView.bounds.size.height)];
                noDataLabel.text             = [result objectForKey:cpResponseMessage];
                noDataLabel.textColor        = [UIColor darkGrayColor];
                noDataLabel.textAlignment    = NSTextAlignmentCenter;
                self.notificationTableView.backgroundView = noDataLabel;
            }else
                self.notificationTableView.backgroundView = nil;
            
            [self.notificationTableView reloadData];

            if (pagination.pageNumber >= pagination.maxPages)
                [self.seeMoreButton setHidden:YES];
            else
                [self.seeMoreButton setHidden:NO];
            
           // [self performSelector:@selector(tableReload) withObject:self afterDelay:1];
        
        }else
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
    }];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableReload {
    [self.notificationTableView reloadData];
}

@end
