
//
//  CircularModelClass.m
//  ParentApp
//
//  Created by Krati Agarwal on 16/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "CircularModel.h"
#import "NSDictionary+NullChecker.h"
#import "ISConstants.h"
#import "Macro.h"

@implementation CircularModel

+ (NSArray *)parseCircular:(NSArray *)dataArray {
    
    NSMutableArray *list = [NSMutableArray array];
    
    for (NSDictionary *circularDict in dataArray)
        [list addObject:[CircularModel circularsDetail:circularDict]];
    
    return [list mutableCopy];
}

+ (NSArray *)parseCircularDetail:(NSArray *)dataArray {
    
    NSMutableArray *list = [NSMutableArray array];
    
    for (NSDictionary *circularDict in dataArray)
        [list addObject:[CircularModel circularsDetail:circularDict]];
    
    return [list mutableCopy];
}

+ (CircularModel *)circularsDetail:(NSDictionary *)dataDict {
    
    CircularModel *circular = [[CircularModel alloc]init];
    
    circular.circularId = [dataDict objectForKeyNotNull:pCircularID expectedObj:@""];
    circular.circularNo = [dataDict objectForKeyNotNull:pCircularNO expectedObj:@""];
    circular.circularDate = [dataDict objectForKeyNotNull:pCircularDate expectedObj:@""];
    circular.circularPhoto = [dataDict objectForKeyNotNull:pCircularPhoto expectedObj:@""];
    circular.circularSubject = [dataDict objectForKeyNotNull:pSubject expectedObj:@""];
    circular.noOfCircular = [dataDict objectForKeyNotNull:pNoOfCirculars expectedObj:@""];
    circular.circularDescription = TRIMSPACE([dataDict objectForKeyNotNull:pDescription expectedObj:@""]);
    
    CGRect textRect = [circular.circularDescription boundingRectWithSize:CGSizeMake(WINWIDTH - 203, NSIntegerMax)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Relay-Regular" size:11]}
                                                                 context:nil];
    
    if (textRect.size.height > 35)
        circular.isTextMore = NO;
    else
        circular.isTextMore = YES;

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        circular.circularContentData = [dataDict objectForKeyNotNull:@"contentData" expectedObj:@""];
        circular.convertedContentData = [[NSData alloc] initWithBase64EncodedString:circular.circularContentData options:0];
        circular.circularFileType = [dataDict objectForKeyNotNull:@"fileType" expectedObj:@""];
        dispatch_async(dispatch_get_main_queue(), ^{
            // fire notification
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PDFDATA" object:nil];
        });
    });
    
    return circular;
}

@end
