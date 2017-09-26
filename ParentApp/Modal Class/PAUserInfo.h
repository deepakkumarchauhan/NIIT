//
//  PAUserInfo.h
//  ParentApp
//
//  Created by Prince Kadian on 31/08/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAUserInfo : NSObject

// PALoginViewController
@property  (strong, nonatomic)  NSString  *userName;
@property  (strong, nonatomic)  NSString  *password;

//PAChangePasswordVC
@property  (strong, nonatomic)  NSString  *strNewPassword;
@property  (strong, nonatomic)  NSString  *strCnfrmNewPassword;
@property  (strong, nonatomic)  NSString  *strAlertMsg;

// PAAddSchoolViewController
@property  (strong, nonatomic)  NSString  *addedSchoolURL;
@property  (strong, nonatomic)  NSString  *addedSchoolNickName;
@property(assign,nonatomic)  NSInteger selectedSchool;

// FeedbackViewController
@property  (strong, nonatomic)  NSString  *feedbackEmail;
@property  (strong, nonatomic)  NSString  *feedbackName;
@property  (strong, nonatomic)  NSString  *feedbackMessage;

@end
