//
//  Event.h
//  ParentApp
//
//  Created by Yogesh Pal on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *eventDetail;
@property (nonatomic, strong) NSString *eventStartDate;
@property (nonatomic, strong) NSString *eventEndDate;
@property (nonatomic, strong) NSString *eventDayKey;
@property (nonatomic, strong) NSDate *eventDate;

@property (nonatomic, assign) BOOL status;

+(NSMutableArray *)parseEventDataWith:(NSDictionary *)dict;

@end
