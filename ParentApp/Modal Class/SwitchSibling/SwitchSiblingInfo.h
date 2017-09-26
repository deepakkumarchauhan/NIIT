//
//  SwitchSiblingInfo.h
//  ParentApp
//
//  Created by Prince Kadian on 16/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchSiblingInfo : NSObject

@property (strong, nonatomic) NSString *studentID;
@property (strong, nonatomic) NSString *studentName;
@property (strong, nonatomic) NSString *studentPicture;
@property (strong, nonatomic) NSData *studentPictureData;

@property (strong, nonatomic) NSString *teacherName;
@property (strong, nonatomic) NSString *teacherID;
@property (strong, nonatomic) NSString *teacherPhoto;

+(SwitchSiblingInfo *)parseSiblingInfo:(NSDictionary*)siblingDictionary;

@end
