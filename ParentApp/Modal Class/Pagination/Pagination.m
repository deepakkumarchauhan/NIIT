//
//  OPPagination.m
//  Openia
//
//  Created by Sunil Verma on 20/04/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "Pagination.h"
#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"

@implementation Pagination

+(Pagination *)getPaginationInfoFromDict : (NSDictionary *)data {
    
    Pagination *page = [[Pagination alloc] init];
    
    page.pageNumber = [[data objectForKeyNotNull:cpPageNumber expectedObj:@""] integerValue];
    page.maxPages = [[data objectForKeyNotNull:cpMaxPages expectedObj:@""] integerValue];
    page.totalRecords = [[data objectForKeyNotNull:cpTotalRecords expectedObj:@""] integerValue];
    
    return page;
}

@end

