//
//  PAExamination.h
//  ParentApp
//
//  Created by Yogesh Pal on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAExamination : NSObject

@property (nonatomic, strong) NSString *reportName;
@property (nonatomic, strong) NSString *reportCaption;
@property (nonatomic, strong) NSString *reportIsPublished;
@property (nonatomic, strong) NSString *reportURL;

+(PAExamination *)parseExamData:(NSDictionary *)examDict;

@end
