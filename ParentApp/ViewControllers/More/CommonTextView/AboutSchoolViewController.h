//
//  AboutSchoolViewController.h
//  ParentApp
//
//  Created by Prince Kadian on 14/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum content
{
    aboutSchool,
    contactUs,
    privacyPolicy,
    support
} ContentName;

@interface AboutSchoolViewController : UIViewController

@property (nonatomic) ContentName contentObj;

@end
