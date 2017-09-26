//
//  Macro.h
//  ParentApp
//
//  Created by Prince Kadian on 18/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#ifndef Header_h
#define Header_h

/****************** App Releated Common Used ****************************/

#define APPDELEGATE       (AppDelegate*)[[UIApplication sharedApplication] delegate]
#define WINWIDTH         [[UIScreen mainScreen]bounds].size.width
#define WINHEIGHT        [[UIScreen mainScreen]bounds].size.height
#define TRIMSPACE(str)   [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define NSUSERDEFAULT     [NSUserDefaults standardUserDefaults]

//Orientation
#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)
#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)

#define SCREEN_MAX_LENGTH (MAX(WINWIDTH, WINHEIGHT))

//Device Check
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD_MINI_AIR (IS_IPAD && SCREEN_MAX_LENGTH == 1024.0 )
#define IS_IPAD_PRO (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0 )
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//Use DEGREES_TO_RADIANS and CDTextFiled
#define DEGREES_TO_RADIANS(degrees)  (M_PI * (degrees) / 180.0)
#define CDTextFiled(tag)        (UITextField*)[self.view viewWithTag:tag]

/****************** App Common Used Fonts and Size ************************/
#define COMMON_APP_FONT @"Relay-Regular"
#define FONT_SIZE 13.0f
#define AppFont(X) [UIFont fontWithName:@"Relay-Regular" size:X]

/****************** App Common Used Colors ****************************/
//#define AppRedColor [UIColor colorWithRed:(184.0/255.0) green:(48.0/255.0) blue:(52/255.0) alpha:1.0];
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define LDEL_COLOR [UIColor colorWithRed:85.0/255.0 green:107.0/255.0 blue:204.0/255.0 alpha:1.0f]

#define ErrorDisplayTime 3

/****************** Google API Key ****************************/
#define MapKey @"AIzaSyAvt4NDCT-SC6mMZ95dbuD-udNB__JMYFM"

/****************** Validation Alerts ****************************/
static NSString *BLANK_NAME          =      @"Please enter name.";
static NSString *BLANK_EMAIL         =      @"Please enter email.";
static NSString *VALID_EMAIL         =      @"Please enter a valid email.";
static NSString *BLANK_MESSAGE       =      @"Please enter message.";
static NSString *BLANK_PASSWORD      =      @"Please enter password.";
static NSString *VALID_PASSWORD      =      @"Password must be atleast 8 characters.";

static NSString *VALID_PASSWORD_CONSICUTIVE   =      @"Please enter valid password.";

static NSString *VALID_NEWPASSWORD_CONSICUTIVE   =      @"Please enter valid new password.";
//static NSString *VALID_NEWPASSWORD_CONSICUTIVE   =      @"Password should have 1 alphabet and 1 numeric character and should not have more than 2 identical consecutive characters.";


static NSString *VALID_CONPASSWORD_CONSICUTIVE   =      @"Please enter valid confirm password.";

//static NSString *VALID_PASSWORD_FIRSTCHAR     =      @"First character of the password must be alphabet.";

//static NSString *VALID_NEWPASSWORD_FIRSTCHAR     =      @"First character of the new password must be alphabet.";

//static NSString *VALID_PASSWORD_LASTCHAR      =      @"Last character of the password must be alphabet.";

static NSString *VALID_PASSWORD_BEGINANDEND          =      @"Password should begin and end with an alphabet.";

static NSString *VALID_NEWPASSWORD_BEGINANDEND          =      @"New password should begin and end with an alphabet.";
static NSString *VALID_CONFIRMPASSWORD_BEGINANDEND      =      @"Confirm password should begin and end with an alphabet.";




//static NSString *VALID_CONPASSWORD_FIRSTCHAR     =      @"First character of the confirm password must be alphabet.";

//static NSString *VALID_CONPASSWORD_LASTCHAR      =      @"Last character of the confirm password must be alphabet.";

//static NSString *VALID_NEWPASSWORD_LASTCHAR      =      @"Last character of the new password must be alphabet.";



static NSString *VALID_PASSWORD_WTH_USERNAME  = @"Password and User id(User name) can not be same.";

static NSString *VALID_NEWPASSWORD_WTH_USERNAME  = @"New password and User id(User name) can not be same.";



static NSString *BLANK_USERNAME      =      @"Please enter username.";
static NSString *VALID_USERNAME      =      @"Please enter a valid username.";
static NSString *BLANK_NICKNAME      =      @"Please enter nickname.";
static NSString *BLANK_URL           =      @"Please enter URL.";
static NSString *VALID_URL           =      @"Please enter correct URL.";
static NSString *BLANK_PHONE         =      @"Please enter phone number.";
static NSString *VALID_PHONE         =      @"Please enter a valid phone number.";
static NSString *BLANK_ADDRESS       =      @"Please enter address.";
static NSString *BLANK_OLD_PASSWORD  =      @"Please enter old password.";
static NSString *BLANK_NEW_PASSWORD  =      @"Please enter new password.";
static NSString *BLANK_CONFIRM_PASSWORD  =      @"Please enter confirm password.";
static NSString *VALID_OLD_PASSWORD  =      @"Old password must be atleast 8 characters.";
static NSString *MATCH_PASSWORD      =      @"Passwords don't match.";
static NSString *VALID_NEW_PASSWORD  =      @"New password must be atleast 8 characters.";
static NSString *CONFIRMATION_NEW_PASSWORD  =  @"Confirm password must be atleast 8 characters.";

static NSString *MessageWhenNoData   =      @"No data available.";
static NSString *BLANK_BOOKID        =      @"Please enter Book ID.";
static NSString *BLANK_BOOKTITLE     =      @"Please enter book title.";
static NSString *BLANK_AUTHOR_NAME   =      @"Please enter author name.";
static NSString *BLANK_PUBLISHER     =      @"Please enter publisher.";
static NSString *BLANK_DETAILS       =      @"Please enter details.";
static NSString *BLANK_ISSUE_DATE    =      @"Please enter issue date.";
static NSString *BLANK_RETURN_DATE   =      @"Please enter return date.";
static NSString *BLANK_NO_OF_BOOKS   =      @"Please enter No. of Books.";

static NSString *VALID_ALL_PASSWORD  =      @"Password is not valid.(Please check hint)";


static NSString *VALID_PASSWORD_LENGTH  =      @"Password must be atleast 8 characters.";

static NSString *VALID_NEW_ALL_PASSWORD  =      @"New password is not valid.(Please check hint)";


static NSString *PASSWORD_HINT       =      @"Password should be minimum of 8 characters.\nPassword should contain one alphabetic and one numeric character.\nPassword should begin and end with an alphabet.\nPassword should not have more than 2 identical consecutive characters.\nPassword should not contain User id(User name) as part of password.\nPassword should be different from last 4 passwords.";


/****************** TextField Releated ****************************/
#define TextFieldColorAtBeginEditing [UIColor colorWithRed:65.0f/255.0f green:114.0f/255.0f blue:205.0f/255.0f alpha:1];
#define TextFieldColor [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1];
#define NavigationBackgroundColor [UIColor colorWithRed:53.0f/255.0f green:100.0f/255.0f blue:204.0f/255.0f alpha:1];

/****************** Global Notifications Identifiers ****************/
#define kCalendarFrameChangeNotification  @"calendarFrameChangeNotification"
#define NavigationBackgroundColor [UIColor colorWithRed:53.0f/255.0f green:100.0f/255.0f blue:204.0f/255.0f alpha:1];



#endif /* Macro_h */
