//
//  PAFeeModal.m
//  ParentApp
//
//  Created by Vasu Saini on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PAFeeInfo.h"
#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"
#import "PAUtility.h"

@implementation PAFeeInfo

+(PAFeeInfo *)parseFeeInfo:(NSDictionary*)feeDictionary {
    
    PAFeeInfo *feeInfo = [[PAFeeInfo alloc] init];
    
    NSString *feesTimeStamp = [feeDictionary objectForKeyNotNull:cpDate expectedObj:@""];
   // feeInfo.paymentDate = [feeDictionary objectForKeyNotNull:cpDate expectedObj:@""];
    
    feeInfo.feesDate = [PAUtility  convertJSONDateIntoNSDate:feesTimeStamp];
    feeInfo.feesDateString = [PAUtility getStringFromDate:feeInfo.feesDate];
    
    feeInfo.installmentNumber = [feeDictionary objectForKeyNotNull:pInstallmentNumber expectedObj:@""];
    feeInfo.statusColor = [feeDictionary objectForKeyNotNull:pType expectedObj:@""];
    feeInfo.paidAmount = [feeDictionary objectForKeyNotNull:pPaidAmount expectedObj:@""];
    feeInfo.payableAmount = [feeDictionary objectForKeyNotNull:pPayableAmount expectedObj:@""];
    feeInfo.receiptID = [feeDictionary objectForKeyNotNull:pReceiptID expectedObj:@""];
    feeInfo.feeMonth = [feeDictionary objectForKeyNotNull:pMonthNumber expectedObj:@""];
    feeInfo.receiptNo = [feeDictionary objectForKeyNotNull:pReceiptNo expectedObj:@""];

        return feeInfo;
}

@end
