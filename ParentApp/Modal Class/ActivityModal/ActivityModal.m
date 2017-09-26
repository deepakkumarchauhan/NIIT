//
//  ActivityModal.m
//  ParentApp
//
//  Created by Prince Kadian on 13/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "ActivityModal.h"
#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"
#import "PAUtility.h"

@implementation ActivityModal

+(ActivityModal *)parseDataFor_activityList:(NSDictionary *)dict {
    
    ActivityModal * activityObject = [ActivityModal new];
    
    //NSDate *date = [PAUtility convertJSONDateIntoNSDate:[dict objectForKeyNotNull:pEventDate expectedObj:@""]];
    
    activityObject.eventDateString = [dict objectForKeyNotNull:pActivityDate expectedObj:@""];
    
   // activityObject.eventTimeString = [PAUtility getTimeStringFromDate:date];
    activityObject.activityIdString = [dict objectForKeyNotNull:pActivityID expectedObj:@""];
    activityObject.studentNameString = [dict objectForKeyNotNull:pPIStudentName expectedObj:@""];
    activityObject.eventNameString = [dict objectForKeyNotNull:pCalendarEventName expectedObj:@""];
    
//    if([[dict objectForKeyNotNull:pPosition expectedObj:@""] isEqualToString:@"First"]) {
//       activityObject.positionString = @"1st";
//    }
//   else if([[dict objectForKeyNotNull:pPosition expectedObj:@""] isEqualToString:@"Second"]) {
        activityObject.positionString = [dict objectForKeyNotNull:pPosition expectedObj:@""];
   // }
//   else{
//       activityObject.positionString = @"3rd";
//   }
    activityObject.pointsInteger = [[dict objectForKeyNotNull:pActionPoints expectedObj:@""]integerValue];
    activityObject.eventLevelString = [dict objectForKeyNotNull:pEventLevel expectedObj:@""];
    activityObject.addressString = [dict objectForKeyNotNull:pCIAddress expectedObj:@""];
    activityObject.activityNameString = [dict objectForKeyNotNull:pActivityName expectedObj:@""];
    activityObject.activityDescriptionString = [dict objectForKeyNotNull:pActivityDescription expectedObj:@""];
    activityObject.totalRecordsInteger = [[dict objectForKeyNotNull:cpTotalRecords expectedObj:@""]integerValue];

    return activityObject;
}
@end
