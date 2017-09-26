//
//  OPServiceHelper.m
//  Openia
//
//  Created by Sunil Verma on 25/03/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "Header.h"

//Local URL
//#define BASE_URL @"http://107.161.145.10:86/Api/"
//#define BASE_URL @"http://172.16.16.149/Api"

//#define BASE_URL @"http://172.16.16.149/androidservice/Api/"

#define BASE_URL @"http://172.16.16.149/mobileappservice/Api/"


// staging URL
//#define BASE_URL @"http://107.161.158.17:8084/Api/"

//new dedicated server URL
//#define BASE_URL @"http://107.161.145.10:86/Api/"

//Client URL
//#define BASE_URL @"http://210.212.152.38/androidservice/Api/"

NSString *const NO_INTERNATE_CONNECTION    =   @"The Internet connection appears to be offline.";

@interface ServiceHelper()<NSURLSessionDelegate, NSURLSessionTaskDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *progressHUD;

    NSURLSession *getRequestSession;
    NSURLSession *postRequestSession;
    NSURLSession *downLoadsession;
}

@property (nonatomic, strong)     NSURLConnection *connection;
@property (nonatomic, strong)     NSMutableData		 *downLoadedData;

@end

static ServiceHelper *serviceHelper = nil;

@implementation ServiceHelper

+(id)sharedServiceHelper
{
    if (!serviceHelper) {
        serviceHelper = [[ServiceHelper alloc] init];
    }
    return serviceHelper;
}

-(void)cancelGetRequestSession
{
    [getRequestSession invalidateAndCancel];
}

-(void)cancelPostRequestSession
{
    [postRequestSession invalidateAndCancel];
}

-(NSString *)getAuthHeader
{
    NSData *basicAuthCredentials = [[NSString stringWithFormat:@"%@:%@", @"admin", @"admin"] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthCredentials = [basicAuthCredentials base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];

  return [NSString stringWithFormat:@"Basic %@", base64AuthCredentials];
}

- (void)setProgressHud:(ISProgressHud)hud andController:(UIViewController *)controller {
    
    progressHud = hud;
    switch (progressHud) {
            
        case ISProgressShown:
            
            [MBProgressHUD hideAllHUDsForView:controller.view animated:YES];
            progressHUD = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
            [progressHUD setMinShowTime:1.0];
            [progressHUD setColor:[UIColor clearColor]];
            [progressHUD setRemoveFromSuperViewOnHide:YES];
            [progressHUD setDelegate:self];
            
            break;
        case ISProgressNotShown:
         
            break;
        default:
            break;
    }
}

/// Session
-(void)GetAPICallWithParameter:(NSMutableDictionary *)parameterDict apiName:(NSString *)apiName andController:(UIViewController *)controller cache:(BOOL)cached withprogresHud:(ISProgressHud)hud WithComptionBlock:(OPRequestComplitopnBlock)block
{
    OPRequestComplitopnBlock completionBlock = [block copy];
    
    if(![APPDELEGATE isReachable])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [OPRequestTimeOutView showWithMessage:NO_INTERNATE_CONNECTION forTime:3.0 andController:controller];
        });
        return;
    }
    
    NSMutableString *urlString;
    if ([apiName isEqualToString:apiSchoolDetail] || [apiName isEqualToString:apiLogin]) {
        
        NSArray *componentSeprateByForwardSlash =  [[APPDELEGATE schoolURL] componentsSeparatedByString:@"/"];
        urlString = [NSMutableString stringWithFormat:@"%@//%@/",[componentSeprateByForwardSlash firstObject],([componentSeprateByForwardSlash count] >2)?[componentSeprateByForwardSlash objectAtIndex:2]:@""];
    }else {
        NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
        NSString *schoolURL = [studentDict objectForKeyNotNull:pSchoolURL expectedObj:@""];
        
        NSArray *componentSeprateByForwardSlash =  [schoolURL componentsSeparatedByString:@"/"];
        urlString = [NSMutableString stringWithFormat:@"%@//%@/",[componentSeprateByForwardSlash firstObject],([componentSeprateByForwardSlash count] >2)?[componentSeprateByForwardSlash objectAtIndex:2]:@""];
    }
    
    [urlString appendFormat:@"mobileappservice/Api/%@",apiName];
    
    NSString *userID = [NSString string];
    
    [urlString appendString: [NSString stringWithFormat:@"/userID=%@",userID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //[request setValue:[self getAuthHeader] forHTTPHeaderField:@"Authorization"];

      //NSLog(@"Request URL :%@   Params:  %@",urlString,parameterDict);
    
    if (!getRequestSession) {
        NSURLSessionConfiguration *sessionConfig =  [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfig setTimeoutIntervalForRequest:20.0];
        
        getRequestSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    }
    
    [[getRequestSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
//            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
//            
//            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@" error : %@   Code: %ld  ResponseStr......   %@     ",error,(long)[res statusCode],responseStr);
            
            // success response
            id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
            //NSLog(@"Response:  %@",result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(result,  error);
                [progressHUD hide:YES afterDelay:0.0];
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                progressHUD = nil;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [OPRequestTimeOutView showWithMessage:error.localizedDescription forTime:3.0 andController:controller];
                [progressHUD hide:YES afterDelay:0.0];
                [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
                progressHUD = nil;
            });
        }
    }] resume];
}

-(void)PostAPICallWithParameter:(NSMutableDictionary *)parameterDict apiName:(NSString *)apiName  andController:(UIViewController *)controller cache:(BOOL)cached withprogresHud:(ISProgressHud)hud WithComptionBlock:(OPRequestComplitopnBlock)block
{
    OPRequestComplitopnBlock completionBlock = [block copy];

    if(![APPDELEGATE isReachable])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([apiName isEqualToString:apiLogout])
                [OPRequestTimeOutView showWithMessage:NO_INTERNATE_CONNECTION forTime:3.0 andController:controller.navigationController];
            else
               [OPRequestTimeOutView showWithMessage:NO_INTERNATE_CONNECTION forTime:3.0 andController:controller];
        });
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setProgressHud:hud andController:controller];
    });
    
    NSMutableString *urlString;
    if ([apiName isEqualToString:apiSchoolDetail] || [apiName isEqualToString:apiLogin]) {

      NSArray *componentSeprateByForwardSlash =  [[APPDELEGATE schoolURL] componentsSeparatedByString:@"/"];
        urlString = [NSMutableString stringWithFormat:@"%@//%@/",[componentSeprateByForwardSlash firstObject],([componentSeprateByForwardSlash count] >2)?[componentSeprateByForwardSlash objectAtIndex:2]:@""];
    }else {
        NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
        NSString *schoolURL = [studentDict objectForKeyNotNull:pSchoolURL expectedObj:@""];
        
        NSArray *componentSeprateByForwardSlash =  [schoolURL componentsSeparatedByString:@"/"];
        urlString = [NSMutableString stringWithFormat:@"%@//%@/",[componentSeprateByForwardSlash firstObject],([componentSeprateByForwardSlash count] >2)?[componentSeprateByForwardSlash objectAtIndex:2]:@""];
    }
    
    [urlString appendFormat:@"mobileappservice/Api/%@",apiName];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if ([apiName isEqualToString:apiSchoolDetail] || [apiName isEqualToString:apiLogin]) {
        
        //deviceType : 0 for ios and 1 for android
        [parameterDict setValue:@"0" forKey:cpDeviceType];
        [parameterDict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:cpDeviceToken] forKey:cpDeviceToken];
        
    } else
        {
        NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];

        [parameterDict setValue:[studentDict objectForKeyNotNull:cpSchoolID expectedObj:@""] forKey:cpSchoolID]; //School ID
        [parameterDict setValue:[studentDict objectForKeyNotNull:cpUserID expectedObj:@""] forKey:cpUserID]; //Parent ID
        [parameterDict setValue:[studentDict objectForKeyNotNull:cpStudentID expectedObj:@""] forKey:cpStudentID]; //Student ID
        [parameterDict setValue:[studentDict objectForKeyNotNull:cpSessionID expectedObj:@""] forKey:cpSessionID]; //School Section
        
        [parameterDict setValue:[studentDict objectForKeyNotNull:pSchoolURL expectedObj:@""] forKey:pSchoolURL]; //School URL
        [parameterDict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:cpDeviceToken] forKey:cpDeviceToken];

    }
    
    NSLog(@"getJSONFromDict %@",[self getJSONFromDict:parameterDict]);

    
   [request setValue:[self getAuthHeader] forHTTPHeaderField:@"Authorization"];
    
   NSLog(@"Request URL :%@   Params:  %@",urlString,[[NSString alloc] initWithData:[parameterDict toJSON] encoding:NSUTF8StringEncoding]);
    
    [request setHTTPBody:[parameterDict toJSON]];
    
   if (!postRequestSession) {
        NSURLSessionConfiguration *sessionConfig =  [NSURLSessionConfiguration defaultSessionConfiguration];

        [sessionConfig setTimeoutIntervalForRequest:300.0];
        [sessionConfig  setTimeoutIntervalForResource:120.0];
        postRequestSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
   }
    
    [[postRequestSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        if (!error) {
            // success response
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            
            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@" error : %@   Code: %ld  ResponseStr......   %@     ",error,(long)[res statusCode],responseStr);

            id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(result,  error);
                [progressHUD hide:YES afterDelay:0.0];
                [MBProgressHUD hideAllHUDsForView:controller.view animated:YES];
                progressHUD = nil;
            });

        }else {
            //completionBlock(data, error);

            dispatch_async(dispatch_get_main_queue(), ^{
                [OPRequestTimeOutView showWithMessage:error.localizedDescription forTime:3.0 andController:controller];
                [progressHUD hide:YES afterDelay:0.0];
                [MBProgressHUD hideAllHUDsForView:controller.view animated:YES];
                progressHUD = nil;
            });

        }
    }] resume];
}

#pragma mark NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    //NSLog(@"");
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    //NSLog(@"");
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    //NSLog(@"");
}

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler
{
    //NSLog(@"");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    //NSLog(@"");
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * __nullable bodyStream))completionHandler
{
    //NSLog(@"");
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    //NSLog(@"");
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    //NSLog(@"");
}


-(NSString*)getJSONFromDict:(NSDictionary*)dict{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
