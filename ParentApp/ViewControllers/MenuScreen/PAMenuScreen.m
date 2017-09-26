//
//  PAMenuScreen.m
//  ParentApp
//
//  Created by Abhishek Agarwal on 03/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PAMenuScreen.h"
#import "PAMenuCell.h"
#import "PAMenuModal.h"
#import "AppDelegate.h"
#import "PAUtility.h"
#import "PAFeesViewController.h"
#import "ExaminationVC.h"
#import "PARouteDetailsViewController.h"
#import "StudentProfileViewController.h"

static NSString *CELLIDENTIFIER = @"PAMenuCell";

@interface PAMenuScreen ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *menuArray;
    NSIndexPath *selectedIndexPath;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hieghtConstraints;
@property (strong, nonatomic) IBOutlet UIView *headerTableView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *studentImage;
@property (strong, nonatomic) IBOutlet UILabel *studentName;

@end

@implementation PAMenuScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Method to call when orientation is changed
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    //Naviagtion Bar hidden
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    //Register the tableView cell
    [self.tableView registerNib:[UINib nibWithNibName:@"PAMenuCell" bundle:nil] forCellReuseIdentifier:CELLIDENTIFIER];
    self.tableView.alwaysBounceVertical = NO;
    
    //Alloc menu item array
    menuArray = [NSMutableArray array];
    selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    NSDictionary *studentDict = [[NSUSERDEFAULT valueForKey:@"studentInformation"] mutableCopy];
    
    if ([[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] length]) {
        
        NSData* data = [[NSData alloc] initWithBase64EncodedString:[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] options:0];
        [self.studentImage setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    }else
        [self.studentImage setImage:[UIImage imageNamed:@"dummy"] forState:UIControlStateNormal];
    
    [self.studentName setText:[studentDict objectForKeyNotNull:pPIStudentName expectedObj:@""]];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    //Orientation Check
    [self customOrientationCheck];
}

#pragma mark - Tableview delegate and datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [menuArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath{
    
    PAMenuCell *menuCell = (PAMenuCell * )[self.tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
    menuCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    if (indexPath.row %2 == 0)
        menuCell.backgroundColor = [UIColor colorWithRed:123.0/255.0 green:152.0/255.0 blue:250.0/255.0 alpha:1];
    else
       menuCell.backgroundColor = [UIColor colorWithRed:140.0/255.0 green:163.0/255.0 blue:216.0/255.0 alpha:1];
    
    PAMenuModal *menuModal = [menuArray objectAtIndex:indexPath.row];
    
    menuCell.itemNameLabel.text = menuModal.itemName;
    [menuCell.itemImageView setImage:[UIImage imageNamed:menuModal.itemImage]];

    return menuCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    //update content view controller with setContentViewController
    
    PAMenuModal *menuModal = [menuArray objectAtIndex:indexPath.row];
    NSString *menuItemTitle  = menuModal.itemName;
    
    if ([menuItemTitle containsString:@"Home"]) {
        //Home
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"Add"]) {
        //Add School
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"Communication"]) {
        //Communication (Phase 2)
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"Calendar"]) {
        //Calendar
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"Activity"]) {
        //Activity (Phase 2)
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"Library"]) {
        //Library (Phase 2)
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"Transport"]) {
        //Discipline
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"Infirmary"]) {
        //Infirmary (Phase 2)
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"Gallery"]) {
        //Student Photo Gallery
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"Examination"]) {
        //Examination
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"My Profile"]) {
        //My Profile
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"Sibling"]) {
        //Switch Siblings
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"More"]) {
        //More (Not cleared in which phase)
        selectedIndexPath = indexPath;
        [itrSideMenu hideMenuViewController];

    }else if ([menuItemTitle containsString:@"Log"]) {
        selectedIndexPath = indexPath;
        //Logout
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Are you sure you want to logout?" andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes",@"No", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            
            if (index == 0) {
                NSMutableDictionary *logoutDictionary = [[NSMutableDictionary alloc] init];
                
                [logoutDictionary setValue:@"0" forKey:cpDeviceType];
                [logoutDictionary setValue:[[NSUserDefaults standardUserDefaults] valueForKey:cpDeviceToken] forKey:cpDeviceToken];
                
                [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:logoutDictionary apiName:apiLogout andController:self.navigationController cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
                    
                    if ([[result valueForKey:cpResponseCode] intValue] == 200) {
                        {
                            for (UINavigationController *navController in self.navigationController.viewControllers) {
                                if ([navController isKindOfClass:[PALoginViewController class]]) {
                                    [NSUSERDEFAULT setValue:[NSDictionary dictionary] forKey:@"studentInformation"];
                                    [self.navigationController popToViewController:navController animated:YES];
                                }
                            }
                        }
                    }
                    else
                        [OPRequestTimeOutView showWithMessage:[result objectForKey:cpResponseMessage] forTime:ErrorDisplayTime andController:self.navigationController];
                }];
            }
        }];
    }
}


#pragma MARK: Orientation Check

- (void)orientationChanged:(NSNotification *)notification {
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    [self.view setFrame:CGRectMake(0, 0, WINWIDTH, WINHEIGHT)];

    switch (orientation) {
            
        case UIInterfaceOrientationPortrait: case UIInterfaceOrientationPortraitUpsideDown:
            if (IS_IPAD)
                [self.hieghtConstraints setConstant:WINWIDTH/7.3+93];
            else
               [self.hieghtConstraints setConstant:WINWIDTH/5.4+93];
            break;
            
        case UIInterfaceOrientationLandscapeLeft: case UIInterfaceOrientationLandscapeRight:
            if (IS_IPAD)
                [self.hieghtConstraints setConstant:WINWIDTH/13+93];
            else
                [self.hieghtConstraints setConstant:WINHEIGHT/9.4+93];

            break;

        default:
            break;
    }
}

-(void)customOrientationCheck {

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    switch (orientation) {
            
        case UIInterfaceOrientationPortrait: case UIInterfaceOrientationPortraitUpsideDown:
            if (IS_IPAD)
                [self.hieghtConstraints setConstant:WINWIDTH/7.3+93];
            else
                [self.hieghtConstraints setConstant:WINWIDTH/5.4+93];
            break;
            
        case UIInterfaceOrientationLandscapeLeft: case UIInterfaceOrientationLandscapeRight:
            if (IS_IPAD)
                [self.hieghtConstraints setConstant:WINWIDTH/13+93];
            else
                [self.hieghtConstraints setConstant:WINHEIGHT/9.4+93];
            break;
            
        default:
            break;
    }
}

#pragma mark ITRAirSideMenu Delegate

- (void)sideMenu:(ITRAirSideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer {
    
    //NSLog(@"didRecognizePanGesture");
}

- (void)sideMenu:(ITRAirSideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController {
    
    [self callAPIMenuItems];

   // NSLog(@"willShowMenuViewController: %@ isMenuVisible <%d>", NSStringFromClass([menuViewController class]), (int)sideMenu.isLeftMenuVisible );
}

- (void)sideMenu:(ITRAirSideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController {
    
    //NSLog(@"didShowMenuViewController: %@ isMenuVisible <%d>", NSStringFromClass([menuViewController class]), (int)sideMenu.isLeftMenuVisible );
}

- (void)sideMenu:(ITRAirSideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController {
    
    //NSLog(@"willHideMenuViewController: %@ isMenuVisible <%d>", NSStringFromClass([menuViewController class]), (int)sideMenu.isLeftMenuVisible );
    
    UIViewController *selectedViewController;

    if (!selectedIndexPath)
        selectedViewController = (StudentProfileViewController *)[[StudentProfileViewController alloc]initWithNibName:@"StudentProfileViewController" bundle:nil];
    else {
        PAMenuModal *menuModal = ([menuArray count])?[menuArray objectAtIndex:selectedIndexPath.row]:[PAMenuModal new];
        NSString *menuItemTitle  = menuModal.itemName;
        
        if ([menuItemTitle containsString:@"Home"]) {
            //Home
            selectedViewController = (HomeViewController *)[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            
        }else if ([menuItemTitle containsString:@"Add"]) {
            //Add School
            selectedViewController = (PAAddSchoolViewController *)[[PAAddSchoolViewController alloc]initWithNibName:@"PAAddSchoolViewController" bundle:nil];
            
        }else if ([menuItemTitle containsString:@"Communication"]) {
            //Communication (Phase 2)
            selectedViewController = (CommunicationViewController *)[[CommunicationViewController alloc]initWithNibName:@"CommunicationViewController" bundle:nil];
            
        }else if ([menuItemTitle containsString:@"Calendar"]) {
            //Calendar
            //Calendar Screen
            selectedViewController = (PACalendarViewController *)[[PACalendarViewController alloc]initWithNibName:@"PACalendarViewController" bundle:nil];
            
        }else if ([menuItemTitle containsString:@"Activity"]) {
            //Activity (Phase 2)
          selectedViewController = (ActivityViewController *)[[ActivityViewController alloc]initWithNibName:@"ActivityViewController" bundle:nil];
            
        }else if ([menuItemTitle containsString:@"Library"]) {
            //Library (Phase 2)
            selectedViewController = (LibraryViewController *)[[LibraryViewController alloc]initWithNibName:@"LibraryViewController" bundle:nil];
            
        }else if ([menuItemTitle containsString:@"Transport"]) {
            //Transport
            selectedViewController = (PARouteDetailsViewController *)[[PARouteDetailsViewController alloc]initWithNibName:@"PARouteDetailsViewController" bundle:nil];
            
        }else if ([menuItemTitle containsString:@"Infirmary"]) {
            //Infirmary (Phase 2)
            selectedViewController = (InfirmaryViewController *)[[InfirmaryViewController alloc]initWithNibName:@"InfirmaryViewController" bundle:nil];
            
        }else if ([menuItemTitle containsString:@"Gallery"]) {
            //Student Photo Gallery
            selectedViewController = (GalleryVC *)[[GalleryVC alloc]initWithNibName:@"GalleryVC" bundle:nil];
            
        }else if ([menuItemTitle containsString:@"Examination"]) {
            //Examination
            selectedViewController = (ExaminationVC *)[[ExaminationVC alloc]initWithNibName:@"ExaminationVC" bundle:nil];
            
        }else if ([menuItemTitle containsString:@"My Profile"]) {
            //My Profile
            selectedViewController = (MyProfileViewController *)[[MyProfileViewController alloc]initWithNibName:@"MyProfileViewController" bundle:nil];
            
        }else if ([menuItemTitle containsString:@"Sibling"]) {
            //Switch Siblings
            selectedViewController = (SwitchSiblingViewController *)[[SwitchSiblingViewController alloc]initWithNibName:@"SwitchSiblingViewController" bundle:nil];

        }else if ([menuItemTitle containsString:@"More"]) {
            //More (Not cleared in which phase)
            selectedViewController = (MoreViewController *)[[MoreViewController alloc]initWithNibName:@"MoreViewController" bundle:nil];
        }
    }
    
    if (selectedViewController) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:selectedViewController];
        
        //Set naviagtion properties
        [[APPDELEGATE navController] setNavigationBarHidden:YES animated:YES];
        [navigationController setNavigationBarHidden:NO animated:YES];
        navigationController.navigationItem.hidesBackButton = YES;
        
        //Set Naviagtion Apperance
        [self setupDefaultApprience:navigationController];
        
        if ([navigationController respondsToSelector:@selector(edgesForExtendedLayout)])
            [navigationController setEdgesForExtendedLayout:UIRectEdgeNone];
        
        [sideMenu setContentViewController:navigationController];

    }
 }

- (void)sideMenu:(ITRAirSideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController {
    
   // NSLog(@"didHideMenuViewController: %@ isMenuVisible <%d>", NSStringFromClass([menuViewController class]), (int)sideMenu.isLeftMenuVisible );
}


#pragma mark - Set Navigation Apperance

-(void)setupDefaultApprience:(UINavigationController *)navigationController {
    
    //UINavigationBar
    navigationController.navigationBar.barTintColor = AppBlueColor;
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    navigationController.navigationBar.translucent = NO;
}

#pragma MARK: UIButtonActions

- (IBAction)profileButtonAction:(id)sender {
    selectedIndexPath = nil;
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu hideMenuViewController];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIMenuItems {
    
    //[self.view setFrame:CGRectMake(0, 0, WINWIDTH, WINHEIGHT)];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //([menuArray count])?ISProgressNotShown:ISProgressShown
    [[[ServiceHelper alloc]init] PostAPICallWithParameter:params apiName:apiMenuList andController:self.navigationController cache:NO withprogresHud:ISProgressNotShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            [menuArray removeAllObjects];
            NSArray *menuItemArray = [result objectForKeyNotNull:pMenuList expectedObj:[NSArray array]];
            
            for (NSDictionary *menuDict in menuItemArray) {
                
                PAMenuModal *menuModal = [[PAMenuModal alloc]init];
                NSString *menuItem = [menuDict objectForKeyNotNull:pMenuName expectedObj:@""];
            
                if ([menuItem containsString:@"Home"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon14";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"Add"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon6";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"Communication"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon12";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"Calendar"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon11";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"Activity"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon13";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"Library"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon10";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"Transport"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"icon2-1";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"Infirmary"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon8";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"Gallery"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon7";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"Examination"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"My Profile"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon5";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"Sibling"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon4";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"More"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon3";
                    [menuArray addObject:menuModal];

                }else if ([menuItem containsString:@"Log"]) {
                    
                    menuModal.itemName = menuItem;
                    menuModal.itemImage = @"menuicon2";
                    [menuArray addObject:menuModal];
                }
            }
            [self.tableView reloadData];
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self.navigationController];
        }
    }];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

@end
