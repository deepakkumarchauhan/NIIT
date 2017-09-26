//
//  InfirmaryModal.m
//  ParentApp
//
//  Created by Prince Kadian on 13/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "InfirmaryModal.h"
#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"
#import "PAUtility.h"


@implementation InfirmaryModal

+(InfirmaryModal *)parseDataFor_InfirmaryIllnessList:(NSDictionary *)dict {
    
    InfirmaryModal * InfirmaryObject = [InfirmaryModal new];
    
  //  NSDate *date = [PAUtility convertJSONDateIntoNSDate:[dict objectForKeyNotNull:pIllnessDate expectedObj:@""]];
    InfirmaryObject.infirmaryDateString = [dict objectForKeyNotNull:pIllnessDate expectedObj:@""];
   // InfirmaryObject.infirmaryTimeString = [PAUtility getTimeStringFromDate:date];

    InfirmaryObject.infirmaryIDString = [dict objectForKeyNotNull:pIllnessID expectedObj:@""];
   // InfirmaryObject.infirmaryDateString = [dict objectForKeyNotNull:pIllnessDate expectedObj:@""];
    InfirmaryObject.infirmaryHeadingString = [dict objectForKeyNotNull:pIllnessHeading expectedObj:@""];
    InfirmaryObject.infirmaryDetailsString = [dict objectForKeyNotNull:pIllnessDetails expectedObj:@""];
    InfirmaryObject.remarksString = [dict objectForKeyNotNull:pRemarks expectedObj:@""];
    InfirmaryObject.medicineString = [dict objectForKeyNotNull:pMedicine expectedObj:@""];
    InfirmaryObject.amountofDoseString = [dict objectForKeyNotNull:pAmountofDose expectedObj:@""];
    InfirmaryObject.totalRecordsInteger = [[dict objectForKeyNotNull:cpTotalRecords expectedObj:@""]integerValue];
    
    return InfirmaryObject;
}


+(InfirmaryModal *)parseDataFor_InfirmaryVaccinationList:(NSDictionary *)dict {
    
    InfirmaryModal * InfirmaryObject = [InfirmaryModal new];
    
   // NSDate *dates = [PAUtility convertJSONDateIntoNSDate:[dict objectForKeyNotNull:pVaccinationDate expectedObj:@""]];

    InfirmaryObject.infirmaryDateString = [dict objectForKeyNotNull:pVaccinationDate expectedObj:@""];
    
   // InfirmaryObject.infirmaryTimeString = [PAUtility getTimeStringFromDate:dates];

    InfirmaryObject.infirmaryIDString = [dict objectForKeyNotNull:pVaccinationID expectedObj:@""];
    InfirmaryObject.infirmaryHeadingString = [dict objectForKeyNotNull:pVaccinationHeading expectedObj:@""];
    InfirmaryObject.infirmaryDetailsString = [dict objectForKeyNotNull:pVaccinationDetails expectedObj:@""];
    InfirmaryObject.totalRecordsInteger = [[dict objectForKeyNotNull:cpTotalRecords expectedObj:@""] integerValue];


    return InfirmaryObject;
}

@end
