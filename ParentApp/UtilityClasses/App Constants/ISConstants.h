//
//  AHConstants.h
//  AHTO
//
//  Created by Sunil Verma on 12/25/14.
//  Copyright (c) 2014 mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

//API Names
extern NSString *apiLogin;
extern NSString *apiChangePassword;
extern NSString *apiMyProfile;
extern NSString *apiStudentDetail;
extern NSString *apiDashboard;
extern NSString *apiNotification;
extern NSString *apiLogout;
extern NSString *apiExamination;
extern NSString *apiDiscipline ;
extern NSString *apiAttendanceBar ;
extern NSString *apiAttendanceCalendar;
extern NSString *apiFeeList;
extern NSString *apiSwitchSibling;
extern NSString *apiSubjectList;
extern NSString *apiGetRouteDetails;
extern NSString *apiGetMainCirculars;
extern NSString *apiGetDetailsOfCirculars;
extern NSString *apiStudentPhotoGallery;
extern NSString *apiAssignmentList;
extern NSString *apiSchoolDetail;
extern NSString *apiReceiptDetails;
extern NSString *apiCalendarEvent;
extern NSString *apiMenuList;
extern NSString *apiUpdateProfile;
extern NSString *apiActivityList;
extern NSString *apiGetInfirmaryIllnessList;
extern NSString *apiGetInfirmaryVaccinationList;
extern NSString *apiFeedback;
extern NSString *pPaymentConfigure;

//Parameter Names
extern NSString *pEmail;
extern NSString *pOldPassword;
extern NSString *pNewPassword;
extern NSString *pPassword;
extern NSString *pUsername;
extern NSString *pPersonalInfo; // PI = Personal Info
extern NSString *pPIStudentName;
extern NSString *pPIClassName;
extern NSString *pPIFatherName;
extern NSString *pPIMotherName;
extern NSString *pPIAddmissionNumber;
extern NSString *pPISection;
extern NSString *pPIBloodGroup;
extern NSString *pPIHouse;
extern NSString *pPIStudentPicture;
extern NSString *pCorrespondenceInfo; // CI = Correspondence Info
extern NSString *pCIPhoneNumber;
extern NSString *pCIAddress;
extern NSString *pTransportInfo; //TI = Transport Info
extern NSString *pTIPickRoute;
extern NSString *pTIPickupTime ;
extern NSString *pTIDropRoute;
extern NSString *pTIDropTime;
extern NSString *pTITransportIncharge;
extern NSString *pTIBusNumber;
extern NSString *pClassTeacherInfo; //CT = Class Teacher
extern NSString *pClassTeacherName;
extern NSString *pCTEmployeeCode;
extern NSString *pNotificationCount;
extern NSString *pQualification ;
extern NSString *pDashboardList ;
extern NSString *pDashboardItem ;
extern NSString *pDashboardValue;
extern NSString *pRollNo;
extern NSString *pParentMobileNumber ;
extern NSString *pStandard ;
extern NSString *pDOB;
extern NSString *pTeacherImage ;
extern NSString *pNotificationID;
extern NSString *pNotificationTitle;
extern NSString *pNotificationDescription;
extern NSString *pNotificationCreatedOn;
extern NSString *pNotificationList;
extern NSString *pReport;
extern NSString *pReportName;
extern NSString *pReportCaption;
extern NSString *pReportIsPublished;
extern NSString *pDisciplineID;
extern NSString *pActionDate;
extern NSString *pActionPoints;
extern NSString *pReason ;
extern NSString *pTeacherName;
extern NSString *pCardType;
extern NSString *pDisciplineList;
extern NSString *pAttendanceBarChart;
extern NSString *pMonthNumber;
extern NSString *pMonthName;
extern NSString *pAttendancePercentage;
extern NSString *pFeeList;
extern NSString *pSubjectList;
extern NSString *pSubjectID;
extern NSString *pSubjectName;
extern NSString *pAssignmentList;
extern NSString *pAssignmentID;
extern NSString *pAssignmentName;
extern NSString *pAssignmentPicture;
extern NSString *pAssignmentDate;
extern NSString *pAssignmentDetail;
extern NSString *pCircularList;
extern NSString *pCircularID;
extern NSString *pCircularNO;
extern NSString *pCircularPhoto;
extern NSString *pSubject;
extern NSString *pNoOfCirculars;
extern NSString *pCircularDate;
extern NSString *pMonth;
extern NSString *pDriverName;
extern NSString *pRouteNo;
extern NSString *pContactNo;
extern NSString *pPickupLocation;
extern NSString *pDropLocation;
extern NSString *pSwitchSiblingList;
extern NSString *pPhotoGalleryList;
extern NSString *pGalleryID;
extern NSString *pDescription;
extern NSString *pPhotoList;
extern NSString *pPhotoID;
extern NSString *pPhoto;
extern NSString *pSchoolURL;
extern NSString *pSchoolPhoto;
extern NSString *pSchoolNickName;
extern NSString *pStudentProfile;
extern NSString *pStudentEmailID;
extern NSString *pSourceLat;
extern NSString *pSourceLong;
extern NSString *pDestinationLat;
extern NSString *pDestinationLong;
extern NSString *pStudentPhoto;
extern NSString *pPaymentDate;
extern NSString *pInstallmentNumber;
extern NSString *pType;
extern NSString *pPaidAmount;
extern NSString *pPayableAmount;
extern NSString *pReceiptID;
extern NSString *pCalendarEventList;
extern NSString *pCalendarEventName;
extern NSString *pCalendarDetails;
extern NSString *pCalendarFromDate;
extern NSString *pCalendarToDate;
extern NSString *pStatus;
extern NSString *pDayKey;
extern NSString *pCalendarDate;
extern NSString *pInstallmentID;
extern NSString *pReceiptNo;
extern NSString *pFeesID;
extern NSString *pEnrollmentNo;
extern NSString *pStudentName;
extern NSString *pFatherName;
extern NSString *pClassName;
extern NSString *pSectionName;
extern NSString *pFeeList;
extern NSString *pFeeDetailList;
extern NSString *pFeeType;
extern NSString *pPaidFee;
extern NSString *pMop;
extern NSString *pMenuList;
extern NSString *pMenuName;
extern NSString *pReportURL;
extern NSString *pFileContent;
extern NSString *pFileName;
extern NSString *pFileType;
extern NSString *pFileDescription;
extern NSString *pPresentCode;
extern NSString *pAbsentCount;
extern NSString *pLeaveCount;
extern NSString *pFirstHalfCount;
extern NSString *pSecondHalfCount;
extern NSString *pAttendanceMonth;
extern NSString *pSessionStartDate;
extern NSString *pSessionEndDate;
extern NSString *pActivityID;
extern NSString *pPosition;
extern NSString *pEventDate;
extern NSString *pEventLevel;
extern NSString *pActivityName;
extern NSString *pActivityDescription;
extern NSString *pIllnessID;
extern NSString *pIllnessDate;
extern NSString *pIllnessHeading;
extern NSString *pIllnessDetails;
extern NSString *pRemarks;
extern NSString *pMedicine;
extern NSString *pAmountofDose;
extern NSString *pActivityList;
extern NSString *pIllnessList;
extern NSString *pVaccinationList;
extern NSString *pVaccinationID;
extern NSString *pVaccinationDate;
extern NSString *pVaccinationHeading;
extern NSString *pVaccinationDetails;


//Common Parameters
extern NSString *cpAction;
extern NSString *cpResponseMessage ;
extern NSString *cpResponseCode;
extern NSString *cpSchoolID;
extern NSString *cpStudentID;
extern NSString *cpSessionID;
extern NSString *cpUserID;
extern NSString *cpEnrollmentNumber;
extern NSString *cpPagination;
extern NSString *cpPageNumber;
extern NSString *cpPageSize;
extern NSString *cpTotalRecords;
extern NSString *cpMaxPages;
extern NSString *cpDeviceType;
extern NSString *cpDeviceToken;
extern NSString *cpPDFLink;
extern NSString *cpType;
extern NSString *cpDate;
extern NSString *cpYear;

// Library

extern NSString *pLibraryhistory;
extern NSString *apiGetBookHistory;
extern NSString *apiIssueBook;
extern NSString *pLibraryIssue;
extern NSString *apiSearchBook;
extern NSString *pLibrarySearch;
extern NSString *cpSearchText;
extern NSString *pBookId;
extern NSString *pLibrary;
extern NSString *apiLibraryGetDetail;
extern NSString *pCommunicationHeader;
extern NSString *apiMessageHeader;
extern NSString *pCreatedForUserId;
extern NSString *pAppMessageId;
extern NSString *apiGetMessageDetail;
extern NSString *pMessageDetail;
extern NSString *apiReservation;
extern NSString *apiToDeleteMessage;
extern NSString *pTimeTable;
extern NSString *apiTimeTable;
extern NSString *apiForStaticData;
extern NSString *pStaticdata;
extern NSString *apiNotificationSet;
extern NSString *cpisNotification;
extern NSString *pMessageTypeId;
extern NSString *pContent;
extern NSString *apiSaveMsgDetail;
extern NSString *apiContactUs;
extern NSString *pActivityDate;
extern NSString *pAccessionNo;
extern NSString *pIssueReturnId;
extern NSString *apiForGetBusLocation;
extern NSString *apiPaymentDetails;
extern NSString *pIsRead;
extern NSString *pNotiType;
extern NSString *apiPaymentSuccess;

extern NSString *cpBookName;
extern NSString *cpKeyword;
extern NSString *cpAuthorName;

extern NSString *apiNotificationCount;
extern NSString *cpTransactionURL;
extern NSString *cpRsaURL;
extern NSString *cpJsonURL;
extern NSString *cpWorkingKeyURL;


extern NSString *pBusLat;
extern NSString *pBusLong;

// Feedback Parameter
extern NSString *cpNeme;
extern NSString *cpMessage;
extern NSString *apiForMessageSubject;
extern NSString *apiForToGetType;


// Payment
extern NSString *cpAccessCode;
extern NSString *cpMerchantID;
extern NSString *cpOrderID;
extern NSString *cpAmount;
extern NSString *cpCurrency;
extern NSString *cpBillingName;
extern NSString *cpBillingAddress;
extern NSString *cpBillingCity;
extern NSString *cpBillingState;
extern NSString *cpBillingCountry;
extern NSString *cpBillingZipCode;
extern NSString *cpMobileNumber;
extern NSString *cpEmailID;

;

@interface ISConstants : NSObject

@end
