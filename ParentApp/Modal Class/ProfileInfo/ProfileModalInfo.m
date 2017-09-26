//
//  ProfileModalInfo.m
//  ParentApp
//
//  Created by Prince Kadian on 06/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "ProfileModalInfo.h"
#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"

@implementation ProfileModalInfo

+(ProfileModalInfo *)getProfileData:(NSDictionary *)dict{
    
    ProfileModalInfo *profileDetail = [[ProfileModalInfo alloc]init];
    
    //Personal Information Dictionary
    NSDictionary *piDict = [dict objectForKeyNotNull:pPersonalInfo expectedObj:[NSDictionary dictionary]];
    profileDetail.piStudentName = [piDict objectForKeyNotNull:pPIStudentName expectedObj:[NSString string]];
    profileDetail.piClassName = [piDict objectForKeyNotNull:pPIClassName expectedObj:[NSString string]];
    profileDetail.piFatherName = [piDict objectForKeyNotNull:pPIFatherName expectedObj:[NSString string]];
    profileDetail.piMotherName = [piDict objectForKeyNotNull:pPIMotherName expectedObj:[NSString string]];
    profileDetail.piAddmissionNumber = [piDict objectForKeyNotNull:pPIAddmissionNumber expectedObj:[NSString string]];
    profileDetail.piSection = [piDict objectForKeyNotNull:pPISection expectedObj:[NSString string]];
    profileDetail.piBloodGroup = [piDict objectForKeyNotNull:pPIBloodGroup expectedObj:[NSString string]];
    profileDetail.piHouse = [piDict objectForKeyNotNull:pPIHouse expectedObj:[NSString string]];
    //profileDetail.piStudentPicture = [piDict objectForKeyNotNull:pPIStudentPicture expectedObj:[NSString string]];
    
    //Correspondence Information Dictionary
    NSDictionary *ciDict = [dict objectForKeyNotNull:pCorrespondenceInfo expectedObj:[NSDictionary dictionary]];
    profileDetail.ciEmailID = [ciDict objectForKeyNotNull:pStudentEmailID expectedObj:[NSString string]];
    profileDetail.ciPhoneNumber = [ciDict objectForKeyNotNull:pCIPhoneNumber expectedObj:[NSString string]];
    profileDetail.ciAddress = [ciDict objectForKeyNotNull:pCIAddress expectedObj:[NSString string]];
    
    profileDetail.updatedAddress = [ciDict objectForKeyNotNull:pCIAddress expectedObj:[NSString string]];
    profileDetail.updatedPhoneNumber = [ciDict objectForKeyNotNull:pCIPhoneNumber expectedObj:[NSString string]];
    profileDetail.updatedEmailID = [ciDict objectForKeyNotNull:pStudentEmailID expectedObj:[NSString string]];

    //Transport Information Dictionary
    NSDictionary *tiDict = [dict objectForKeyNotNull:pTransportInfo expectedObj:[NSDictionary dictionary]];
    profileDetail.tiPickRoute = [tiDict objectForKeyNotNull:pTIPickRoute expectedObj:[NSString string]];
    profileDetail.tiPickupTime = [tiDict objectForKeyNotNull:pTIPickupTime expectedObj:[NSString string]];
    profileDetail.tiDropRoute = [tiDict objectForKeyNotNull:pTIDropRoute expectedObj:[NSString string]];
    profileDetail.tiDropTime = [tiDict objectForKeyNotNull:pTIDropTime expectedObj:[NSString string]];
    profileDetail.tiTransportIncharge = [tiDict objectForKeyNotNull:pTITransportIncharge expectedObj:[NSString string]];
    profileDetail.tiBusNumber = [tiDict objectForKeyNotNull:pTIBusNumber expectedObj:[NSString string]];
    
    //Class Teacher Information Dictionary
    NSDictionary *ctiDict = [dict objectForKeyNotNull:pClassTeacherInfo expectedObj:[NSDictionary dictionary]];
    profileDetail.classTeacherName = [ctiDict objectForKeyNotNull:pClassTeacherName expectedObj:[NSString string]];
    profileDetail.ctEmployeeCode = [ctiDict objectForKeyNotNull:pCTEmployeeCode expectedObj:[NSString string]];
    profileDetail.ctPhoneNumber = [ctiDict objectForKeyNotNull:pCIPhoneNumber expectedObj:[NSString string]];
    profileDetail.ctEmailID = [ctiDict objectForKeyNotNull:pStudentEmailID expectedObj:[NSString string]];
    profileDetail.ctTeacherImage = [ctiDict objectForKeyNotNull:pTeacherImage expectedObj:[NSString string]];

    return profileDetail;
}
@end
