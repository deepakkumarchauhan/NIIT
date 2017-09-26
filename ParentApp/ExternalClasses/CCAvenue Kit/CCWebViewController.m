//
//  CCPOViewController.m
//  CCIntegrationKit
//
//  Created by test on 5/12/14.
//  Copyright (c) 2014 Avenues. All rights reserved.
//

#import "CCWebViewController.h"
#import "CCTool.h"
#import "NSDictionary+NullChecker.h"
#import "ISConstants.h"
#import "ServiceHelper.h"
#import "Macro.h"

#define BILLING_NAME @"billing_name"
#define BILLING_ADDRESS @"billing_address"
#define BILLING_CITY @"billing_city"
#define BILLING_STATE @"billing_state"
#define BILLING_ZIP @"billing_zip"
#define BILLING_COUNTRY @"billing_country"
#define BILLING_TEL @"billing_tel"
#define BILLING_EMAIL @"billing_email"
#define DELIVERY_NAME @"delivery_name"
#define DELIVERY_ADDRESS @"delivery_address"
#define DELIVERY_CITY @"delivery_city"
#define DELIVERY_STATE @"delivery_state"
#define DELIVERY_ZIP @"delivery_zip"
#define DELIVERY_COUNTRY @"delivery_country"
#define DELIVERY_TEL @"delivery_tel"

#define SCHOOL_ID  @"schoolId"
#define SCHOOLURL @"schoolUrl"


@interface CCWebViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation CCWebViewController

@synthesize rsaKeyUrl;@synthesize accessCode;@synthesize merchantId;@synthesize orderId;
@synthesize amount;@synthesize currency;@synthesize redirectUrl;@synthesize cancelUrl;@synthesize initialURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSelectorInBackground:@selector(performRequest) withObject:nil];
}

-(void)performRequest {
    self.viewWeb.delegate = self;
     [self.indicator startAnimating];
    
    //Getting RSA Key
    NSString *rsaKeyDataStr = [NSString stringWithFormat:@"access_code=%@&order_id=%@",accessCode,orderId];
    NSData *requestData = [NSData dataWithBytes: [rsaKeyDataStr UTF8String] length: [rsaKeyDataStr length]];
    NSMutableURLRequest *rsaRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:rsaKeyUrl]];
    [rsaRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [rsaRequest setHTTPMethod: @"POST"];
    [rsaRequest setHTTPBody:requestData];
    
    NSError *err;
    NSURLResponse *response;
    
    NSData *rsaKeyData = [NSURLConnection sendSynchronousRequest: rsaRequest returningResponse: &response error: &err];
    
    if(!err && nil != rsaKeyData) {
        
        NSString *rsaKey = [[NSString alloc] initWithData:rsaKeyData encoding:NSASCIIStringEncoding];
        rsaKey = [rsaKey stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        rsaKey = [self stringByStrippingHTML:rsaKey];
        rsaKey = [NSString stringWithFormat:@"-----BEGIN PUBLIC KEY-----\n%@\n-----END PUBLIC KEY-----\n",rsaKey];
        NSLog(@"%@",rsaKey);
        
        //Encrypting Card Details
        NSString *myRequestString = [NSString stringWithFormat:@"amount=%@&currency=%@",amount,currency];
        CCTool *ccTool = [[CCTool alloc] init];
        NSString *encVal = [ccTool encryptRSA:myRequestString key:TRIMSPACE(rsaKey)];
        encVal = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                       (CFStringRef)encVal,
                                                                                       NULL,
                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                       kCFStringEncodingUTF8 ));
        
        //Preparing for a webview call
        
//        NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];

        NSString *urlAsString = [NSString stringWithFormat:@"%@", self.initialURL];
        NSString *encryptedStr = [NSString stringWithFormat:@"merchant_id=%@&order_id=%@&redirect_url=%@&cancel_url=%@&enc_val=%@&access_code=%@",merchantId,orderId,redirectUrl,cancelUrl,encVal,accessCode];
        
            encryptedStr = [encryptedStr stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",BILLING_NAME,self.billingName]];
            encryptedStr = [encryptedStr stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",BILLING_ADDRESS,self.billingAddress]];
            encryptedStr = [encryptedStr stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",BILLING_CITY,self.billingCity]];
            encryptedStr = [encryptedStr stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",BILLING_STATE,self.billingState]];
            encryptedStr = [encryptedStr stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",BILLING_ZIP,self.billingZipCode]];
            encryptedStr = [encryptedStr stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",BILLING_COUNTRY,self.country]];
            encryptedStr = [encryptedStr stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",BILLING_TEL,self.mobileNumber]];
            encryptedStr = [encryptedStr stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",BILLING_EMAIL,self.email]];
        
        NSData *myRequestData = [NSData dataWithBytes: [encryptedStr UTF8String] length: [encryptedStr length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: urlAsString]];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [request setValue:urlAsString forHTTPHeaderField:@"Referer"];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: myRequestData];
        
       // [self callAPIForWorkingKey];
        [_viewWeb loadRequest:request];

    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"OOPS! Something went wrong. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.delegate payementCancel];
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)callAPIForWorkingKey {
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:[NSMutableDictionary dictionary] apiName:self.workingKeyURL andController:self cache:NO withprogresHud:ISProgressNotShown WithComptionBlock:^(id result, NSError *error) {
        
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicator stopAnimating];
    [self.indicator setHidden:YES];
    
    NSString *string = webView.request.URL.absoluteString;
    
    //Previous response URL /ccavResponseHandler.aspx
    if ([string rangeOfString:@"/crh.aspx"].location != NSNotFound) {
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
        
        NSLog(@"%@",html);
        NSString *transStatus = @"Not Known";
        
        if (([html rangeOfString:@"Aborted"].location != NSNotFound) ||
            ([html rangeOfString:@"Cancel"].location != NSNotFound)) {
            transStatus = @"Transaction Cancelled";
        }else if (([html rangeOfString:@"Success"].location != NSNotFound)) {
            transStatus = @"Transaction Successful";
        }else if (([html rangeOfString:@"Fail"].location != NSNotFound)) {
            transStatus = @"Transaction Failed";
        }
        
        self.viewWeb.delegate = nil;
        [self.delegate payementStatus:transStatus];
      
        [self dismissViewControllerAnimated:NO completion:^{
              self.delegate = nil;
        }];
    }
}

-(NSString *) stringByStrippingHTML:(NSString *)string {
    NSRange r;
    NSString *s = [string copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return TRIMSPACE(s) ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
