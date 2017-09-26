//
//  ContactUsViewController.m
//  ParentApp
//
//  Created by Deepak Chauhan on 01/12/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "ContactUsViewController.h"
#import "ContactUsTableViewCell.h"
#import "Header.h"

static NSString *contactUsCellIdentifier = @"ContactUsCellIdentifier";

@interface ContactUsViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    NSMutableArray *contactusArray;
    NotificationModal *contactModal;
    BOOL isRelodeTableView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *schoolImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation ContactUsViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

-(void)initialSetup {
    
    // Set Title
    self.title = @"Contact Us";
    
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");

    // Add Header View
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    isRelodeTableView = NO;
    
    // Register TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactUsTableViewCell" bundle:nil] forCellReuseIdentifier:contactUsCellIdentifier];
    self.tableView.estimatedRowHeight = 76.0;
    
    // Alloc Array
    contactusArray = [NSMutableArray array];
    
    // Allloc Modal Class
    contactModal = [[NotificationModal alloc]init];
    
    [self callAPIForContactUs];
}

#pragma mark - Selector Method

-(void)leftBarButtonAction:(UIButton*)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isRelodeTableView)
        return 4;
    else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContactUsTableViewCell *contactUsCell = (ContactUsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:contactUsCellIdentifier];
    
    contactUsCell.leftConstraints.constant = 34.0;

    NotificationModal *contact = [contactusArray objectAtIndex:0];
    switch (indexPath.row) {
        case 0:
            contactUsCell.headingLabel.text = @"Address:";
            contactUsCell.descriptionLabel.text = contact.address;
            contactUsCell.leftConstraints.constant = 12.0;
            break;
        case 1:
            contactUsCell.headingLabel.text = @"Email Id:";
            contactUsCell.descriptionLabel.text = contact.email;
            contactUsCell.contactImageView.image = [UIImage imageNamed:@"msg"];
            break;
        case 2:
            contactUsCell.headingLabel.text = @"MobileNumber:";
            contactUsCell.descriptionLabel.text = contact.mobile;
            contactUsCell.contactImageView.image = [UIImage imageNamed:@"mobile"];
            break;
        case 3:
            contactUsCell.headingLabel.text = @"Landline Number:";
            contactUsCell.descriptionLabel.text = contact.landline;
            contactUsCell.contactImageView.image = [UIImage imageNamed:@"phone"];
            break;
            
        default:
            break;
    }
    return contactUsCell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


#pragma mark - API Method

-(void)callAPIForContactUs {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiContactUs andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            [contactusArray addObject:[NotificationModal parseContactUs:result]];
            
            NSData* data = [[NSData alloc] initWithBase64EncodedString:[result objectForKeyNotNull:@"schoolPhoto" expectedObj:@""] options:0];
            
            if (data.length)
                [self.schoolImageView setImage:[UIImage imageWithData:data]];
            else
                [self.schoolImageView setImage:[UIImage imageNamed:@"placeholder"]];
            
            self.logoImageView.image = [UIImage imageNamed:@"NGURU-01 (1)"];

            isRelodeTableView = YES;
            [self.tableView reloadData];
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}



@end
