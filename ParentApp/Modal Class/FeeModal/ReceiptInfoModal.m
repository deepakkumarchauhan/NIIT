//
//  ReceiptInfoModal.m
//  ParentApp
//
//  Created by Prince Kadian on 04/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "ReceiptInfoModal.h"
#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"

@implementation ReceiptInfoModal


+(ReceiptInfoModal *)parseReceiptInfo:(NSDictionary*)receiptDictionary{
    
    ReceiptInfoModal *receiptInfo = [[ReceiptInfoModal alloc] init];
    
    receiptInfo.receiptDetailSec1 = [NSMutableArray array];
    receiptInfo.receiptDetailSec2 = [NSMutableArray array];

    receiptInfo.feesID = [receiptDictionary objectForKeyNotNull:pFeesID expectedObj:@""];
    receiptInfo.receiptNumber = [receiptDictionary objectForKeyNotNull:pReceiptNo expectedObj:@""];

    receiptInfo.totalAmount = [receiptDictionary objectForKeyNotNull:pPaidFee expectedObj:@""];
    
    receiptInfo.isConfiguredPayment = [[receiptDictionary objectForKeyNotNull:pPaymentConfigure expectedObj:@""] boolValue] ;

    NSString *enrollmentNo = [receiptDictionary objectForKeyNotNull:pEnrollmentNo expectedObj:@""];
    [receiptInfo.receiptDetailSec1 addObject:[ReceiptSectionInfoModal parseReceiptSectionInfo:@"Admission Number" andReceiptValue:enrollmentNo]];

    NSString *studentName = [receiptDictionary objectForKeyNotNull:pStudentName expectedObj:@""];
    [receiptInfo.receiptDetailSec1 addObject:[ReceiptSectionInfoModal parseReceiptSectionInfo:@"Student Name" andReceiptValue:studentName]];

    NSString *fatherName = [receiptDictionary objectForKeyNotNull:pFatherName expectedObj:@""];
    [receiptInfo.receiptDetailSec1 addObject:[ReceiptSectionInfoModal parseReceiptSectionInfo:@"Father's Name" andReceiptValue:fatherName]];

    NSString *className = [receiptDictionary objectForKeyNotNull:pClassName expectedObj:@""];
    [receiptInfo.receiptDetailSec1 addObject:[ReceiptSectionInfoModal parseReceiptSectionInfo:@"Class" andReceiptValue:className]];

    NSString *sectionName = [receiptDictionary objectForKeyNotNull:pSectionName expectedObj:@""];
    [receiptInfo.receiptDetailSec1 addObject:[ReceiptSectionInfoModal parseReceiptSectionInfo:@"Section" andReceiptValue:sectionName]];

    
    NSArray *feesListArray = [receiptDictionary objectForKeyNotNull:pFeeDetailList expectedObj:[NSArray array]];
    
    for (NSDictionary *dict in feesListArray) {
        NSString *feesValue = [dict objectForKeyNotNull:@"amount" expectedObj:[NSString string]];
        [receiptInfo.receiptDetailSec2 addObject:[ReceiptSectionInfoModal parseReceiptSectionInfo:[dict objectForKeyNotNull:pFeeType expectedObj:@""] andReceiptValue:feesValue]];
    }
   
    NSString *date = [receiptDictionary objectForKeyNotNull:cpDate expectedObj:@""];
    [receiptInfo.receiptDetailSec2 addObject:[ReceiptSectionInfoModal parseReceiptSectionInfo:@"Paid Date" andReceiptValue:date]];
    
    NSString *month = [receiptDictionary objectForKeyNotNull:pMonthNumber expectedObj:@""];
    [receiptInfo.receiptDetailSec2 addObject:[ReceiptSectionInfoModal parseReceiptSectionInfo:@"Month" andReceiptValue:month]];
    
    NSString *paidFee = [receiptDictionary objectForKeyNotNull:pPaidFee expectedObj:@""];
    [receiptInfo.receiptDetailSec2 addObject:[ReceiptSectionInfoModal parseReceiptSectionInfo:@"Paid Fee" andReceiptValue:paidFee]];
    
    NSString *mop = [receiptDictionary objectForKeyNotNull:pMop expectedObj:@""];
    [receiptInfo.receiptDetailSec2 addObject:[ReceiptSectionInfoModal parseReceiptSectionInfo:@"MOP" andReceiptValue:mop]];
    
    return receiptInfo;
}


+(ReceiptInfoModal *)parsePaymentType:(NSDictionary*)paymentDict {
    
    ReceiptInfoModal *paymentInfo = [[ReceiptInfoModal alloc] init];
    
    paymentInfo.accessCode = [paymentDict objectForKeyNotNull:cpAccessCode expectedObj:@""];
    paymentInfo.merchantID = [paymentDict objectForKeyNotNull:cpMerchantID expectedObj:@""];
    paymentInfo.orderID = [paymentDict objectForKeyNotNull:cpOrderID expectedObj:@""];
    paymentInfo.amount = [paymentDict objectForKeyNotNull:cpAmount expectedObj:@""];
    paymentInfo.currency = [paymentDict objectForKeyNotNull:cpCurrency expectedObj:@""];
    paymentInfo.billingName = [paymentDict objectForKeyNotNull:cpBillingName expectedObj:@""];
    paymentInfo.billingAddress = [paymentDict objectForKeyNotNull:cpBillingAddress expectedObj:@""];
    paymentInfo.billingCity = [paymentDict objectForKeyNotNull:cpBillingCity expectedObj:@""];
    paymentInfo.billingState = [paymentDict objectForKeyNotNull:cpBillingState expectedObj:@""];
    paymentInfo.billingCountry = [paymentDict objectForKeyNotNull:cpBillingCountry expectedObj:@""];
    
    paymentInfo.billingZipCode = [paymentDict objectForKeyNotNull:cpBillingZipCode expectedObj:@""];
    
    paymentInfo.mobileNumber = [paymentDict objectForKeyNotNull:cpMobileNumber expectedObj:@""];

    
    paymentInfo.emailID = [paymentDict objectForKeyNotNull:cpEmailID expectedObj:@""];
    
    paymentInfo.transactionURL = [paymentDict objectForKeyNotNull:cpTransactionURL expectedObj:@""];
    paymentInfo.workingKeyURL = [paymentDict objectForKeyNotNull:cpWorkingKeyURL expectedObj:@""];

    paymentInfo.rsaURL = [paymentDict objectForKeyNotNull:cpRsaURL expectedObj:@""];
    paymentInfo.jsonURL = [paymentDict objectForKeyNotNull:cpJsonURL expectedObj:@""];

    return paymentInfo;
}


@end

@implementation ReceiptSectionInfoModal


+(ReceiptSectionInfoModal *)parseReceiptSectionInfo:(NSString *)receiptType andReceiptValue:(NSString *)receiptValue {
    
    ReceiptSectionInfoModal *receiptSectionInfo = [[ReceiptSectionInfoModal alloc] init];
    
    receiptSectionInfo.sectionValue = receiptValue;
    receiptSectionInfo.sectionType = receiptType;

    return receiptSectionInfo;
}

@end
