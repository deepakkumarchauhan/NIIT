//
//  PAAddSchoolViewController.h
//  ParentApp
//
//  Created by Prince Kadian on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetSelectedIndexForNickName <NSObject>

-(void)getBackSelectedIndex:(NSInteger)sleectedIndex;

@end

@interface PAAddSchoolViewController : UIViewController

@property (assign,nonatomic) BOOL isFromLogin;

@property(strong,nonatomic)  id delegate;

@end
