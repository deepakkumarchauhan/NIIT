//
//  LibraryModal.m
//  ParentApp
//
//  Created by Prince Kadian on 17/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "LibraryModal.h"
#import "NSDictionary+NullChecker.h"
#import "PAUtility.h"

@implementation LibraryModal

+(LibraryModal *)parseLibraryInfo:(NSDictionary*)feeDictionary {
    
    LibraryModal *libraryInfo = [[LibraryModal alloc] init];
    
    NSDate *issueDate = [PAUtility convertJSONDateIntoNSDate:[feeDictionary objectForKeyNotNull:@"issueDate" expectedObj:@""]];
   // libraryInfo.issueDate = [PAUtility getStringFromDate:issueDate];
    libraryInfo.issueTime = [PAUtility getTimeStringFromDate:issueDate];
   
    NSDate *dueDate = [PAUtility convertJSONDateIntoNSDate:[feeDictionary objectForKeyNotNull:@"dueDate" expectedObj:@""]];
   // libraryInfo.dueDate = [PAUtility getStringFromDate:dueDate];
    libraryInfo.dueTime = [PAUtility getTimeStringFromDate:dueDate];
    
    NSDate *returnDate = [PAUtility convertJSONDateIntoNSDate:[feeDictionary objectForKeyNotNull:@"returnDate" expectedObj:@""]];
  //  libraryInfo.returnDate = [PAUtility getStringFromDate:returnDate];
    libraryInfo.returnTime = [PAUtility getTimeStringFromDate:returnDate];
    
    
     libraryInfo.issueDate = [feeDictionary objectForKeyNotNull:@"issueDate" expectedObj:@""];
      libraryInfo.returnDate = [feeDictionary objectForKeyNotNull:@"returnDate" expectedObj:@""];
    libraryInfo.dueDate = [feeDictionary objectForKeyNotNull:@"dueDate" expectedObj:@""];

    libraryInfo.bookID = [feeDictionary objectForKeyNotNull:@"bookID" expectedObj:@""];
    libraryInfo.strAccessionNumber = [feeDictionary objectForKeyNotNull:@"accessionNo" expectedObj:@""];
    libraryInfo.strBookName = [feeDictionary objectForKeyNotNull:@"bookName" expectedObj:@""];
    libraryInfo.strTotalRecord = [feeDictionary objectForKeyNotNull:@"totalRecords" expectedObj:@""];
    libraryInfo.authorName = [feeDictionary objectForKeyNotNull:@"authorName" expectedObj:@""];
    libraryInfo.keywords = [feeDictionary objectForKeyNotNull:@"keywords" expectedObj:@""];
    libraryInfo.status = [feeDictionary objectForKeyNotNull:@"status" expectedObj:@""];
    libraryInfo.libraryName = [feeDictionary objectForKeyNotNull:@"libraryName" expectedObj:@""];
    libraryInfo.publisher = [feeDictionary objectForKeyNotNull:@"publisher" expectedObj:@""];
    libraryInfo.issuedFor = [feeDictionary objectForKeyNotNull:@"issuedFor" expectedObj:@""];
    
    libraryInfo.type = [feeDictionary objectForKeyNotNull:@"type" expectedObj:@""];

    
    libraryInfo.fineAmount = [NSString stringWithFormat:@"%0.2f",[[feeDictionary objectForKeyNotNull:@"fineAmount" expectedObj:@""] floatValue]];

    libraryInfo.publisherName = [feeDictionary objectForKeyNotNull:@"publisherName" expectedObj:@""];

    libraryInfo.issueReturnId = [feeDictionary objectForKeyNotNull:@"issueReturnId" expectedObj:@""];
    libraryInfo.isBooked = [NSString stringWithFormat:@"%ld",(long)[[feeDictionary objectForKeyNotNull:@"isBooked" expectedObj:@""] integerValue]];
    
    return libraryInfo;
}

@end
