//
//  AppDelegate.m
//  ParentApp
//
//  Created by Yogesh Pal on 31/08/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "Header.h"

@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    [GMSServices provideAPIKey:MapKey];
    
    //Print store data path
   // NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];

    //Notification
    [self registerForRemoteNotification];
    
    //Adding notification observer for height change
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    //Check Reachability
    [self checkReachability];
    
    //Set Initial Flow
    [self initialViewController];

  /*********************************Font Family**********************************************
     NSArray *fontFamilies = [UIFont familyNames];
     
     for (int i = 0; i < [fontFamilies count]; i++)
     {
     NSString *fontFamily = [fontFamilies objectAtIndex:i];
     NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
     NSLog (@"%@: %@", fontFamily, fontNames);
     } **************************************************************************************************/
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Set Initial View Controller

-(void)initialViewController {

    NSMutableArray *schoolArray = [NSUSERDEFAULT valueForKey:@"schoolInformation"];
    
    self.navController = [[UINavigationController alloc] init];
    
    //Set naviagtion properties
    [[self navController] setNavigationBarHidden:NO animated:YES];
    self.navController.navigationItem.hidesBackButton = YES;
    
    if ([self.navController respondsToSelector:@selector(edgesForExtendedLayout)])
        [self.navController setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self setupDefaultApprience:self.navController];
    
    self.navController.hidesBarsWhenKeyboardAppears = NO;
    
    if ([schoolArray count]) {
        PAFirstAddSchoolViewController *objSplash = [[PAFirstAddSchoolViewController alloc] initWithNibName:@"PAFirstAddSchoolViewController" bundle:nil];
        PALoginViewController *examVCObj = [[PALoginViewController alloc]initWithNibName:@"PALoginViewController" bundle:nil];
        
        if ([[NSUSERDEFAULT valueForKey:@"studentInformation"] count])
            [self.navController setViewControllers:[NSArray arrayWithObjects:objSplash,examVCObj,[APPDELEGATE setMenu], nil]];
        else
            [self.navController setViewControllers:[NSArray arrayWithObjects:objSplash,examVCObj, nil]];
    } else {
        PAFirstAddSchoolViewController *objSplash = [[PAFirstAddSchoolViewController alloc] initWithNibName:@"PAFirstAddSchoolViewController" bundle:nil];
        [self.navController setViewControllers:[NSArray arrayWithObjects:objSplash, nil]];
    }
    
    [self.window setRootViewController:self.navController];
}

#pragma mark - Set Home screen and Menu Screeen in ITRAirSideMenu

-(ITRAirSideMenu *)setMenu {
    
    //sidemenu created with content view controller & menu view controller
    HomeViewController *homeController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];

    PAMenuScreen *menuController = [[PAMenuScreen alloc]initWithNibName:@"PAMenuScreen" bundle:nil];
    _itrAirSideMenu = [[ITRAirSideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:menuController];
    
    //Set naviagtion properties
    [[self navController] setNavigationBarHidden:YES animated:YES];
    [navigationController setNavigationBarHidden:NO animated:YES];
    navigationController.navigationItem.hidesBackButton = YES;
    
    //Set Naviagtion Apperance
    [self setupDefaultApprience:navigationController];

    if ([navigationController respondsToSelector:@selector(edgesForExtendedLayout)])
        [navigationController setEdgesForExtendedLayout:UIRectEdgeNone];
    
    //optional delegate to receive menu view status
    _itrAirSideMenu.delegate = menuController;
    
    //content view shadow properties
    _itrAirSideMenu.contentViewShadowColor = [UIColor blackColor];
    _itrAirSideMenu.contentViewShadowOffset = CGSizeMake(0, 0);
    _itrAirSideMenu.contentViewShadowOpacity = 2.0;
    _itrAirSideMenu.contentViewShadowRadius = 5;
    _itrAirSideMenu.contentViewShadowEnabled = YES;
    
    //content view animation properties
    _itrAirSideMenu.contentViewScaleValue = 1.0f;
    _itrAirSideMenu.contentViewRotatingAngle = 10.0f;
    _itrAirSideMenu.contentViewTranslateX = 50.0f;
    
    //menu view properties
    _itrAirSideMenu.menuViewRotatingAngle = 30.0f;
    _itrAirSideMenu.menuViewTranslateX = 130.0f;
    
    return _itrAirSideMenu;
}

#pragma mark - Set Navigation Apperance

-(void)setupDefaultApprience:(UINavigationController *)navigationController {
    
    //UINavigationBar
    navigationController.navigationBar.barTintColor = AppBlueColor;
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    navigationController.navigationBar.translucent = NO;
}

#pragma mark - HELPER METHOD FOR NOTIFICATION

-(void)registerForRemoteNotification {
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                            UIUserNotificationTypeBadge |
                                                            UIUserNotificationTypeSound);
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        });
    }
}


#pragma mark - Check Reachability

-(void)checkReachability {
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    self.isReachable = [reach isReachable];
    reach.reachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = YES;
        });
    };
    reach.unreachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = NO;
        });
    };
    [reach startNotifier];
}

#pragma mark - Device Token Methods

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
//    [[AlertView sharedManager] presentAlertWithTitle:@"Error" message:token
//                                 andButtonsWithTitle:@[@"ok"] onController:self.window.rootViewController
//                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//                                           
//                                       }];
    
    [NSUSERDEFAULT setValue:token forKey:cpDeviceToken];
    [NSUSERDEFAULT synchronize];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        // do something here...
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
    [NSUSERDEFAULT setValue:@"41649760503060f3bf1b39a53a33bc5b243b2798af7dfab2bf81b26230cbb082" forKey:cpDeviceToken];
    [NSUSERDEFAULT synchronize];
}

#pragma mark - Push Notification Method

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
   // NSLog(@"%@",userInfo);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMessage" object:nil];
}

- (void)orientationChanged:(NSNotification *)notification {
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    [OPRequestTimeOutView reframeViewCenter];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

@end
