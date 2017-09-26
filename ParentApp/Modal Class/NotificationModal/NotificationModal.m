//
//  NotificationModal.m
//  ParentApp
//
//  Created by Abhishek Agarwal on 14/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "NotificationModal.h"
#import "NSDictionary+NullChecker.h"
#import "ISConstants.h"
#import "PAUtility.h"

@implementation NotificationModal

+(NotificationModal *)parseNotificationList:(NSDictionary *)studentDictionary {
    
    NotificationModal *notificationModal = [NotificationModal new];
    
    notificationModal.notificationID = [studentDictionary objectForKeyNotNull:pNotificationID expectedObj:@""];
    notificationModal.notificationTitle = [studentDictionary objectForKeyNotNull:pNotificationTitle expectedObj:@""];
    notificationModal.notificationDescription = [studentDictionary objectForKeyNotNull:pNotificationDescription expectedObj:@""];
    
    notificationModal.isRead = [studentDictionary objectForKeyNotNull:pIsRead expectedObj:@""];
    notificationModal.notificationType = [studentDictionary objectForKeyNotNull:pNotiType expectedObj:@""];

    
    NSDate *notificationDate = [PAUtility convertJSONDateIntoNSDate:[studentDictionary objectForKeyNotNull:pNotificationCreatedOn expectedObj:@""]];
    
    notificationModal.notificationDateTimeStamp = [notificationDate timeIntervalSince1970];

    notificationModal.notificationTime = [PAUtility getTimeFromTimeStamp: notificationModal.notificationDateTimeStamp];
    notificationModal.notificationDate = [PAUtility getDateFromTimeStamp: notificationModal.notificationDateTimeStamp];
    
    return notificationModal;
}


+(NotificationModal *)parseContactUs:(NSDictionary *)contactDictionary {
    
    NotificationModal *notificationModal = [NotificationModal new];
    
    notificationModal.address = [contactDictionary objectForKeyNotNull:@"address" expectedObj:@""];

    notificationModal.email = [contactDictionary objectForKeyNotNull:@"email" expectedObj:@""];
    
    notificationModal.mobile = [contactDictionary objectForKeyNotNull:@"mobileNumber" expectedObj:@""];
    
    notificationModal.landline = [contactDictionary objectForKeyNotNull:@"landlineNumber" expectedObj:@""];

    return notificationModal;
}


@end
