//
//  HomeViewController.m
//  ParentApp
//
//  Created by Abhishek Agarwal on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionCell.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "PAUtility.h"
#import "HomeModal.h"

static NSString *CELLIDENTIFIER = @"HomeCollectionCell";

@interface HomeViewController () <UICollectionViewDelegate,UICollectionViewDataSource,notificationProtocol> {
    HomeModal *homeDetail;
    
    UILabel *notificationCount;
    BOOL isLandscape;
    NSTimer *notificationTimeCounter;
}

//Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHieghtConstraint;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

//Student Information
@property (weak, nonatomic) IBOutlet UIView *detailsView;

@property (strong, nonatomic) IBOutlet UIImageView *studentImageView;

@property (strong, nonatomic) IBOutlet UILabel *studentNameLable;
@property (strong, nonatomic) IBOutlet UILabel *studentSchoolLabel;
@property (strong, nonatomic) IBOutlet UILabel *studentSectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *studentAdmNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *admissionNumberLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    [self initialSetUp];
}

-(void)initialSetUp {
    
    //Navigation Items
    self.title = @"Home";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");
   self.navigationItem.rightBarButtonItem = [self rightBarButtonForController:self andImageStr:@"bell"];
    
    //Register collection cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:CELLIDENTIFIER];
    
    
  notificationTimeCounter =  [NSTimer scheduledTimerWithTimeInterval:30.0
                                     target:self
                                   selector:@selector(callApiToSetNotificationCount)
                                   userInfo:nil
                                    repeats:YES];
    
    [self callAPIForDashboardItems];

    //To Check weather phone is in potrait or landscape
    [self customOrientationCheck];
}


-(void)leftBarButtonAction:(UIButton *)sender {
    
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
}

- (void)rightBarButtonAction:(id)sender {
    
  // [OPRequestTimeOutView showWithMessage:@"Work In Progress" forTime:3.0 andController:self];

    //Notification Navigation
    NotificationVC *examVCObj = [[NotificationVC alloc]initWithNibName:@"NotificationVC" bundle:nil];
    notificationCount.hidden = YES;
    [notificationCount setText:@"0"];
    examVCObj.delegate = self;
    [self.navigationController pushViewController:examVCObj animated:YES];
}

-(UIBarButtonItem *) rightBarButtonForController : (id) controller andImageStr:(NSString *)imgStr {
    
    UIImage *buttonImage = [UIImage imageNamed:imgStr];
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 22.0f, 30.0f);
    [barButton setImage:buttonImage forState:UIControlStateNormal];
    [barButton setImage:buttonImage forState:UIControlStateSelected];
    [barButton setImage:buttonImage forState:UIControlStateHighlighted];
    
    notificationCount = [[UILabel alloc]initWithFrame:CGRectMake(12, -3, 18, 18)];
    [notificationCount setBackgroundColor:[UIColor redColor]];
    [notificationCount setFont:AppFont(10)];
    [notificationCount setTextAlignment:NSTextAlignmentCenter];
    [notificationCount setTextColor:[UIColor whiteColor]];
    notificationCount.hidden = YES;
    
    getRoundedLabel(notificationCount);
    [barButton addSubview:notificationCount];
    
    [barButton addTarget:controller action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    return barButtonItem;
}


- (void)callApiToSetNotificationCount {
    
    [self callApiToGetNotificationCount];
}

#pragma MARK: Orientation Check

-(void)customOrientationCheck {

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    if (UIInterfaceOrientationIsLandscape(orientation))
        isLandscape=YES;
    else
        isLandscape = NO;
    
    [self.collectionView reloadData];
}

- (void)orientationChanged:(NSNotification *)notification {
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        {
            isLandscape = NO;
        }
            break;

        case UIInterfaceOrientationPortraitUpsideDown:
        {
            isLandscape = NO;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            isLandscape = YES;
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            isLandscape = YES;
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
    [self.collectionView reloadData];
    
    [self performSelector:@selector(collectionViewReload) withObject:self afterDelay:1];
}

-(void)collectionViewReload {
    [self.collectionView reloadData];
}

#pragma mark - UICollection View Datasource and Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [homeDetail.dashboardArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   float cellWidth,cellHieght;
    
//    float cellWidth = [[UIScreen mainScreen] bounds].size.width / 2 - 11;
//    CGSize size = CGSizeMake(cellWidth, cellWidth);
    
    if (isLandscape) {
        cellWidth   = ([[UIScreen mainScreen] bounds].size.width - 40) / 2;
        cellHieght  = ([[UIScreen mainScreen] bounds].size.height) / 3;
        
    }else{
        cellWidth   = ([[UIScreen mainScreen] bounds].size.width - 30) / 2;
        cellHieght  = ([[UIScreen mainScreen] bounds].size.height - 190) / 3;
    }

    CGSize size = CGSizeMake(cellWidth,cellHieght);
    return size;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   HomeCollectionCell *homeCell  =   [self.collectionView dequeueReusableCellWithReuseIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    
    NSDictionary *itemDict = [homeDetail.dashboardArray objectAtIndex:indexPath.row];
    NSString *itemName = [itemDict objectForKeyNotNull:pDashboardItem expectedObj:@""];
    
    [homeCell.categoryInformationInNumberLabel setHidden:NO];
    [homeCell.numberSpecificationLabel setHidden:NO];
    
    if ([itemName isEqualToString:@"Attendance"]) {
        
        [homeCell.categoryImageView setImage:[UIImage imageNamed:@"attendance"]];
        [homeCell.categoryNameLabel setText:itemName];
        homeCell.backgroundColor = [UIColor colorWithRed:162.0/255.0 green:133.0/255.0 blue:212.0/255.0 alpha:1];
        [homeCell.categoryInformationInNumberLabel setText:[itemDict objectForKeyNotNull:pDashboardValue expectedObj:@""]];
        [homeCell.numberSpecificationLabel setText:@"Percent"];
        
    }else if ([itemName isEqualToString:@"Circulars"]) {
        
        [homeCell.categoryImageView setImage:[UIImage imageNamed:@"circular"]];
        [homeCell.categoryNameLabel setText:itemName];
        homeCell.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:191.0/255.0 blue:182.0/255.0 alpha:1];
        [homeCell.categoryInformationInNumberLabel setText:[itemDict objectForKeyNotNull:pDashboardValue expectedObj:@""]];
        [homeCell.numberSpecificationLabel setText:@"Update(s)"];

    }else if ([itemName isEqualToString:@"Assignments"]) {
        
        [homeCell.categoryImageView setImage:[UIImage imageNamed:@"assignment"]];
        [homeCell.categoryNameLabel setText:itemName];
        homeCell.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:180.0/255.0 blue:92.0/255.0 alpha:1];
        [homeCell.categoryInformationInNumberLabel setText:[itemDict objectForKeyNotNull:pDashboardValue expectedObj:@""]];
        [homeCell.numberSpecificationLabel setText:@"New Assignment(s)"];

        
    }else if ([itemName isEqualToString:@"Fee - Amount"]) {
        
        [homeCell.categoryImageView setImage:[UIImage imageNamed:@"fee"]];
        [homeCell.categoryNameLabel setText:itemName];
        homeCell.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:88.0/255.0 blue:95.0/255.0 alpha:1];

        NSString *dueFee = [itemDict objectForKeyNotNull:pDashboardValue expectedObj:@""];
        if (dueFee.length) {
            [homeCell.categoryInformationInNumberLabel setText:[NSString stringWithFormat:@"₹ %@",dueFee]];
        }else{
            [homeCell.categoryInformationInNumberLabel setText:@"₹ 0"];
        }
        [homeCell.numberSpecificationLabel setText:@"Due Amount"];
        
    }else if ([itemName isEqualToString:@"Discipline"]) {
        
        [homeCell.categoryImageView setImage:[UIImage imageNamed:@"dis"]];
        [homeCell.categoryNameLabel setText:itemName];
        homeCell.backgroundColor = [UIColor colorWithRed:105.0/255.0 green:123.0/255.0 blue:136.0/255.0 alpha:1];
        [homeCell.categoryInformationInNumberLabel setText:[NSString stringWithFormat:@"%@",[itemDict objectForKeyNotNull:pDashboardValue expectedObj:@""]]];
        [homeCell.numberSpecificationLabel setText:@"Action Taken"];
        
    }else if ([itemName isEqualToString:@"Time Table"]) {
        
        [homeCell.categoryImageView setImage:[UIImage imageNamed:@"icon"]];
        [homeCell.categoryNameLabel setText:itemName];
        homeCell.backgroundColor = [UIColor colorWithRed:99.0/255.0 green:110.0/255.0 blue:172.0/255.0 alpha:1];
        [homeCell.categoryInformationInNumberLabel setText:[itemDict objectForKeyNotNull:pDashboardValue expectedObj:@""]];
        [homeCell.numberSpecificationLabel setText:@"Today's Status"];
    }
    
       return homeCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *itemDict = [homeDetail.dashboardArray objectAtIndex:indexPath.row];
    NSString *itemName = [itemDict objectForKeyNotNull:pDashboardItem expectedObj:@""];
    
    if ([itemName isEqualToString:@"Attendance"]) {
        
        //Attendence
        PAAttendanceViewController *examVCObj = [[PAAttendanceViewController alloc]initWithNibName:@"PAAttendanceViewController" bundle:nil];
        [self.navigationController pushViewController:examVCObj animated:YES];
        
    }else if ([itemName isEqualToString:@"Circulars"]) {
        
        //Assignment
        CircularViewController *circularVCObj = [[CircularViewController alloc]initWithNibName:@"CircularViewController" bundle:nil];
        circularVCObj.isFromHome = YES;
        [self.navigationController pushViewController:circularVCObj animated:YES];
        
    }else if ([itemName isEqualToString:@"Assignments"]) {
        
           //Assignment
        AssignmentViewController *assignmentVCObj = [[AssignmentViewController alloc]initWithNibName:@"AssignmentViewController" bundle:nil];
        [self.navigationController pushViewController:assignmentVCObj animated:YES];
        
    }else if ([itemName isEqualToString:@"Fee - Amount"]) {
        //Fee Amount
        PAFeesViewController *examVCObj = [[PAFeesViewController alloc]initWithNibName:@"PAFeesViewController" bundle:nil];
        [self.navigationController pushViewController:examVCObj animated:YES];

        
    }else if ([itemName isEqualToString:@"Discipline"]) {
        //Discipline
        PADesciplineViewController *examVCObj = [[PADesciplineViewController alloc]initWithNibName:@"PADesciplineViewController" bundle:nil];
        [self.navigationController pushViewController:examVCObj animated:YES];
        
    }else if ([itemName isEqualToString:@"Time Table"]) {
        //Discipline
        TimeTableViewController *timeObj = [[TimeTableViewController alloc]initWithNibName:@"TimeTableViewController" bundle:nil];
        [self.navigationController pushViewController:timeObj animated:YES];
      //  [OPRequestTimeOutView showWithMessage:@"Work In Progress" forTime:3.0 andController:self];
    }
}

#pragma mark - Custom Delegate Method

-(void)callDashBoardApi {
    
    notificationCount.hidden = YES;

   // [self callAPIForDashboardItems];
}


#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForDashboardItems {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"deviceType"];
    
    [[[ServiceHelper alloc] init] PostAPICallWithParameter:params apiName:apiDashboard andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            homeDetail = [HomeModal parseHomeData:result];
            
            NSDictionary *studentDict = [[NSUSERDEFAULT valueForKey:@"studentInformation"] mutableCopy];
            
            if ([[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] length]) {
                NSData* data = [[NSData alloc] initWithBase64EncodedString:[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] options:0];
                self.studentImageView.image = [UIImage imageWithData:data];
            }else
                self.studentImageView.image = [UIImage imageNamed:@"dummy"];
            
            [self.studentNameLable setText:homeDetail.studentName];
            [self.studentSchoolLabel setText:homeDetail.studentQualification];
            [self.studentSectionLabel setText:homeDetail.studentSection];
           [self.studentAdmNumberLabel setText:homeDetail.studentAdminNumber];
            [self.admissionNumberLabel setHidden:NO];
            
            //Student Detail View set after coming of service
            self.detailsView.layer.masksToBounds = NO;
            self.detailsView.layer.shadowOffset = CGSizeMake(2, 2);
            self.detailsView.layer.shadowRadius = 2;
            self.detailsView.layer.shadowOpacity = 0.5;
            getRoundedImageView(self.studentImageView);
            
            [self callApiToGetNotificationCount];
            
//            if ([homeDetail.notificationCount integerValue] == 0)
//                notificationCount.hidden = YES;
//            else {
//                notificationCount.hidden = NO;
//                [notificationCount setText:homeDetail.notificationCount];
//            }
            
            [self.collectionView reloadData];
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}

- (void) callApiToGetNotificationCount  {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"deviceType"];
    
    [[[ServiceHelper alloc] init] PostAPICallWithParameter:params apiName:apiNotificationCount andController:self cache:NO withprogresHud:ISProgressNotShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            NSString *notificationResponseCount = [result objectForKeyNotNull:pNotificationCount expectedObj:@""];
            
            if ([notificationResponseCount integerValue] == 0)
                notificationCount.hidden = YES;
            else {
                notificationCount.hidden = NO;
                [notificationCount setText:notificationResponseCount];
            }
            
        }else {
        }
    }];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [notificationTimeCounter invalidate];
}

@end
