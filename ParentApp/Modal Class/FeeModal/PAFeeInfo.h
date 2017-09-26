//
//  PAFeeModal.h
//  ParentApp
//
//  Created by Prince Kadian on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAFeeInfo : NSObject

//@property  (strong, nonatomic)  NSString  *paymentDate;
@property  (strong, nonatomic)  NSString  *installmentNumber;
@property  (strong, nonatomic)  NSString  *statusColor;
@property  (strong, nonatomic)  NSString  *paidAmount;
@property  (strong, nonatomic)  NSString  *payableAmount;
@property  (strong, nonatomic)  NSString  *receiptID;
@property  (strong, nonatomic)  NSString  *feeMonth;
@property  (strong, nonatomic)  NSDate    *feesDate;
@property  (strong, nonatomic)  NSString    *feesDateString;
@property  (strong, nonatomic)  NSString  *receiptNo;

+(PAFeeInfo *)parseFeeInfo:(NSDictionary*)feeDictionary;

@end
