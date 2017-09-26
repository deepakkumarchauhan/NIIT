//
//  AppDelegate.h
//  ParentApp
//
//  Created by Yogesh Pal on 31/08/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ITRAirSideMenu;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;

@property (assign, nonatomic) BOOL isReachable;

@property (strong, nonatomic) NSString *schoolURL;

@property ITRAirSideMenu *itrAirSideMenu;
-(ITRAirSideMenu *)setMenu;

@end

