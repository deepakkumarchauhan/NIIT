//
//  FeesViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 03/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PAFeesViewController.h"
#import "PAFeeInfo.h"
#import "PAUtility.h"

@interface PAFeesViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,PaymentSuccess>{
    
    NSMutableArray   *feeArray;
}

@property (weak, nonatomic) IBOutlet UITableView *feeTableView;

@end

@implementation PAFeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customInitialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

#pragma MARK: Helper Methods

-(void)customInitialization {
    
    //Allocations
    feeArray    = [NSMutableArray array];

    //Navigation Bar
    self.title = @"Fees";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    
    //Register Tables
    [self.feeTableView registerNib:[UINib nibWithNibName:@"PAFeesTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAFeesTableViewCell"];
    [self.feeTableView registerNib:[UINib nibWithNibName:@"FeesSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeesSecondTableViewCell"];
    self.feeTableView.alwaysBounceVertical = NO;
    
    //Fees List
    [self callAPIForFeeList];
}

#pragma mark - Custom Delegate Method

-(void)payementSuccess {
    
    [feeArray removeAllObjects];
    [self callAPIForFeeList];
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PAFeeInfo *obj = [feeArray objectAtIndex:indexPath.row];
    
    if ([obj.receiptNo length]) {
        return 130;
    }else
        return 95;

//    if ([[NSString stringWithFormat:@"%@",obj.statusColor] isEqualToString:@"2"])
//        return 95;
//    else
//        return 130;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feeArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PAFeesTableViewCell *cell1 = (PAFeesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PAFeesTableViewCell"];
    
    FeesSecondTableViewCell *cell2  = (FeesSecondTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FeesSecondTableViewCell"];
    
    PAFeeInfo *obj = [feeArray objectAtIndex:indexPath.row];
    
    if (indexPath.row%2 == 0) {
        cell1.contentView.backgroundColor = RGBCOLOR(220.0, 219.0, 224.0, 1.0);
        cell2.contentView.backgroundColor = RGBCOLOR(220.0, 219.0, 224.0, 1.0);
    }else {
        cell1.contentView.backgroundColor = [UIColor whiteColor];
        cell2.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    if ([obj.receiptNo length]) {
        
        cell1.colorStatusLabel.backgroundColor = RGBCOLOR(61, 183, 32, 1);
        cell1.paymentTitleLabel.text           = @"Payment Date";
        cell1.installmentNumberLabel.text      = obj.installmentNumber;
        cell1.paymentDateLabel.text            = obj.feesDateString;
        
        cell1.paidAmountLabel.text             = [NSString stringWithFormat:@"₹ %@",obj.paidAmount];
        cell1.receiptNumberLabel.text          = [NSString stringWithFormat:@"%@",obj.receiptNo];
        
        return cell1;

    }else {
        
        if ([obj.feesDate compare:[NSDate date]] == NSOrderedDescending)
            cell2.colorStatusLabel.backgroundColor = RGBCOLOR(203, 206, 32, 1);
        else
            cell2.colorStatusLabel.backgroundColor = RGBCOLOR(221, 34, 32, 1);

        cell2.payableDateLabel.text            = obj.feesDateString;
        cell2.payableAmountLabel.text          = [NSString stringWithFormat:@"₹ %@",obj.payableAmount];
        
        return cell2;
    }

//    NSString *colorStatus = [NSString stringWithFormat:@"%@",obj.statusColor];
//    
//    if ([colorStatus isEqualToString:@"2"]) {
//        cell2.colorStatusLabel.backgroundColor = RGBCOLOR(203, 206, 32, 1);
//        cell2.payableDateLabel.text            = obj.paymentDate;
//       // cell2.paidAmountLabel.text             = [NSString stringWithFormat:@"₹ %@",obj.paidAmount];
//        cell2.payableAmountLabel.text          = [NSString stringWithFormat:@"₹ %@",obj.payableAmount];
//        
//        return cell2;
//        
//    }else if ([colorStatus isEqualToString:@"3"]) {
//        
//        cell1.colorStatusLabel.backgroundColor = RGBCOLOR(221, 34, 32, 1);
//        cell1.paymentTitleLabel.text           = @"Due Date";
//        cell1.installmentNumberLabel.text      = obj.installmentNumber;
//        cell1.paymentDateLabel.text            = obj.paymentDate;
//        
//         cell1.paidAmountLabel.text             = [NSString stringWithFormat:@"₹ %@",obj.paidAmount];
//        cell1.receiptNumberLabel.text          = [NSString stringWithFormat:@"%@",obj.receiptID];
//        
//        return cell1;
//        
//    }else {
//        cell1.colorStatusLabel.backgroundColor = RGBCOLOR(61, 183, 32, 1);
//        cell1.paymentTitleLabel.text           = @"Payment Date";
//        cell1.installmentNumberLabel.text      = obj.installmentNumber;
//        cell1.paymentDateLabel.text            = obj.paymentDate;
//        
//        cell1.paidAmountLabel.text             = [NSString stringWithFormat:@"₹ %@",obj.paidAmount];
//        cell1.receiptNumberLabel.text          = [NSString stringWithFormat:@"%@",obj.receiptID];
//        
//        return cell1;
//    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PAReceiptViewController *receiptVCObj      = [[PAReceiptViewController alloc]initWithNibName:@"PAReceiptViewController" bundle:nil];
    receiptVCObj.feeInfo = [feeArray objectAtIndex:indexPath.row];
    receiptVCObj.delegate = self;
    [self.navigationController pushViewController:receiptVCObj animated:YES];

    //PAFeeInfo *obj = [feeArray objectAtIndex:indexPath.row];

//    if (![[NSString stringWithFormat:@"%@",obj.statusColor] isEqualToString:@"3"]) {
//        
//        PAReceiptViewController *receiptVCObj      = [[PAReceiptViewController alloc]initWithNibName:@"PAReceiptViewController" bundle:nil];
//        receiptVCObj.feeInfo = [feeArray objectAtIndex:indexPath.row];
//        [self.navigationController pushViewController:receiptVCObj animated:YES];
//    }
}

#pragma MARK: UIButtonActions

-(void)leftBarButtonAction:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForFeeList {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiFeeList andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            NSArray *feeTempArray = [result objectForKeyNotNull:pFeeList expectedObj:[NSArray array]];
            
            //For Presenting data instantly
            self.feeTableView.delegate = self;
            self.feeTableView.dataSource = self;
            
            for (NSDictionary *feeDict in feeTempArray)
                 [feeArray addObject:[PAFeeInfo parseFeeInfo:feeDict]];
            
            if ([feeArray count] == 0) {
                UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.feeTableView.bounds.size.width,  self.feeTableView.bounds.size.height)];
                noDataLabel.text             = [result objectForKey:cpResponseMessage];
                noDataLabel.textColor        = [UIColor darkGrayColor];
                noDataLabel.textAlignment    = NSTextAlignmentCenter;
                self.feeTableView.backgroundView = noDataLabel;
            }else
                self.feeTableView.backgroundView = nil;
            
            [self.feeTableView reloadData];
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}



@end
