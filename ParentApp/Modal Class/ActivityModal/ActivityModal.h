//
//  ActivityModal.h
//  ParentApp
//
//  Created by Prince Kadian on 13/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModal : NSObject

@property (strong, nonatomic) NSString   * activityIdString;
@property (strong, nonatomic) NSString   * studentNameString;
@property (strong, nonatomic) NSString   * eventNameString;
@property (strong, nonatomic) NSString   * positionString;
@property (assign, nonatomic) NSInteger    pointsInteger;
@property (strong, nonatomic) NSString   * eventDateString;
@property (strong, nonatomic) NSString   * eventLevelString;
@property (strong, nonatomic) NSString   * addressString;
@property (strong, nonatomic) NSString   * activityNameString;
@property (strong, nonatomic) NSString   * activityDescriptionString;
@property (assign, nonatomic) NSInteger    totalRecordsInteger;
@property (strong, nonatomic) NSString   * eventTimeString;


+(ActivityModal *)parseDataFor_activityList:(NSDictionary *) dict;

@end
