//
//  CommunicationModalInfo.h
//  ParentApp
//
//  Created by Prince Kadian on 18/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunicationModalInfo : NSObject

@property  (strong, nonatomic)  NSString  *senderImage;
@property  (strong, nonatomic)  NSString  *senderName;
@property  (strong, nonatomic)  NSString  *details;
@property  (strong, nonatomic)  NSString  *userId;
@property  (strong, nonatomic)  NSString  *appMessageID;
@property  (strong, nonatomic)  NSString  * content;
@property  (strong, nonatomic)  NSString  *subjectName;
@property  (strong, nonatomic)  NSString  *createdForUserId;
@property  (strong, nonatomic)  NSString  *entryDate;
@property  (strong, nonatomic)  NSString  *createdByUserId;
@property  (strong, nonatomic)  NSString  *createdDate;
@property  (strong, nonatomic)  NSString  *entryTime;
@property  (strong, nonatomic)  NSString  *createdTime;

@property  (strong, nonatomic)  NSString  *type;
@property  (strong, nonatomic)  NSString  *subject;

@property  (strong, nonatomic)  NSString  *subjectTypeId;
@property  (strong, nonatomic)  NSString  *typeId;
@property  (strong, nonatomic)  NSString  *allSubject;



+(CommunicationModalInfo *)parseMessagesInfo:(NSDictionary*)messageDict;

+(CommunicationModalInfo *)parseComposeType:(NSDictionary*)messageDict;

//ChatVC
@property  (strong, nonatomic)  NSString  *message;

@end
