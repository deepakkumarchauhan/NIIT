//
//  Event.m
//  ParentApp
//
//  Created by Yogesh Pal on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "Event.h"
#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"
#import "PAUtility.h"

@implementation Event

+(NSMutableArray *)parseEventDataWith:(NSDictionary *)dict
{
    NSMutableArray *eventList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *eventDict in [dict objectForKeyNotNull:pCalendarEventList expectedObj:[NSArray array]]) {
        
        Event *objEvent = [[Event alloc] init];
        
        objEvent.eventName = [eventDict objectForKeyNotNull:pCalendarEventName expectedObj:@""];
        objEvent.eventDetail = [eventDict objectForKeyNotNull:pCalendarDetails expectedObj:@""];
        objEvent.eventStartDate = [eventDict objectForKeyNotNull:pCalendarFromDate expectedObj:@""];
        objEvent.eventEndDate = [eventDict objectForKeyNotNull:pCalendarToDate expectedObj:@""];
        objEvent.status = [[eventDict objectForKeyNotNull:pStatus expectedObj:@""] boolValue];
        objEvent.eventDayKey = [eventDict objectForKeyNotNull:pDayKey expectedObj:@""];

        NSString *calendarDate = [eventDict objectForKeyNotNull:pCalendarDate expectedObj:@""];
        objEvent.eventDate  = [PAUtility convertJSONDateIntoNSDate:calendarDate];
        
        [eventList addObject:objEvent];
    }
    
    return [eventList mutableCopy];
}
@end
