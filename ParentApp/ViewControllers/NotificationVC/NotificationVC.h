//
//  NotificationVC.h
//  ParentApp
//
//  Created by PRIYANKA JAISWAL on 01/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol notificationProtocol <NSObject>

-(void)callDashBoardApi;
@end

@interface NotificationVC : UIViewController
@property (nonatomic,strong) id <notificationProtocol> delegate;

@end
