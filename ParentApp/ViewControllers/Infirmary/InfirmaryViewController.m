//
//  InfirmaryViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 13/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "InfirmaryViewController.h"
#import "PAUtility.h"

@interface InfirmaryViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    NSInteger    selectedIndex;
    Pagination * vaccinationPaginationObject;
    Pagination * illnessPaginationObject;
    UILabel *noDataLabel;
}

@property (weak, nonatomic) IBOutlet UIView             *segmentView;
@property (weak, nonatomic) IBOutlet UIButton           *infirmaryButton;
@property (weak, nonatomic) IBOutlet UIButton           *vaccinationButton;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

@property (weak, nonatomic) IBOutlet UITableView        *infimaryTableView;

@property (nonatomic, strong)        NSMutableIndexSet  *expandedSections;
@property (nonatomic, strong)        NSMutableIndexSet  *expandedSectionsForVaccination;

@property (strong, nonatomic)        NSMutableArray     *dataSourceArrayForInfirmary;
@property (strong, nonatomic)        NSMutableArray     *dataSourceArrayForVaccination;

@end

@implementation InfirmaryViewController

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
    self.title = @"Infirmary";
    if (self.fromNotification) {
        self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    }
    else
        self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");
    
    self.seeMoreButton.hidden = YES;
    
    //Set Segement Item color and layout
    selectedIndex = 0;
    getCornerView(self.segmentView, 18.0f);
    
    self.infirmaryButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(189.0/255.0) blue:(250.0/255.0) alpha:1.0f];
    [self.vaccinationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.infirmaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.vaccinationButton.backgroundColor = [UIColor clearColor];
    
    
    //Alloc Modal Class
    _dataSourceArrayForInfirmary = [NSMutableArray array];
    _dataSourceArrayForVaccination = [NSMutableArray array];

    
    self.infimaryTableView.estimatedRowHeight = 44.0;
    //Register Cells
    [self.infimaryTableView registerNib:[UINib nibWithNibName:@"SectionCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"SectionCellTableViewCell"];
    
    [self.infimaryTableView registerNib:[UINib nibWithNibName:@"PAReceiptTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAReceiptTableViewCell"];
    self.infimaryTableView.alwaysBounceVertical = NO;
    
    //Alloc for expanded cells
    self.expandedSections = [NSMutableIndexSet new];
    self.expandedSectionsForVaccination = [NSMutableIndexSet new];
    
    vaccinationPaginationObject = [Pagination new];
    vaccinationPaginationObject.pageNumber = 1;
    
    illnessPaginationObject = [Pagination new];
    illnessPaginationObject.pageNumber = 1;
    
    [self callAPIForGetIllnessList:illnessPaginationObject];
}

#pragma mark - UITableView Datasource/Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return (selectedIndex == 0)?[self.dataSourceArrayForInfirmary count]:[self.dataSourceArrayForVaccination count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
     if (selectedIndex == 0 && [self.expandedSections containsIndex:section]) {
         return 6;
     }else if (selectedIndex == 1 && [self.expandedSectionsForVaccination containsIndex:section]) {
         return 3;
     }else
         return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath.row)
        return 90.0f;
    else
        return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InfirmaryModal *infirmary = (selectedIndex == 0)?[self.dataSourceArrayForInfirmary objectAtIndex:indexPath.section]:[self.dataSourceArrayForVaccination objectAtIndex:indexPath.section];
    
    if (!indexPath.row) {
        SectionCellTableViewCell *cell = (SectionCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SectionCellTableViewCell" forIndexPath:indexPath];
        cell.pointLabel.hidden = YES;
        if (selectedIndex == 1) {
            cell.activityImageView.image = [UIImage imageNamed:@"icon8"];
        }
        else {
            cell.activityImageView.image = [UIImage imageNamed:@"icon7"];
         }
        cell.titleLabel.text = infirmary.infirmaryHeadingString;
        cell.dateLabel.text = infirmary.infirmaryDateString;
        [cell.dropDownButton setHidden:NO];
        [cell.positionLabel setHidden:YES];
        [cell.positionDetailLabel setHidden:YES];
        [cell.topLabelHieghtConstraint setConstant:22];
        
        BOOL currentlyExpanded =  (selectedIndex == 0)? [self.expandedSections containsIndex:indexPath.section]:[self.expandedSectionsForVaccination containsIndex:indexPath.section];
        
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
        
        subCell.buttomLabel.backgroundColor = RGBCOLOR(215, 215, 215, 1);
        subCell.topLabelConstraint.constant = 0;
        subCell.buttomLabelConstraint.constant = 0;
        subCell.topLabel.hidden = YES;
        subCell.buttomLabel.hidden = YES;

            // subCell.titleLabel.text = [subDataArray objectAtIndex:indexPath.row - 1];
      //  subCell.detailsLabel.text = [[dataDict valueForKey:pSubDataDetails] objectAtIndex:indexPath.row - 1];
        
        if (indexPath.row == 1) {
            subCell.titleLabel.text = @"Date";
            subCell.detailsLabel.text = infirmary.infirmaryDateString;
            
        } else if (indexPath.row == 2) {
            subCell.titleLabel.text = @"Illness Details";
            subCell.detailsLabel.text = infirmary.infirmaryDetailsString;
            if (selectedIndex == 1) {
                subCell.buttomLabel.hidden = NO;
                subCell.buttomLabel.backgroundColor = RGBCOLOR(83, 103, 197, 1);
                subCell.titleLabel.text = @"Vaccination Details";
            }
            
        } else if (indexPath.row == 3) {
            subCell.titleLabel.text = @"Remarks";
            subCell.detailsLabel.text = infirmary.remarksString;
            
        } else if (indexPath.row == 4) {
            subCell.titleLabel.text = @"Medicine";
            subCell.detailsLabel.text = infirmary.medicineString;
            
        } else if (indexPath.row == 5) {
            subCell.buttomLabel.hidden = NO;
            subCell.buttomLabel.backgroundColor = RGBCOLOR(83, 103, 197, 1);
            subCell.titleLabel.text = @"Amount of Dose";
            subCell.detailsLabel.text = infirmary.amountofDoseString;
        }

        if(indexPath.row == 1) {
            subCell.titleLabel.text = @"Date";
            subCell.topLabel.hidden = NO;
            subCell.topLabelConstraint.constant = 5;
        }
        else if(indexPath.row == (selectedIndex == 0)?[_dataSourceArrayForInfirmary count]:[_dataSourceArrayForVaccination count]) {
            
            subCell.buttomLabel.backgroundColor = RGBCOLOR(83, 103, 197, 1);
            subCell.buttomLabelConstraint.constant = 5;
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
    
    BOOL currentlyExpanded =  (selectedIndex == 0)? [self.expandedSections containsIndex:indexPath.section]:[self.expandedSectionsForVaccination containsIndex:indexPath.section];
    
    NSInteger rows;
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    if (currentlyExpanded) {
        rows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        [(selectedIndex == 0)?self.expandedSections:self.expandedSectionsForVaccination removeIndex:indexPath.section];
    } else {
        [(selectedIndex == 0)?self.expandedSections:self.expandedSectionsForVaccination addIndex:indexPath.section];
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

#pragma MARk: UIButton Actions

-(void)leftBarButtonAction:(UIButton*)sender{
    
    if (self.fromNotification) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
        [itrSideMenu presentLeftMenuViewController];
    }
}

#pragma MARK: Segment

- (IBAction)segmentBtnAction:(UIButton *)sender {
    
    [self.infirmaryButton setBackgroundColor:[UIColor clearColor]];
    [self.vaccinationButton setBackgroundColor:[UIColor clearColor]];

    [self.expandedSections removeAllIndexes];
    [self.expandedSectionsForVaccination removeAllIndexes];
    
    if(sender.tag == 2)
    {
        selectedIndex = 1;
      //  [_dataSourceArrayForInfirmary removeAllObjects];
        [self.vaccinationButton setBackgroundColor:RGBCOLOR(51, 189, 250, 1)];
    
        //vaccinationPaginationObject.pageNumber = 1;
        
        [self.infimaryTableView reloadData];
        
       // [self callAPIForGetVaccinationList:vaccinationPaginationObject];
    }
    else if (sender.tag == 1)
    {
        selectedIndex = 0;
        //[_dataSourceArrayForVaccination removeAllObjects];
        [self.infirmaryButton setBackgroundColor:RGBCOLOR(51, 189, 250, 1)];
        //illnessPaginationObject.pageNumber = 1;
        
        [self.infimaryTableView reloadData];

       // [self callAPIForGetIllnessList:illnessPaginationObject];
    }
    
    
       if (selectedIndex == 1 && [_dataSourceArrayForVaccination count] == 0) {

         [self callAPIForGetVaccinationList:illnessPaginationObject];
       }
    else if (selectedIndex == 0 && [_dataSourceArrayForInfirmary count] == 0) {
        
          [self callAPIForGetIllnessList:vaccinationPaginationObject];
        
    }else if (selectedIndex == 0 && [_dataSourceArrayForInfirmary count] == 0) {
        
        [self setLabelBetweenTable:MessageWhenNoData];
        [_infimaryTableView reloadData];
        
    }else if (selectedIndex == 1 && [_dataSourceArrayForVaccination count] == 0) {
        
        [self setLabelBetweenTable:MessageWhenNoData];
        [_infimaryTableView reloadData];
        
    }else {
        self.infimaryTableView.backgroundView = nil;
        
        [_infimaryTableView reloadData];
    }

}

- (IBAction)seeMoreButtonAction:(id)sender {

        if (selectedIndex == 0) {
            if (illnessPaginationObject.pageNumber  < illnessPaginationObject.maxPages) {
                
                illnessPaginationObject.pageNumber += 1;
                [self callAPIForGetIllnessList:illnessPaginationObject];
            }
        }
        else {
            if (vaccinationPaginationObject.pageNumber  < vaccinationPaginationObject.maxPages) {
                
                vaccinationPaginationObject.pageNumber += 1;
                [self callAPIForGetVaccinationList:vaccinationPaginationObject];
            }
        }
}


#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForGetIllnessList:(Pagination *)page  {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"10" forKey:cpPageSize];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)page.pageNumber] forKey:cpPageNumber];

    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiGetInfirmaryIllnessList andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            if (illnessPaginationObject.pageNumber == 0)
                [self.dataSourceArrayForInfirmary removeAllObjects];
                
            illnessPaginationObject = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            
            NSArray *IllnessTempArray = [result objectForKeyNotNull:pIllnessList expectedObj:[NSArray array]];
            
            for (NSMutableDictionary * IllnessDict in IllnessTempArray) {
                [self.dataSourceArrayForInfirmary addObject:[InfirmaryModal parseDataFor_InfirmaryIllnessList: IllnessDict]];
                
                if (illnessPaginationObject.pageNumber < illnessPaginationObject.maxPages)
                    self.seeMoreButton.hidden = NO;
                else
                    self.seeMoreButton.hidden = YES;
            }

            if ([self.dataSourceArrayForInfirmary count] == 0)
                [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
            else
                noDataLabel.hidden = YES;

            [self.infimaryTableView reloadData];

        }else {
                        [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}


-(void)callAPIForGetVaccinationList:(Pagination *)page  {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:@"10" forKey:cpPageSize];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)page.pageNumber] forKey:cpPageNumber];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiGetInfirmaryVaccinationList andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            if (vaccinationPaginationObject.pageNumber == 0)
                [self.dataSourceArrayForVaccination removeAllObjects];

                vaccinationPaginationObject = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            
            NSArray *vaccinationTempArray = [result objectForKeyNotNull:pVaccinationList expectedObj:[NSArray new]];
            
            for (NSMutableDictionary * vaccinationDict in vaccinationTempArray) {
                [self.dataSourceArrayForVaccination addObject:[InfirmaryModal parseDataFor_InfirmaryVaccinationList: vaccinationDict]];
                
                if (vaccinationPaginationObject.pageNumber < vaccinationPaginationObject.maxPages)
                    self.seeMoreButton.hidden = NO;
                else
                    self.seeMoreButton.hidden = YES;
                
            }
            
            if ([self.dataSourceArrayForVaccination count] == 0)
                [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
            else
                noDataLabel.hidden = YES;
            
                [self.infimaryTableView reloadData];
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}


#pragma mark - Show Message On Data Blank

-(void)setLabelBetweenTable:(NSString *)displayMessage {
    
    noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.infimaryTableView.bounds.size.width,  self.infimaryTableView.bounds.size.height)];
    noDataLabel.text             = displayMessage;
    noDataLabel.textColor        = [UIColor darkGrayColor];
    noDataLabel.textAlignment    = NSTextAlignmentCenter;
    self.infimaryTableView.backgroundView = noDataLabel;
}


@end
