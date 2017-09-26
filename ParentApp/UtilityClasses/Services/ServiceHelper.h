//
//  OPServiceHelper.h
//  Openia
//
//  Created by Sunil Verma on 25/03/16.
//  Copyright ©2016 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//Session
typedef enum {
    ISProgressNotShown = 0,
    ISProgressShown = 1
    
} ISProgressHud;

typedef void(^OPRequestComplitopnBlock)(id result,  NSError  *error);


@interface ServiceHelper : NSObject {
    ISProgressHud progressHud;
}

+(id)sharedServiceHelper;

-(void)cancelGetRequestSession;
-(void)cancelPostRequestSession;

// use to call get apis
-(void)GetAPICallWithParameter:(NSMutableDictionary *)parameterDict apiName:(NSString *)apiName andController:(UIViewController *)controller cache:(BOOL)cached withprogresHud:(ISProgressHud)hud WithComptionBlock:(OPRequestComplitopnBlock)block;

// Use to call post apis
-(void)PostAPICallWithParameter:(NSMutableDictionary *)parameterDict apiName:(NSString *)apiName andController:(UIViewController *)controller cache:(BOOL)cached withprogresHud:(ISProgressHud)hud  WithComptionBlock:(OPRequestComplitopnBlock)block;

@end
