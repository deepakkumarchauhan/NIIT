//
//  ReceiptInfoModal.h
//  ParentApp
//
//  Created by Prince Kadian on 04/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptInfoModal : NSObject

@property  (strong, nonatomic)  NSString  *feesID;
@property  (strong, nonatomic)  NSString  *receiptNumber;
@property  (strong, nonatomic)  NSMutableArray  *receiptDetailSec1;
@property  (strong, nonatomic)  NSMutableArray  *receiptDetailSec2;



@property  (strong, nonatomic)  NSString  *accessCode;
@property  (strong, nonatomic)  NSString  *merchantID;
@property  (strong, nonatomic)  NSString  *orderID;
@property  (strong, nonatomic)  NSString  *amount;
@property  (strong, nonatomic)  NSString  *currency;
@property  (strong, nonatomic)  NSString  *billingName;
@property  (strong, nonatomic)  NSString  *billingAddress;
@property  (strong, nonatomic)  NSString  *billingCity;
@property  (strong, nonatomic)  NSString  *billingState;
@property  (strong, nonatomic)  NSString  *billingCountry;
@property  (strong, nonatomic)  NSString  *billingZipCode;
@property  (strong, nonatomic)  NSString  *mobileNumber;
@property  (strong, nonatomic)  NSString  *emailID;
@property  (strong, nonatomic)  NSString  *totalAmount;

@property  (assign, nonatomic)  BOOL  isConfiguredPayment;


@property  (strong, nonatomic)  NSString  *transactionURL;
@property  (strong, nonatomic)  NSString  *rsaURL;
@property  (strong, nonatomic)  NSString  *jsonURL;
@property  (strong, nonatomic)  NSString  *workingKeyURL;


+(ReceiptInfoModal *)parsePaymentType:(NSDictionary*)paymentDict;

+(ReceiptInfoModal *)parseReceiptInfo:(NSDictionary*)receiptDictionary;

@end

@interface ReceiptSectionInfoModal : NSObject

@property  (strong, nonatomic)  NSString  *sectionValue;
@property  (strong, nonatomic)  NSString  *sectionType;

+(ReceiptSectionInfoModal *)parseReceiptSectionInfo:(NSString *)receiptType andReceiptValue:(NSString *)receiptValue;

@end

