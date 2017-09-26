//
//  OPPagination.h
//  Openia
//
//  Created by Sunil Verma on 20/04/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <foundation/Foundation.h>

@interface Pagination : NSObject

@property (nonatomic, assign) NSInteger totalRecords;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) NSInteger maxPages;
@property (nonatomic, assign) NSInteger pageSize;

+(Pagination *)getPaginationInfoFromDict : (NSDictionary *)data;

@end
