//
//  NLValidatesField.h
//  ParentApp
//
//  Created by Prince Kadian on 18/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAFValidatesField : NSObject

+(BOOL)validateFirstName:(NSString *)firstName;
+(BOOL)validateLastName:(NSString *)lastName;
+(BOOL)validatePhoneNumber:(NSString *)phoneNumber;
+(BOOL)validateMobileNumber:(NSString *)mobileNumber;
+(BOOL)validateEmailAddress:(NSString *)emailAddress;
+(BOOL)validateAddress:(NSString *)address;
+(BOOL)validateUsername:(NSString *)userName;
+(BOOL)validateName:(NSString *)name;
+(BOOL)validateUrl: (NSString *) candidate ;
+(BOOL)validatePassword:(NSString *)password;

@end
