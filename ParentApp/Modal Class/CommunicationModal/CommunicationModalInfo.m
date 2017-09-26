//
//  CommunicationModalInfo.m
//  ParentApp
//
//  Created by Prince Kadian on 18/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "CommunicationModalInfo.h"
#import "NSDictionary+NullChecker.h"
#import "PAUtility.h"

@implementation CommunicationModalInfo

+(CommunicationModalInfo *)parseMessagesInfo:(NSDictionary*)messageDict{
    
    CommunicationModalInfo *messageInfo = [[CommunicationModalInfo alloc] init];
    
   // NSDate *entryDate = [PAUtility convertJSONDateIntoNSDate:[messageDict objectForKeyNotNull:@"entryDate" expectedObj:@""]];
    messageInfo.entryDate = [messageDict objectForKeyNotNull:@"entryDate" expectedObj:@""];
    //messageInfo.entryTime = [PAUtility getTimeStringFromDate:entryDate];

    //NSDate *createdDate = [PAUtility convertJSONDateIntoNSDate:[messageDict objectForKeyNotNull:@"createdDate" expectedObj:@""]];
    messageInfo.createdDate = [messageDict objectForKeyNotNull:@"createdDate" expectedObj:@""];
   // messageInfo.createdTime = [PAUtility getTimeStringFromDate:createdDate];
    
    messageInfo.userId = [messageDict objectForKeyNotNull:@"userID" expectedObj:@""];
    messageInfo.appMessageID = [messageDict objectForKeyNotNull:@"appMessageID" expectedObj:@""];
    
   // messageInfo.content = [[messageDict objectForKeyNotNull:@"content" expectedObj:@""] stringByRemovingPercentEncoding];
    
    messageInfo.content = [messageDict objectForKeyNotNull:@"content" expectedObj:@""];
    messageInfo.subjectName = [messageDict objectForKeyNotNull:@"subjectName" expectedObj:@""];
    messageInfo.createdForUserId = [messageDict objectForKeyNotNull:@"createdForUserID" expectedObj:@""];
    messageInfo.createdByUserId = [messageDict objectForKeyNotNull:@"createdByUserId" expectedObj:@""];
    
    return messageInfo;
}

+(CommunicationModalInfo *)parseComposeType:(NSDictionary*)messageDict {
    
    CommunicationModalInfo *messageInfo = [[CommunicationModalInfo alloc] init];
    messageInfo.allSubject = [messageDict objectForKeyNotNull:@"messageTypeName" expectedObj:@""];
    messageInfo.typeId = [messageDict objectForKeyNotNull:@"messageTypeId" expectedObj:@""];
    
    return messageInfo;
}


@end
