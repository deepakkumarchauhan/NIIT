//
//  AHConstants.m
//  AHTO
//
//  Created by Sunil Verma on 12/25/14.
//  Copyright (c) 2014 mobiloitte. All rights reserved.
//

#import "ISConstants.h"

//API Names
NSString *apiChangePassword = @"ChangePassword/Update/";
NSString *apiMyProfile = @"MyProfile/GetDetail/";
NSString *apiUpdateProfile = @"MyProfile/UpdateDetail/";
NSString *apiStudentDetail = @"StudentProfile/GetDetail/";
NSString *apiDashboard = @"Dashboard/GetList/";
NSString *apiNotification = @"Notification/GetList/";
NSString *apiLogout = @"SignIn/Logout/";
NSString *apiExamination = @"Examination/GetExaminationList/";
NSString *apiDiscipline = @"Discipline/GetList/";
NSString *apiAttendanceBar = @"Attendance/GetBarChart/";
NSString *apiAttendanceCalendar = @"Attendance/GetMonthwise/";
NSString *apiFeeList = @"Fee/GetList/";

NSString *apiPaymentSuccess = @"PaymentGateway/SaveData/";

NSString *apiNotificationCount = @"Notification/Count/";


NSString *apiSwitchSibling = @"User/GetSibling/";
NSString *apiSubjectList = @"Assignment/GetSubjectList/";
NSString *apiAssignmentList = @"Assignment/GetList/";
NSString *apiGetRouteDetails = @"Transport/GetDetail/";
NSString *apiGetMainCirculars = @"Circular/GetMainList/";
NSString *apiGetDetailsOfCirculars = @"Circular/GetDetailList/";
NSString *apiStudentPhotoGallery = @"PhotoGallery/GetList/";
NSString *apiSchoolDetail = @"School/GetDetail/";
NSString *apiLogin = @"SignIn/Login/";
NSString *apiReceiptDetails = @"Fee/GetDetail/";

NSString *apiPaymentDetails = @"PaymentGateway/GetData/";



NSString *apiCalendarEvent = @"CalendarEvent/GetList/";
NSString *apiMenuList = @"Menu/GetList/";
NSString *apiActivityList = @"Activity/GetList/";
NSString *apiGetInfirmaryIllnessList = @"Infirmary/GetIllnessList/";
NSString *apiGetInfirmaryVaccinationList = @"Infirmary/GetVaccinationList/";
NSString *apiToDeleteMessage = @"Communication/DeleteMessage/";
NSString *apiForStaticData = @"Content/GetData/";
NSString *apiForMessageSubject = @"Communication/SaveMessageSubject/";


NSString *apiForGetBusLocation  = @"Transport/GetBusLocation/";

NSString *apiForToGetType = @"Communication/GetMessageType/";

NSString *apiGetBookHistory = @"Library/GetHistoryList/";
NSString *apiMessageHeader = @"Communication/GetMessageHeader/";
NSString *apiGetMessageDetail = @"Communication/GetMessageDetail/";
NSString *apiIssueBook = @"Library/GetIssuedList/";
NSString *apiSearchBook = @"Library/GetSearchList/";
NSString *apiFeedback = @"Feedback/Send/";
NSString *apiLibraryGetDetail = @"Library/GetDetail/";
NSString *apiReservation = @"Library/ReserveBook/";
NSString *apiTimeTable = @"TimeTable/TimeTableList/";
NSString *apiNotificationSet = @"Notification/Set/";
NSString *apiSaveMsgDetail = @"Communication/SaveMessageDetail/";
NSString *apiContactUs = @"ContactUs/GetContact/";

//Parameter Names
NSString *pEmail = @"email";
NSString *pOldPassword = @"oldPassword";
NSString *pNewPassword = @"newPassword";
NSString *pPassword = @"password";
NSString *pUsername = @"userName";
 NSString *pPersonalInfo = @"personalInfo"; // PI = Personal Info
 NSString *pPIStudentName = @"studentName";
 NSString *pPIClassName = @"className";
 NSString *pPIFatherName = @"fatherName";
 NSString *pPIMotherName = @"motherName";
 NSString *pPIAddmissionNumber = @"admissionNumber";
 NSString *pPISection = @"section";
 NSString *pPIBloodGroup = @"bloodGroup";
 NSString *pPIHouse = @"house";
 NSString *pPIStudentPicture = @"studentPicture";
 NSString *pCorrespondenceInfo = @"correspondenceInfo"; // CI = Correspondence Info
 NSString *pCIPhoneNumber = @"mobileNo";
 NSString *pCIAddress = @"address";
 NSString *pTransportInfo = @"transportInfo"; //TI = Transport Info
 NSString *pTIPickRoute = @"pickupRoute";
 NSString *pTIPickupTime = @"pickupTime";
 NSString *pTIDropRoute = @"dropRoute";
 NSString *pTIDropTime = @"dropTime";
 NSString *pTITransportIncharge = @"transportIncharge";
 NSString *pTIBusNumber = @"busNo";
 NSString *pClassTeacherInfo = @"classteacherInfo"; //CT = Class Teacher
 NSString *pClassTeacherName = @"classTeacherName";
 NSString *pCTEmployeeCode = @"employeeCode";
NSString *pNotificationCount = @"notificationCount";
NSString *pQualification = @"qualification";
NSString *pDashboardList = @"dashboardList";
NSString *pFeeList = @"feeList";
NSString *pFeeDetailList = @"feeDetailList";
NSString *pDashboardItem = @"dashboardItem";
NSString *pDashboardValue = @"dashboardValue";
NSString *pRollNo = @"rollNumber";
NSString *pParentMobileNumber = @"parentMobileNumber";
NSString *pStandard = @"standard";
NSString *pDOB = @"dateOfBirth";
NSString *pTeacherImage = @"classTeacherPhoto";
NSString *pNotificationID = @"notificationID";
NSString *pNotificationTitle = @"notificationHeader";
NSString *pNotificationDescription = @"notificationDetail";
NSString *pNotificationCreatedOn = @"createdOn";
NSString *pNotificationList = @"notificationList";
NSString *pReport = @"report";
NSString *pReportName = @"reportName";
NSString *pReportCaption = @"reportCaption";
NSString *pReportIsPublished = @"isPublished";
NSString *pReportURL = @"reportURL";
NSString *pDisciplineID = @"disciplineID";
NSString *pActionDate = @"actionDate";
NSString *pActionPoints = @"points";
NSString *pReason = @"reason";
NSString *pTeacherName = @"teacherName";
NSString *pCardType = @"cardtype";
NSString *pDisciplineList = @"disciplineList";
NSString *pAttendanceBarChart = @"attendanceBarChart";
NSString *pMonthNumber = @"month";
NSString *pMonthName = @"monthName";
NSString *pAttendancePercentage = @"attendancePercent";
NSString *pSubjectList = @"subjectList";
NSString *pSubjectID = @"subjectID";
NSString *pSubjectName = @"subjectName";
NSString *pAssignmentList = @"assignmentList";
NSString *pAssignmentID = @"assignmentID";
NSString *pAssignmentName = @"assignmentName";
NSString *pAssignmentPicture = @"assignmentPicture";
NSString *pAssignmentDate = @"assignmentDate";
NSString *pAssignmentDetail = @"assignmentDetail";
NSString *pCircularList = @"circularList";
NSString *pCircularID = @"circularID";
NSString *pCircularNO = @"circularNo";
NSString *pCircularPhoto = @"circularPhoto";
NSString *pSubject = @"subject";
NSString *pNoOfCirculars = @"noOfcirculars";
NSString *pCircularDate = @"circularDate";
NSString *pMonth = @"month";
NSString *pDriverName = @"driverName";
NSString *pRouteNo = @"routeNo";
NSString *pContactNo = @"contactNo";
NSString *pPickupLocation = @"pickupLocation";
NSString *pDropLocation = @"dropLocation";
NSString *pSwitchSiblingList = @"siblingList";
NSString *pPhotoGalleryList = @"photogalleryList";
NSString *pGalleryID = @"galleryID";
NSString *pDescription = @"description";
NSString *pPhotoList = @"photoList";
NSString *pPhotoID = @"photoID";
NSString *pPhoto = @"photo";
NSString *pSchoolURL = @"schoolURL";
NSString *pSchoolPhoto = @"schoolPhoto";
NSString *pSchoolNickName = @"schoolNickName";
NSString *pStudentProfile = @"studentProfile";
NSString *pStudentEmailID = @"emailID";
NSString *pSourceLat = @"pickupLat";
NSString *pSourceLong = @"pickupLong";
NSString *pDestinationLat = @"dropupLat";
NSString *pDestinationLong = @"dropLong";
NSString *pStudentPhoto = @"studentPhoto";
NSString *pPaymentDate = @"Date";
NSString *pInstallmentNumber = @"installment";
NSString *pType = @"type";
NSString *pPaidAmount = @"paidAmount";
NSString *pPayableAmount = @"amount";
NSString *pReceiptID = @"receiptID";
NSString *pCalendarEventList = @"calendarEventList";
NSString *pCalendarEventName = @"eventName";
NSString *pCalendarDetails = @"details";
NSString *pCalendarFromDate = @"fromDate";
NSString *pCalendarToDate = @"toDate";
NSString *pStatus = @"status";
NSString *pDayKey = @"dayKey";
NSString *pCalendarDate = @"calendarDate";
NSString *pInstallmentID = @"installmentID";
NSString *pReceiptNo = @"receiptNo";


NSString *pFeesID = @"feesID";
NSString *pEnrollmentNo = @"enrollmentNo";
NSString *pStudentName = @"studentName";
NSString *pFatherName = @"fatherName";
NSString *pClassName = @"className";
NSString *pSectionName = @"sectionName";
NSString *pFeeType = @"feeType";
NSString *pPaidFee = @"paidFee";

NSString *pPaymentConfigure = @"IsPaymentGatewayConfigured";

NSString *pMop = @"mop";
NSString *pMenuList = @"menuList";
NSString *pMenuName = @"menuName";
NSString *pFileContent = @"fileContent";
NSString *pFileName = @"fileName";
NSString *pFileType = @"fileType";
NSString *pFileDescription = @"fileDescription";
NSString *pPresentCode = @"presentCount";
NSString *pAbsentCount = @"absentCount";
NSString *pLeaveCount = @"leaveCount";
NSString *pFirstHalfCount = @"firsthalfCount";
NSString *pSecondHalfCount = @"secondhalfCount";
NSString *pAttendanceMonth = @"attendanceMonth";
NSString *pSessionStartDate = @"sessionStartDate";
NSString *pSessionEndDate = @"sessionEndDate";
NSString *pActivityList = @"activityList";
NSString *pActivityID = @"activityID";
NSString *pPosition = @"position";
NSString *pEventDate = @"eventDate";
NSString *pEventLevel = @"eventLevel";
NSString *pActivityName = @"activityName";
NSString *pActivityDescription = @"activityDescription";
NSString *pIllnessID = @"illnessID";
NSString *pIllnessDate = @"illnessDate";
NSString *pIllnessHeading = @"illnessHeading";

NSString *pIsRead = @"isRead";
NSString *pNotiType = @"notificationType";


NSString *pBusLat   = @"busLat";
NSString *pBusLong  = @"busLong";


NSString *pIllnessDetails = @"illnessDetails";
NSString *pRemarks = @"remarks";
NSString *pMedicine = @"medicine";
NSString *pAmountofDose = @"amountofDose";
NSString *pIllnessList = @"IllnessList";
NSString *pVaccinationList = @"VaccinationList";
NSString *pVaccinationID = @"vaccinationID";
NSString *pVaccinationDate = @"vaccinationDate";
NSString *pVaccinationHeading = @"vaccinationHeading";
NSString *pVaccinationDetails = @"vaccinationDetails";
NSString *pLibraryhistory = @"libraryHistory";
NSString *pLibraryIssue = @"libraryIssued";
NSString *pLibrarySearch = @"librarySearch";
NSString *pBookId = @"bookID";
NSString *pLibrary = @"library";
NSString *pCommunicationHeader = @"listCommunicationHeaderDetail";
NSString *pCreatedForUserId = @"createdForUserId";
NSString *pAppMessageId = @"appMessageID";
NSString *pMessageDetail = @"listcommunicationMsgDetail";
NSString *pTimeTable = @"listTimeTable";
NSString *pMessageTypeId = @"messageTypeId";
NSString *pActivityDate = @"eventDate";

NSString *pAccessionNo = @"accessionNo";
NSString *pIssueReturnId = @"issueReturnId";


NSString *pStaticdata = @"screenData";
NSString *pContent = @"content";

//Common Parameters
NSString *cpYear = @"year";
NSString *cpAction = @"action";
NSString *cpResponseMessage = @"responseMessage";
NSString *cpResponseCode = @"responseCode";
NSString *cpSchoolID = @"schoolID";
NSString *cpStudentID = @"studentID";
NSString *cpSessionID = @"sessionID";
NSString *cpSearchText = @"searchText";


NSString *cpBookName   = @"bookName";
NSString *cpKeyword    = @"keyword";
NSString *cpAuthorName = @"authorName";


NSString *cpUserID = @"userID";
NSString *cpEnrollmentNumber = @"enrollmentNo";
NSString *cpPageNumber = @"pageNumber";
NSString *cpPageSize = @"pageSize";
NSString *cpTotalRecords = @"totalRecords";
NSString *cpMaxPages = @"maxPages";
NSString *cpPagination = @"pagination";
NSString *cpDeviceType = @"deviceType";
NSString *cpDeviceToken = @"deviceToken";
NSString *cpPDFLink = @"PDFLink";
NSString *cpType = @"type";
NSString *cpDate = @"date";
NSString *cpisNotification = @"isNotification";


//Feedback Parameter
NSString *cpNeme = @"name";
NSString *cpMessage = @"message";


// Payment
NSString *cpAccessCode        = @"accessCode";
NSString *cpMerchantID        = @"merchantID";
NSString *cpOrderID           = @"orderID";
NSString *cpAmount            = @"amount";
NSString *cpCurrency          = @"currency";
NSString *cpBillingName       = @"billingName";
NSString *cpBillingAddress    = @"billingAddress";
NSString *cpBillingCity       = @"billingCity";
NSString *cpBillingState      = @"billingState";
NSString *cpBillingCountry    = @"billingCountry";
NSString *cpBillingZipCode    = @"billingZipCode";
NSString *cpMobileNumber      = @"mobileNumber";
NSString *cpEmailID           = @"emailID";

NSString *cpTransactionURL    = @"transactionURL";
NSString *cpRsaURL            = @"rsaKeyURL";
NSString *cpJsonURL           = @"cancelURL";
NSString *cpWorkingKeyURL    = @"workingKeyURL";




@implementation ISConstants

@end
