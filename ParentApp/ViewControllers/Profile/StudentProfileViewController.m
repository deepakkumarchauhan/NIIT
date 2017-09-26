//
//  StudentProfileViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 13/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//


#import "StudentProfileViewController.h"
#import "StudentProfileInfo.h"
#import "PAUtility.h"

@interface StudentProfileViewController ()<UITableViewDelegate,UITableViewDataSource> {
    StudentProfileInfo     *studentInfoObj;
}

@property (weak, nonatomic) IBOutlet UIImageView *studentProfileImageView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintTableView;

@end

@implementation StudentProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInitialization];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MARK: Helper Methods

-(void)customInitialization{
    
    self.title = @"Student Profile";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");

    //Method to call when orientation is changed
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    [self.studentProfileTableView registerNib:[UINib nibWithNibName:@"StudentProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"StudentProfileTableViewCell"];
    self.studentProfileTableView.alwaysBounceVertical = NO;
    
    self.studentProfileTableView.estimatedRowHeight = 45;
    self.studentProfileTableView.rowHeight = UITableViewAutomaticDimension;
    
    studentInfoObj = [[StudentProfileInfo alloc]init];
    
    [self callAPIForStudentDetail];
}

#pragma mark - tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StudentProfileTableViewCell *cell = (StudentProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"StudentProfileTableViewCell"];
    
    switch (indexPath.row) {
            
        case 0: {
            cell.headingLabel.text = @"Admission Number";
            cell.detailsLabel.text = studentInfoObj.enrollmentNumber;
        }
            break;
            
        case 1: {
            cell.headingLabel.text = @"Student Name";
            cell.detailsLabel.text = studentInfoObj.studentName;
        }
            break;
            
        case 2: {
            cell.headingLabel.text = @"Standard";
            cell.detailsLabel.text = studentInfoObj.standard;
        }
            
            break;
            
        case 3: {
            cell.headingLabel.text = @"Section";
            cell.detailsLabel.text = studentInfoObj.section;
        }
            
            break;
            
        case 4: {
            cell.headingLabel.text = @"Roll Number";
            cell.detailsLabel.text = studentInfoObj.rollNumber;
        }
            break;
            
        case 5: {
            cell.headingLabel.text = @"Date of Birth";
            cell.detailsLabel.text = studentInfoObj.dOB;
        }
            break;
            
        case 6: {
            cell.headingLabel.text = @"Phone No.";
            cell.detailsLabel.text = studentInfoObj.parentMobileNumber;
        }
            break;
            
        case 7: {
            cell.headingLabel.text = @"Address";
            cell.detailsLabel.text = studentInfoObj.address;
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForStudentDetail {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"deviceType"];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiStudentDetail andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            studentInfoObj = [StudentProfileInfo parseStudentInfo:result];
            
//            //Set Student Image
//            if ([studentInfoObj.studentPicture length]) {
//                NSData* data = [[NSData alloc] initWithBase64EncodedString:studentInfoObj.studentPicture options:0];
//                self.studentProfileImageView.image = [UIImage imageWithData:data];
//            }else
//                self.studentProfileImageView.image = [UIImage imageNamed:@"dummy"];

            self.studentProfileTableView.dataSource = self;
            self.studentProfileTableView.delegate = self;
            self.studentProfileTableView.borderColor = AppDarkBlueColor;
            self.studentProfileTableView.backgroundColor = RGBCOLOR(239, 239, 239, 1);
            
            NSDictionary *studentDict = [[NSUSERDEFAULT valueForKey:@"studentInformation"] mutableCopy];
            getRoundedImageView(self.studentProfileImageView);

            if ([[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] length]) {
                NSData* data = [[NSData alloc] initWithBase64EncodedString:[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] options:0];
                self.studentProfileImageView.image = [UIImage imageWithData:data];
            }else
                self.studentProfileImageView.image = [UIImage imageNamed:@"dummy"];
            
            
            [self.studentProfileTableView reloadData];
            
            [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
            

        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}

-(void)afterSomeTime {
   self.heightConstraintTableView.constant = self.studentProfileTableView.contentSize.height;
}

#pragma MARK: UIButton Actions:

-(void)leftBarButtonAction:(UIButton*)sender{
    
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
}

#pragma MARK: Orientation Check

- (void)orientationChanged:(NSNotification *)notification {
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    self.heightConstraintTableView.constant = self.studentProfileTableView.contentSize.height;
}

-(void)customOrientationCheck {
    self.heightConstraintTableView.constant = self.studentProfileTableView.contentSize.height;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

@end
