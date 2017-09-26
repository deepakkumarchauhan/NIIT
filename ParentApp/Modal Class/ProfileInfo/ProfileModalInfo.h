//
//  ProfileModalInfo.h
//  ParentApp
//
//  Created by Prince Kadian on 06/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileModalInfo : NSObject

@property(assign,nonatomic) BOOL userInteraction;
@property(assign,nonatomic) BOOL userIsFirstTime;

@property (strong, nonatomic) NSString *strAlertMsg;

//Personal Info
@property (strong, nonatomic) NSString *personalInfo;
@property (strong, nonatomic) NSString *piStudentName;
@property (strong, nonatomic) NSString *piClassName;
@property (strong, nonatomic) NSString *piFatherName;
@property (strong, nonatomic) NSString *piMotherName;
@property (strong, nonatomic) NSString *piAddmissionNumber;
@property (strong, nonatomic) NSString *piSection;
@property (strong, nonatomic) NSString *piBloodGroup;
@property (strong, nonatomic) NSString *piHouse;
@property (strong, nonatomic) NSString *piStudentPicture;

//Correspondence Info
@property (strong, nonatomic) NSString *correspondenceInfo;
@property (strong, nonatomic) NSString *ciEmailID;
@property (strong, nonatomic) NSString *ciPhoneNumber;
@property (strong, nonatomic) NSString *ciAddress;

//Transport Info
@property (strong, nonatomic) NSString *transportInfo;
@property (strong, nonatomic) NSString *tiPickRoute;
@property (strong, nonatomic) NSString *tiPickupTime;
@property (strong, nonatomic) NSString *tiDropRoute;
@property (strong, nonatomic) NSString *tiDropTime;
@property (strong, nonatomic) NSString *tiTransportIncharge;
@property (strong, nonatomic) NSString *tiBusNumber;

//Class Teacher
@property (strong, nonatomic) NSString *classTeacherInfo;
@property (strong, nonatomic) NSString *classTeacherName;
@property (strong, nonatomic) NSString *ctEmployeeCode;
@property (strong, nonatomic) NSString *ctPhoneNumber;
@property (strong, nonatomic) NSString *ctEmailID;
@property (strong, nonatomic) NSString *ctTeacherImage;

//Updated Info
@property (strong, nonatomic) NSString *updatedEmailID;
@property (strong, nonatomic) NSString *updatedPhoneNumber;
@property (strong, nonatomic) NSString *updatedAddress;

+(ProfileModalInfo *)getProfileData:(NSDictionary *)dict;


@end
