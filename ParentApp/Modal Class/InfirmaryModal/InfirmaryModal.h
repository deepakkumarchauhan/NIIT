//
//  InfirmaryModal.h
//  ParentApp
//
//  Created by Prince Kadian on 13/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfirmaryModal : NSObject


@property (strong, nonatomic) NSString  * infirmaryIDString;
@property (strong, nonatomic) NSString  * infirmaryDateString;
@property (strong, nonatomic) NSString  * infirmaryTimeString;
@property (strong, nonatomic) NSString  * infirmaryHeadingString;
@property (strong, nonatomic) NSString  * infirmaryDetailsString;
@property (strong, nonatomic) NSString  * remarksString;
@property (strong, nonatomic) NSString  * medicineString;
@property (strong, nonatomic) NSString  * amountofDoseString;
@property (assign, nonatomic) NSInteger   totalRecordsInteger;


+(InfirmaryModal *)parseDataFor_InfirmaryIllnessList:(NSDictionary *)dict;

+(InfirmaryModal *)parseDataFor_InfirmaryVaccinationList:(NSDictionary *)dict;

@end
