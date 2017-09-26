//
//  LibraryModal.h
//  ParentApp
//
//  Created by Prince Kadian on 17/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibraryModal : NSObject

// ReservationViewController and BookDetailsViewController
@property  (strong, nonatomic)  NSString  *bookID;
@property  (strong, nonatomic)  NSString  *bookTitle;
@property  (strong, nonatomic)  NSString  *authorName;
@property  (strong, nonatomic)  NSString  *publisher;
@property  (strong, nonatomic)  NSString  *details;
@property  (strong, nonatomic)  NSString  *issueDate;
@property  (strong, nonatomic)  NSString  *returnDate;
@property  (strong, nonatomic)  NSString  *noOfBooks;
@property  (strong, nonatomic)  NSString  *strAlertMsg;
@property  (strong, nonatomic)  NSString  *strAccessionNumber;
@property  (strong, nonatomic)  NSString  *strBookName;
@property  (strong, nonatomic)  NSString  *strTotalRecord;
@property  (strong, nonatomic)  NSString  *dueDate;
@property  (strong, nonatomic)  NSString  *keywords;
@property  (strong, nonatomic)  NSString  *status;
@property  (strong, nonatomic)  NSString  *searchString;
@property  (strong, nonatomic)  NSString  *issueTime;
@property  (strong, nonatomic)  NSString  *dueTime;
@property  (strong, nonatomic)  NSString  *returnTime;
@property  (strong, nonatomic)  NSString  *isBooked;

@property  (strong, nonatomic)  NSString  *bookAuthorName;
@property  (strong, nonatomic)  NSString  *bookName;
@property  (strong, nonatomic)  NSString  *keyword;


@property  (strong, nonatomic)  NSString  *publisherName;

@property  (strong, nonatomic)  NSString  *issueReturnId;

@property  (strong, nonatomic)  NSString  *libraryName;
@property  (strong, nonatomic)  NSString  *fineAmount;
@property  (strong, nonatomic)  NSString  *issuedFor;

@property  (strong, nonatomic)  NSString  *type;


+(LibraryModal *)parseLibraryInfo:(NSDictionary*)feeDictionary;

@end
