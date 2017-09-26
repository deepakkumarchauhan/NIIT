//
//  HomeModal.m
//  ParentApp
//
//  Created by Abhishek Agarwal on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "HomeModal.h"
#import "NSDictionary+NullChecker.h"
#import "ISConstants.h"

@implementation HomeModal

+(HomeModal *)parseHomeData:(NSDictionary *)homeDictionary {
    
    HomeModal *homeModal = [[HomeModal alloc]init];
    
    homeModal.studentName = [homeDictionary objectForKeyNotNull:pPIStudentName expectedObj:@""];
    homeModal.studentAdminNumber = [NSString stringWithFormat:@"%@",[homeDictionary objectForKeyNotNull:pPIAddmissionNumber expectedObj:@""]];
    homeModal.studentSection = [NSString stringWithFormat:@"Sec - %@",[homeDictionary objectForKeyNotNull:pPISection expectedObj:@""]] ;
    homeModal.studentImage = [homeDictionary objectForKeyNotNull:pPIStudentPicture expectedObj:@""];
    homeModal.studentQualification = [homeDictionary objectForKeyNotNull:pQualification expectedObj:@""];
    homeModal.studentEnrollmentNumber = [homeDictionary objectForKeyNotNull:cpEnrollmentNumber expectedObj:@""];

    homeModal.notificationCount = [homeDictionary objectForKeyNotNull:pNotificationCount expectedObj:@""];

    homeModal.dashboardArray = [NSArray arrayWithArray:[homeDictionary objectForKeyNotNull:pDashboardList expectedObj:[NSArray array]]];
    
    return homeModal;
}

@end
