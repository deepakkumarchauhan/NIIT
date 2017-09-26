//
//  ChatViewController.h
//  ParentApp
//
//  Created by Prince Kadian on 19/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol backToCommunicationProtocol <NSObject>

-(void)callHeaderApi;
@end

@interface ChatViewController : UIViewController

@property (nonatomic,strong) CommunicationModalInfo *chatModal;

@property (nonatomic,strong) id <backToCommunicationProtocol> delegate;

@end
