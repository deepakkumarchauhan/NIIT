//
//  NotificationModal.h
//  ParentApp
//
//  Created by Abhishek Agarwal on 14/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModal : NSObject

@property (strong, nonatomic) NSString *notificationID;
@property (strong, nonatomic) NSString *notificationTitle;
@property (strong, nonatomic) NSString *notificationDescription;
@property (strong, nonatomic) NSString *notificationDate;
@property (strong, nonatomic) NSString *notificationTime;
@property (assign, nonatomic) NSInteger notificationDateTimeStamp;

@property (strong, nonatomic) NSString *isRead;
@property (strong, nonatomic) NSString *notificationType;


@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *landline;

+(NotificationModal *)parseNotificationList:(NSDictionary *)studentDictionary;

+(NotificationModal *)parseContactUs:(NSDictionary *)contactDictionary;


@end
