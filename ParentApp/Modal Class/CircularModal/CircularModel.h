//
//  CircularModelClass.h
//  ParentApp
//
//  Created by Krati Agarwal on 16/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CircularModel : NSObject

@property(nonatomic,assign) NSInteger   segmentType;

@property (nonatomic,strong) NSString    *month;
@property (nonatomic,strong) NSString    *circularId;
@property (nonatomic,strong) NSString    *circularNo;
@property (nonatomic,strong) NSString    *noOfCircular;
@property (nonatomic,strong) NSString    *circularDate;
@property (nonatomic,strong) NSString    *circularSubject;
@property (nonatomic,strong) NSString    *circularDescription;

@property (assign,nonatomic) BOOL isTextMore;

@property (nonatomic,strong) NSString    *circularContentData;
@property (nonatomic,strong) NSData      *convertedContentData;
@property (nonatomic,strong) NSString    *circularFileType;


@property (nonatomic,strong) NSString       *circularPhoto;


+ (NSArray *)parseCircular:(NSArray *)dataArray;
+ (NSMutableArray *)parseCircularDetail:(NSArray *)dataArray;

@end
