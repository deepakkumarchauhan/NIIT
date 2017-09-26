//
//  ReceiptViewController.h
//  ParentApp
//
//  Created by Prince Kadian on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PAFeeInfo;

@protocol PaymentSuccess <NSObject>

-(void)payementSuccess;

@end

@interface PAReceiptViewController : UIViewController

@property (strong,nonatomic) PAFeeInfo *feeInfo;
@property (assign,nonatomic) BOOL installmentID;

@property (weak,nonatomic) id<PaymentSuccess> delegate;


@end
