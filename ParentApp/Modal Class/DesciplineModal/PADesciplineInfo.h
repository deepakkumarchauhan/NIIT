//
//  PADesciplineInfo.h
//  ParentApp
//
//  Created by Prince Kadian on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PADesciplineInfo : NSObject

@property  (strong, nonatomic)  NSString  *date;
@property  (strong, nonatomic)  NSString  *actionPoints;
@property  (strong, nonatomic)  NSString  *reason;
@property  (strong, nonatomic)  NSString  *techerName;
@property  (strong, nonatomic)  NSString  *card;
@property  (strong, nonatomic)  NSString  *disciplineID;

+(PADesciplineInfo *)getDesciplineInfo:(NSDictionary*)response;

@end
