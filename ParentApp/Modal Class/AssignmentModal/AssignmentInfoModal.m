//
//  AssignmentInfoModal.m
//  ParentApp
//
//  Created by Prince Kadian on 08/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"
#import "AssignmentInfoModal.h"
#import "Macro.h"

@implementation SubjectInfoModal

+(SubjectInfoModal *)parseSubjectInfo:(NSDictionary*)subjectDictionary {
    
    SubjectInfoModal *subjectInfo = [[SubjectInfoModal alloc] init];
    
    subjectInfo.subjectID = [subjectDictionary objectForKeyNotNull:pSubjectID expectedObj:@""];
    subjectInfo.subjectName = [subjectDictionary objectForKeyNotNull:pSubjectName expectedObj:@""];
    
    return subjectInfo;
}

@end

@implementation AssignmentInfoModal

+(AssignmentInfoModal *)parseAssignmentInfo:(NSDictionary*)assignmentDictionary {
    
    AssignmentInfoModal *assignmentInfo = [[AssignmentInfoModal alloc] init];
    
    assignmentInfo.assignmentName = [assignmentDictionary objectForKeyNotNull:pAssignmentName expectedObj:@""];
    assignmentInfo.assignmentDetail = [assignmentDictionary objectForKeyNotNull:pAssignmentDetail expectedObj:@""];
    
    NSAttributedString *stringWithoutHTMLTag = [[NSAttributedString alloc] initWithData:[assignmentInfo.assignmentDetail dataUsingEncoding:NSUTF8StringEncoding]
                                                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                          NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                                     documentAttributes:nil
                                                                                  error:nil];
   
    assignmentInfo.assignmentDescriptionWithoutDetail = TRIMSPACE([stringWithoutHTMLTag string]);

    
    CGRect textRect = [assignmentInfo.assignmentDescriptionWithoutDetail boundingRectWithSize:CGSizeMake(WINWIDTH-184, NSIntegerMax)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Relay-Regular" size:11]}
                                                                         context:nil];
    
    
    if (textRect.size.height > 35)
        assignmentInfo.isTextMore = NO;
    else
        assignmentInfo.isTextMore = YES;
    
    assignmentInfo.assignmentPicture = [assignmentDictionary objectForKeyNotNull:pAssignmentPicture expectedObj:@""];
    assignmentInfo.assignmentDate = [assignmentDictionary objectForKeyNotNull:pAssignmentDate expectedObj:@""];
    
//    assignmentInfo.assignmentFileContent = [assignmentDictionary objectForKeyNotNull:pFileContent expectedObj:@""];
//    assignmentInfo.contentData = [[NSData alloc] initWithBase64EncodedString:assignmentInfo.assignmentFileContent options:0];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        assignmentInfo.assignmentFileContent = [assignmentDictionary objectForKeyNotNull:pFileContent expectedObj:@""];
        assignmentInfo.contentData = [[NSData alloc] initWithBase64EncodedString:assignmentInfo.assignmentFileContent options:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            // fire notification
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PDFDATA" object:nil];
        });
    });
    assignmentInfo.fileName = [assignmentDictionary objectForKeyNotNull:pFileName expectedObj:@""];
    assignmentInfo.fileType = [assignmentDictionary objectForKeyNotNull:pFileType expectedObj:@""];
    assignmentInfo.fileDescription = [assignmentDictionary objectForKeyNotNull:pFileDescription expectedObj:@""];
    
    return assignmentInfo;
}

@end
