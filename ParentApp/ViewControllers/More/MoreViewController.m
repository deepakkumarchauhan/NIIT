//
//  MoreViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 14/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "MoreViewController.h"
#import "PAUtility.h"
#import "Header.h"

@interface MoreViewController ()

@property (weak, nonatomic) IBOutlet UITableView *moreTableView;

@property (nonatomic, strong) NSMutableIndexSet  *expandedSections;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self customInitialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customInitialization{
    
    //Navigation Bar
    self.title = @"More";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");
    self.navigationController.navigationBarHidden = NO;
    
    //Register Cells
    [self.moreTableView registerNib:[UINib nibWithNibName:@"MoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreTableViewCell"];
    self.moreTableView.alwaysBounceVertical = NO;
    
    //Alloc for expanded cells
    self.expandedSections = [[NSMutableIndexSet alloc] init];
}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.expandedSections containsIndex:section])
        return 4;// return rows when expanded
    else
        return 1;// Return the number of rows in the section.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreTableViewCell *cell = (MoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MoreTableViewCell" forIndexPath:indexPath];
    cell.notificationSwitch.hidden = YES;
    [cell.dropDownButton setHidden:NO];

    if (!indexPath.row) {

        [cell.imageViewLeftConstraint setConstant:8];
        [cell.buttomLabel setHidden:YES];
        
        if(indexPath.section%2 == 0)
            cell.backgroundColor = [UIColor whiteColor];
        else
            cell.backgroundColor = RGBCOLOR(238, 238, 238, 1);
        
        [cell.dropDownButton setImage:[UIImage imageNamed:@"right2"] forState:UIControlStateNormal];

        switch (indexPath.section) {
            case 0:
                cell.leftImageView.image = [UIImage imageNamed:@"info"];
                cell.titleLabel.text = @"About School";
                break;
            case 1:
                cell.leftImageView.image = [UIImage imageNamed:@"phone"];
                cell.titleLabel.text = @"Contact Us";
                break;
            case 2:
                cell.leftImageView.image = [UIImage imageNamed:@"feedback"];
                cell.titleLabel.text = @"Feedback";
                break;
            case 3:
                cell.leftImageView.image = [UIImage imageNamed:@"setting"];
                cell.titleLabel.text = @"Settings";
                [cell.dropDownButton setImage:[UIImage imageNamed:@"down2"] forState:UIControlStateNormal];

                break;
            default:
                break;
        }
        
    } else {
        [cell.imageViewLeftConstraint setConstant:60];
        [cell.buttomLabel setHidden:NO];
        [cell.titleLabel setTextColor:[UIColor grayColor]];

        switch (indexPath.row) {
            case 1: {
                
                NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
                
                cell.leftImageView.image = [UIImage imageNamed:@"notification3"];
                cell.titleLabel.text = @"Notifications";
                cell.dropDownButton.hidden = YES;
                cell.notificationSwitch.hidden = NO;
                [cell.notificationSwitch addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
                
                [cell.notificationSwitch setOn:[[studentDict valueForKey:@"notificationStatus"] boolValue]];
            }
                break;
            case 2:
                cell.leftImageView.image = [UIImage imageNamed:@"user2"];
                cell.titleLabel.text = @"Privacy";
                [cell.dropDownButton setImage:[UIImage imageNamed:@"right2"] forState:UIControlStateNormal];
                break;
            case 3:
                cell.leftImageView.image = [UIImage imageNamed:@"support"];
                cell.titleLabel.text = @"Support";
                [cell.dropDownButton setImage:[UIImage imageNamed:@"right2"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            AboutSchoolViewController *aboutSchoolVCObj = [[AboutSchoolViewController alloc]initWithNibName:@"AboutSchoolViewController" bundle:nil];
            aboutSchoolVCObj.contentObj = aboutSchool;
            [self.navigationController pushViewController:aboutSchoolVCObj animated:YES];
        }
            break;
        case 1:
        {
            ContactUsViewController *contactVCObj = [[ContactUsViewController alloc]initWithNibName:@"ContactUsViewController" bundle:nil];
            [self.navigationController pushViewController:contactVCObj animated:YES];
        }
            break;
        case 2:
        {
            FeedbackViewController *feedbackVCObj = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
            [self.navigationController pushViewController:feedbackVCObj animated:YES];
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                    [self performExpandCollapseForTableView:tableView forRowAtIndexPath:indexPath];
                    break;
                case 2:
                {
                    AboutSchoolViewController *aboutSchoolVCObj = [[AboutSchoolViewController alloc]initWithNibName:@"AboutSchoolViewController" bundle:nil];
                    aboutSchoolVCObj.contentObj = privacyPolicy;
                    [self.navigationController pushViewController:aboutSchoolVCObj animated:YES];
                }
                    break;
                case 3:
                {
                    AboutSchoolViewController *aboutSchoolVCObj = [[AboutSchoolViewController alloc]initWithNibName:@"AboutSchoolViewController" bundle:nil];
                    aboutSchoolVCObj.contentObj = support;
                    [self.navigationController pushViewController:aboutSchoolVCObj animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Expand/Collapse Section

- (void)performExpandCollapseForTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL currentlyExpanded = [self.expandedSections containsIndex:indexPath.section];
    NSInteger rows;
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    if (currentlyExpanded) {
        rows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        [self.expandedSections removeIndex:indexPath.section];
    } else {
        [self.expandedSections addIndex:indexPath.section];
        rows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    }
    
    for (int i = 1; i < rows; i ++) {
        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        [tmpArray addObject:tmpIndexPath];
    }
    
    SectionCellTableViewCell *cell = (SectionCellTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (currentlyExpanded) {
        [tableView deleteRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationMiddle];
        [UIView animateWithDuration:0.2 animations:^{
            cell.dropDownButton.transform = CGAffineTransformIdentity;
        } completion:nil];
        
    } else {
        [tableView insertRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationMiddle];
        [UIView animateWithDuration:0.2 animations:^{
            cell.dropDownButton.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
        } completion:nil];
    }
}

#pragma mark - Selector Method

- (void)valueChange:(id)sender{
    
    if([sender isOn]){
        [self callAPIForNotification:@"1"];
    } else{
        [self callAPIForNotification:@"0"];
    }
}

#pragma MARk: UIButton Actions

-(void)leftBarButtonAction:(UIButton*)sender{
    
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
}


#pragma mark - API Method

-(void)callAPIForNotification:(NSString*)onOffValue {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setValue:@"0" forKey:cpDeviceType];
    [params setValue:onOffValue forKey:cpisNotification];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiNotificationSet andController:self cache:NO withprogresHud:ISProgressNotShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            NSDictionary *studentDict =  [[NSUSERDEFAULT valueForKey:@"studentInformation"] mutableCopy];
            
            [studentDict setValue:[result valueForKey:@"isNotification"] forKey:@"notificationStatus"];
            
            [NSUSERDEFAULT setValue:studentDict forKey:@"studentInformation"];
            [NSUSERDEFAULT synchronize];
            
            [self.moreTableView reloadData];

        //    [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:2.0 andController:self];
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}



@end
