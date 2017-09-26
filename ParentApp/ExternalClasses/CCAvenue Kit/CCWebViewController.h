//
//  CCPOViewController.h
//  CCIntegrationKit
//
//  Created by test on 5/12/14.
//  Copyright (c) 2014 Avenues. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaymentStatus <NSObject>

-(void)payementStatus:(NSString *)status;
-(void)payementCancel;

@end

@interface CCWebViewController : UIViewController <UIWebViewDelegate>
    @property (strong, nonatomic) IBOutlet UIWebView *viewWeb;
    @property (strong, nonatomic) NSString *accessCode;
    @property (strong, nonatomic) NSString *merchantId;
    @property (strong, nonatomic) NSString *orderId;
    @property (strong, nonatomic) NSString *amount;
    @property (strong, nonatomic) NSString *currency;
    @property (strong, nonatomic) NSString *redirectUrl;
    @property (strong, nonatomic) NSString *cancelUrl;
    @property (strong, nonatomic) NSString *rsaKeyUrl;
  @property (strong, nonatomic) NSString *initialURL;
@property (strong, nonatomic) NSString *workingKeyURL;

     @property(weak, nonatomic) id delegate;

   @property (strong, nonatomic) NSString *billingName;
   @property (strong, nonatomic) NSString *billingAddress;
   @property (strong, nonatomic) NSString *billingZipCode;
   @property (strong, nonatomic) NSString *billingCity;
   @property (strong, nonatomic) NSString *billingState;
   @property (strong, nonatomic) NSString *country;
  @property (strong, nonatomic) NSString *mobileNumber;
  @property (strong, nonatomic) NSString *email;


@end
