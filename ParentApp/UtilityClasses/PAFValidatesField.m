//
//  NLValidatesField.m
//  ParentApp
//
//  Created by Prince Kadian on 18/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PAFValidatesField.h"

@implementation PAFValidatesField

+(BOOL)isStringVerified:(NSString*)string withPattern:(NSString*)pattern {
    
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateUsername:(NSString *)userName {
    
    NSString *exprs = @"^[A-Z0-9a-z._]+$";
        
    return [PAFValidatesField isStringVerified:userName withPattern:exprs];
}

+(BOOL)validatePassword:(NSString *)password {
    
   // NSString *pass = @"^(?=.*[A-Za-z])(?=.*)[A-Za-z]{8,}$";
     NSString *pass = @"^(?=.{8,20}$)(?=[^A-Za-z]*[A-Za-z])(?=[^0-9]*[0-9])(?:([\\w\\d*?!:;@&<>#%()^])\\1?(?!\\1))+$";

    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:pass options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *match = [expr firstMatchInString:password options:0 range:NSMakeRange(0, [password length])];

    return (match ? FALSE : TRUE);
}

+(BOOL)validateName:(NSString *)name {
    
    NSString *exprs =@"^[a-zA-Z\\s]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:name options:0 range:NSMakeRange(0, [name length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateEmailAddress:(NSString *)emailAddress {
    
    NSString *exprs = @"^(\\w[.]?)*\\w+[@](\\w[.]?)*\\w+[.][a-z]{2,4}$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *match = [expr firstMatchInString:emailAddress options:0 range:NSMakeRange(0, [emailAddress length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateUrl: (NSString *) candidate {
    
    NSString *urlRegEx =@"(http|https)://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?";
    
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:candidate options:0 range:NSMakeRange(0, [candidate length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateFirstName:(NSString *)firstName {
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:firstName options:0 range:NSMakeRange(0, [firstName length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateLastName:(NSString *)lastName {
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *match = [expr firstMatchInString:lastName options:0 range:NSMakeRange(0, [lastName length])];
    return (match ? FALSE : TRUE);
}

+(BOOL)validateAddress:(NSString *)address {
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    return (match ? FALSE : TRUE);
}

+(BOOL)validateMobileNumber:(NSString *)mobileNumber {
    
    NSString *exprs =@"^[0-9]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:mobileNumber options:0 range:NSMakeRange(0, [mobileNumber length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validatePhoneNumber:(NSString *)phoneNumber {
    return NO;
}

@end
