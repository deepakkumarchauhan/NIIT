//
//  ActivityViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 13/10/16.
//  Copyright © 2016 Prince Kadian. All rights reserved.
//

#import "ActivityViewController.h"
#import "PAUtility.h"
#import "Header.h"


static NSString *pTitle = @"title";
static NSString *pSubData = @"subData";
static NSString *pSubDataDetails = @"subDataDetails";

@interface ActivityViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    ActivityModal * activityInfoObject;
    Pagination    * paginationObject;
}

@property (weak, nonatomic) IBOutlet UITableView *activityTableView;
@property (nonatomic, strong) NSMutableIndexSet  *expandedSections;
@property (strong, nonatomic) NSMutableArray     *dataSourceArray;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

@end

@implementation ActivityViewController

#pragma mark - UIViewController LifeCycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

#pragma mark - Helper Method

- (void)initialSetup {
    
    //Navigation Bar
    self.title = @"Activity";
    
    if (self.fromNotification) {
        self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    }
    else
        self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");
    
    self.navigationController.navigationBarHidden = NO;
    
    self.dataSourceArray = [NSMutableArray array];
    
    self.seeMoreButton.hidden = YES;
    
    //Register Cells
    [self.activityTableView registerNib:[UINib nibWithNibName:@"SectionCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"SectionCellTableViewCell"];
    [self.activityTableView registerNib:[UINib nibWithNibName:@"PAReceiptTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAReceiptTableViewCell"];
    self.activityTableView.estimatedRowHeight = 45.0;
    self.activityTableView.alwaysBounceVertical = NO;

    //Alloc for expanded cells
    self.expandedSections = [NSMutableIndexSet new];
    
    paginationObject = [Pagination new];
    paginationObject.pageNumber = 1;
    
    [self callAPIForActivityList];

}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSourceArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.expandedSections containsIndex:section]) {
        
        return 8;// return rows when expanded
        
    }else
    return 1;// Return the number of rows in the section.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (!indexPath.row) {
        SectionCellTableViewCell *cell = (SectionCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SectionCellTableViewCell" forIndexPath:indexPath];
        ActivityModal *activityObject = [self.dataSourceArray objectAtIndex:indexPath.section];

        [cell.topLabelHieghtConstraint setConstant:12];
        
        NSAttributedString *useDict1=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ participated in %@", activityObject.studentNameString, activityObject.activityNameString]];

        NSMutableAttributedString *text =
        [[NSMutableAttributedString alloc]
         initWithAttributedString:  useDict1];
        
        NSUInteger len = [activityObject.studentNameString length];
        NSUInteger totalLength = [[NSString stringWithFormat:@"%@ participated in %@", activityObject.studentNameString, activityObject.activityNameString] length];

        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor grayColor]
                     range:NSMakeRange(len, totalLength-len)];
        [cell.titleLabel setAttributedText: text];
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Points:%ld",(long)activityObject.pointsInteger]];
        
        // Change textfirld Font size and color
        cell.pointLabel.textColor = AppBlueColor;
        [attributedText addAttributes:@{
                                        NSForegroundColorAttributeName: [UIColor blackColor],
                                        NSFontAttributeName : [UIFont fontWithName:@"Relay-Regular" size:16.0]
                                        }range:NSMakeRange(0,7)];

        cell.pointLabel.attributedText = attributedText;
        
        cell.dateLabel.text = activityObject.eventDateString;
        cell.positionDetailLabel.text = activityObject.positionString;
        
        [cell.dropDownButton setHidden:NO];
        
        BOOL currentlyExpanded = [self.expandedSections containsIndex:indexPath.section];

        if (!currentlyExpanded) {
            cell.dropDownButton.transform = CGAffineTransformIdentity;
        }else {
            cell.dropDownButton.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
        }

        
        if(indexPath.section%2 == 0)
            cell.backgroundColor = [UIColor whiteColor];
        else
            cell.backgroundColor = RGBCOLOR(238, 238, 238, 1);
        
        return cell;
        
    } else {
        
        PAReceiptTableViewCell *subCell = (PAReceiptTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PAReceiptTableViewCell" forIndexPath:indexPath];
        ActivityModal *activityModal = [self.dataSourceArray objectAtIndex:indexPath.section];
        
        
        if (indexPath.row == 1) {
            subCell.titleLabel.text = @"Date";
            subCell.detailsLabel.text = activityModal.eventDateString;
            
        } else if (indexPath.row == 2) {
            subCell.titleLabel.text = @"Level";
            subCell.detailsLabel.text = activityModal.eventLevelString;

        } else if (indexPath.row == 3) {
            subCell.titleLabel.text = @"House";
            subCell.detailsLabel.text = activityModal.addressString;
            
        } else if (indexPath.row == 4) {
            subCell.titleLabel.text = @"Position";
            subCell.detailsLabel.text = activityModal.positionString;
            
        } else if (indexPath.row == 5) {
            subCell.titleLabel.text = @"Points";
            subCell.detailsLabel.text = [NSString stringWithFormat:@"%ld", (long)activityModal.pointsInteger];
            
        }else if (indexPath.row == 6) {
            subCell.titleLabel.text = @"Activity";
            subCell.detailsLabel.text = activityModal.activityNameString;
            
        }
        else if (indexPath.row == 7) {
            subCell.titleLabel.text = @"Activity Description";
           // subCell.detailsLabel.text = [NSString stringWithFormat:@"%ld", (long)activityModal.totalRecordsInteger ];
            subCell.detailsLabel.text = activityModal.activityDescriptionString;
        }

        subCell.topLabel.hidden = YES;
        subCell.buttomLabelConstraint.constant = 0;
        subCell.topLabelConstraint.constant = 0;
        subCell.buttomLabel.backgroundColor = RGBCOLOR(215, 215, 215, 1);

        if(indexPath.row == 1) {
            subCell.topLabel.hidden = NO;
            subCell.topLabelConstraint.constant = 5;
        }
        else if(indexPath.row == 7) {
            subCell.buttomLabel.backgroundColor = RGBCOLOR(83, 103, 197, 1);
            subCell.buttomLabelConstraint.constant = 0;
        }
        
        return subCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath.row) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performExpandCollapseForTableView:tableView forRowAtIndexPath:indexPath];
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

#pragma MARK: UIButton Actions

-(void)leftBarButtonAction:(UIButton*)sender{
    
    if (self.fromNotification) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
        [itrSideMenu presentLeftMenuViewController];
    }
    
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForActivityList {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setValue:@"10" forKey:cpPageSize];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)paginationObject.pageNumber] forKey:cpPageNumber];

   [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiActivityList andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
       if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
           
           if (paginationObject.pageNumber == 0) {
               [self.dataSourceArray removeAllObjects];
           }
               paginationObject = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
           
               NSArray *activityTempArray = [result objectForKeyNotNull:pActivityList expectedObj:[NSArray new]];
           
               for (NSMutableDictionary * activityDict in activityTempArray) {
                   [self.dataSourceArray addObject:[ActivityModal parseDataFor_activityList: activityDict]];
                   
                   if (paginationObject.pageNumber < paginationObject.maxPages)
                       self.seeMoreButton.hidden = NO;
                   else
                       self.seeMoreButton.hidden = YES;
               }
          
           if ([self.dataSourceArray count] == 0) {
               [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
           }
           [self.activityTableView reloadData];
           
      }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}

#pragma mark - Show Message On Data Blank

-(void)setLabelBetweenTable:(NSString *)displayMessage {
    
    UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.activityTableView.bounds.size.width,  self.activityTableView.bounds.size.height)];
    noDataLabel.text             = displayMessage;
    noDataLabel.textColor        = [UIColor darkGrayColor];
    noDataLabel.textAlignment    = NSTextAlignmentCenter;
    self.activityTableView.backgroundView = noDataLabel;
}


#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Action

- (IBAction)seeMoreButtonAction:(id)sender {

        if (paginationObject.pageNumber  < paginationObject.maxPages) {
            
            paginationObject.pageNumber += 1;
            [self callAPIForActivityList];
    }
}




@end
