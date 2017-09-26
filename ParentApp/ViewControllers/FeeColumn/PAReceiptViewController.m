//
//  ReceiptViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PAReceiptViewController.h"
#import "ReceiptInfoModal.h"
#import "PAUtility.h"
#import "CCWebViewController.h"

@interface PAReceiptViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    ReceiptInfoModal *receiptInfo;
    NSMutableArray *paymentArray;
    NSString *amount;
    NSString *strOrderId;

}

@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;
@property (weak, nonatomic) IBOutlet UIButton *makePaymentButton;

@end

@implementation PAReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customInitialization];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

#pragma MARK: Helper Methods

-(void)customInitialization {
    
    self.title = @"Details";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");

    //Allocations
    receiptInfo = [[ReceiptInfoModal alloc]init];
    self.makePaymentButton.hidden = YES;
    paymentArray = [NSMutableArray array];
    //Cell Register
    [self.detailsTableView registerNib:[UINib nibWithNibName:@"PAReceiptTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAReceiptTableViewCell"];
    self.detailsTableView.alwaysBounceVertical = NO;

    //Receipt Data
    [self callAPIForReceiptList];
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [receiptInfo.receiptDetailSec1 count];

    return [receiptInfo.receiptDetailSec2 count];;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PAReceiptTableViewCell *cell1 = (PAReceiptTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PAReceiptTableViewCell"];
    
    ReceiptSectionInfoModal *sectionInfo = (indexPath.section == 0)?[receiptInfo.receiptDetailSec1 objectAtIndex:indexPath.row]:[receiptInfo.receiptDetailSec2 objectAtIndex:indexPath.row];
    
    if (![self.feeInfo.receiptNo length]) {
        if ([sectionInfo.sectionType isEqualToString:@"Paid Date"]) {
            cell1.titleLabel.text = @"Due Date";
            cell1.detailsLabel.text = sectionInfo.sectionValue;
        }
        else if ([sectionInfo.sectionType isEqualToString:@"Paid Fee"]){
            cell1.titleLabel.text = @"Due Fee";
            cell1.detailsLabel.text = sectionInfo.sectionValue;
        }
        else{
            cell1.detailsLabel.text = sectionInfo.sectionValue;
            cell1.titleLabel.text = sectionInfo.sectionType;
        }
    }else{
        cell1.detailsLabel.text = sectionInfo.sectionValue;
        cell1.titleLabel.text = sectionInfo.sectionType;
    }
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell1.topLabel.hidden = NO;
            cell1.topLabelConstraint.constant = 5;
            cell1.buttomLabelConstraint.constant = 0;
            cell1.buttomLabel.backgroundColor = RGBCOLOR(215, 215, 215, 1);
        }
        else if(indexPath.row == receiptInfo.receiptDetailSec1.count - 1) {
            cell1.buttomLabel.backgroundColor = RGBCOLOR(83, 103, 197, 1);
            cell1.topLabel.hidden = YES;
            cell1.buttomLabelConstraint.constant = 5;
            cell1.topLabelConstraint.constant = 0;
        }
        else{
            cell1.topLabel.hidden = YES;
            cell1.buttomLabelConstraint.constant = 0;
            cell1.topLabelConstraint.constant = 0;
            cell1.buttomLabel.backgroundColor = RGBCOLOR(215, 215, 215, 1);
        }
    }
    else
    {
        if(indexPath.row == 0) {
            cell1.topLabel.hidden = NO;
            cell1.buttomLabelConstraint.constant = 0;
            cell1.topLabelConstraint.constant = 5;
            cell1.buttomLabel.backgroundColor = RGBCOLOR(215, 215, 215, 1);
        }
        else if (indexPath.row == receiptInfo.receiptDetailSec2.count - 1) {
            cell1.buttomLabel.backgroundColor = RGBCOLOR(83, 103, 197, 1);
            cell1.topLabel.hidden = YES;
            cell1.buttomLabelConstraint.constant = 5;
            cell1.topLabelConstraint.constant = 0;
        }
        else{
            cell1.topLabel.hidden = YES;
            cell1.buttomLabelConstraint.constant = 0;
            cell1.topLabelConstraint.constant = 0;
            cell1.buttomLabel.backgroundColor = RGBCOLOR(215, 215, 215, 1);
        }
    }
    return cell1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ((section == 0) && ![self.feeInfo.receiptNo length])
        return 0;
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView;
    
    if (![self.feeInfo.receiptNo length])
        sectionHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 0.0)];
    else
        sectionHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 40.0)];

    [sectionHeaderView setBackgroundColor:RGBCOLOR(147, 171, 254, 1)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, sectionHeaderView.frame.size.width, 20.0)];
    headerLabel.textColor = [UIColor whiteColor];
    [headerLabel setFont:[UIFont fontWithName:COMMON_APP_FONT size:16.0]];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    headerLabel.text = (section == 0)?[NSString stringWithFormat:@"Receipt Number : %@",receiptInfo.receiptNumber]:@"Fee Details";
    [sectionHeaderView addSubview:headerLabel];
    
    return sectionHeaderView;
}

#pragma MARK: UIButtonActions

-(void)leftBarButtonAction:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)makePaymentButtonAction:(id)sender {
    //Service to get the detail for payment
    [self callAPIForPaymentDetail];
}

#pragma mark -

-(void)payementStatus:(NSString *)status {
    
    [self callAPIForSuccessPayment:status];
//    if ([status isEqualToString:@"Transaction Successful"]) {
//        //Call Service if you want
//        
//        
//         [[AlertView sharedManager] presentAlertWithTitle:@"" message:status andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//             [self.makePaymentButton setHidden:YES];
//             [self.delegate payementSuccess];
//             [self.navigationController popViewControllerAnimated:NO];
//
//         }];
//    }
//    else
//       [OPRequestTimeOutView showWithMessage:status forTime:3.0 andController:self];
}


- (void)payementCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForReceiptList {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.feeInfo.receiptID forKey:pInstallmentID];
    [params setValue:self.feeInfo.feeMonth forKey:pMonthNumber];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiReceiptDetails andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            receiptInfo = [ReceiptInfoModal parseReceiptInfo:result];
            
            if ([receiptInfo.receiptDetailSec1 count] == 0) {
                UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.detailsTableView.bounds.size.width,  self.detailsTableView.bounds.size.height)];
                noDataLabel.text             = [result objectForKey:cpResponseMessage];
                noDataLabel.textColor        = [UIColor darkGrayColor];
                noDataLabel.textAlignment    = NSTextAlignmentCenter;
                self.detailsTableView.backgroundView = noDataLabel;
            } else
                self.detailsTableView.backgroundView = nil;
            
            self.detailsTableView.delegate = self;
            self.detailsTableView.dataSource = self;
            
            
            //Button Name
            if(![self.feeInfo.receiptNo length]) {
                [self.makePaymentButton setHidden:NO];
                [self.makePaymentButton setTitle:@"Pay Now" forState:UIControlStateNormal];
            }
            else {
                [self.makePaymentButton setHidden:YES];
                [self.makePaymentButton setTitle:@"Save Receipt" forState:UIControlStateNormal];
            }
            
            if (receiptInfo.isConfiguredPayment)
                [self.makePaymentButton setHidden:NO];
            else
                [self.makePaymentButton setHidden:YES];
            

            
            [self.detailsTableView reloadData];
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForPaymentDetail {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    int randomNumber = (arc4random() % 999999999) + 1;
    strOrderId=[NSString stringWithFormat:@"%d",randomNumber];
    
    [params setValue:strOrderId forKey:@"orderID"];
    [params setValue:receiptInfo.totalAmount forKey:@"amount"];
    amount = receiptInfo.totalAmount;

    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiPaymentDetails andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            paymentArray = [NSMutableArray array];
            
                receiptInfo = [ReceiptInfoModal parsePaymentType:result];
                [paymentArray addObject:receiptInfo];
            
            CCWebViewController* controller = [[CCWebViewController alloc] initWithNibName:@"CCWebViewController" bundle:nil];
            
             receiptInfo = [paymentArray firstObject];
            
//            // Generate Random Number
//            NSTimeInterval  today = [[NSDate date] timeIntervalSince1970];
//            NSString *intervalString = [NSString stringWithFormat:@"%f", today];
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[intervalString doubleValue]];
//            
//            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
            //NSString *strOrderId=[formatter stringFromDate:date];

            //Required field for payment
            controller.accessCode = receiptInfo.accessCode;
            controller.merchantId = receiptInfo.merchantID;
            controller.amount = amount;
           // controller.amount = @"1";
            controller.currency = receiptInfo.currency;
            controller.orderId = strOrderId;

            //URL's
            controller.redirectUrl = receiptInfo.jsonURL;
            controller.cancelUrl   = receiptInfo.jsonURL;
            controller.rsaKeyUrl   = receiptInfo.rsaURL;
            controller.initialURL   = receiptInfo.transactionURL;
            controller.workingKeyURL   = receiptInfo.workingKeyURL;

            //Billing Detail
            controller.billingName    = receiptInfo.billingName;
            controller.billingAddress = receiptInfo.billingAddress;
            controller.billingZipCode = receiptInfo.billingZipCode;
            controller.billingCity    = receiptInfo.billingCity;
            controller.billingState   = receiptInfo.billingState;
            controller.country        = receiptInfo.billingCountry;
            controller.mobileNumber   = receiptInfo.mobileNumber;
            controller.email          = receiptInfo.emailID;
            
//            controller.accessCode = @"4YRUXLSRO20O8NIH";
//            controller.merchantId = @"2";
//            controller.amount = @"1.00";
//            controller.currency = @"INR";
//            controller.orderId = [NSString string];
//            
//            //URL's
//            controller.redirectUrl = @"http://122.182.6.216/merchant/ccavResponseHandler.jsp";
//            controller.cancelUrl = @"http://122.182.6.216/merchant/ccavResponseHandler.jsp";
//            controller.rsaKeyUrl = @"http://122.182.6.216/merchant/GetRSA.jsp";
//            
//            //Billing Detail
//            controller.billingName = @"Abhishek Agarwal";
//            controller.billingAddress = @"Okhla Phase 1";
//            controller.billingZipCode = @"110022";
//            controller.billingCity = @"Delhi";
//            controller.billingState = @"New Delhi";
//            controller.country = @"India";
//            controller.mobileNumber = @"9711611791";
//            controller.email = @"abhishek.agarwal@mobiloittegroup.com";
//            
            //Set Delegate for comeback
            controller.delegate = self;
            
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:controller animated:YES completion:nil];
            
        }else if ([[result valueForKey:cpResponseCode] integerValue] == 500){
            [OPRequestTimeOutView showWithMessage:@"Sorry, payment gateway is not configure." forTime:3.0 andController:self];
        }
        
        else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}

-(void)callAPIForSuccessPayment:(NSString*)status {
    
    receiptInfo = [paymentArray firstObject];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:strOrderId forKey:@"orderID"];
    [params setValue:self.feeInfo.receiptID forKey:@"receiptID"];
    [params setValue:self.feeInfo.feeMonth forKey:@"month"];
    
    if ([status isEqualToString:@"Transaction Successful"])
        [params setValue:@"Transaction Successfull" forKey:@"status"];
    else
        [params setValue:status forKey:@"status"];

    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiPaymentSuccess andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKeyNotNull:@"responseMessage" expectedObj:[NSString string]] andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                [self.makePaymentButton setHidden:YES];
                [self.delegate payementSuccess];
                [self.navigationController popViewControllerAnimated:NO];
            }];
            
        }else {
            
            [[AlertView sharedManager] presentAlertWithTitle:@"" message:[result objectForKeyNotNull:cpResponseMessage expectedObj:[NSString string]] andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                //[self.makePaymentButton setHidden:YES];
              //  [self.delegate payementSuccess];
                [self.navigationController popViewControllerAnimated:NO];
            }];
            
        }
    }];
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [OPRequestTimeOutView hide];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
