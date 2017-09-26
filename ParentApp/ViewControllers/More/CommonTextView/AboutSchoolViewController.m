//
//  AboutSchoolViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 14/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PAUtility.h"
#import "AboutSchoolViewController.h"

@interface AboutSchoolViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AboutSchoolViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self customInitialization];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customInitialization {
    
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    self.navigationController.navigationBarHidden = NO;
    
    self.logoImageView.hidden = NO;
    self.topImageView.hidden = NO;
    
    //Navigation Bar
    switch (self.contentObj) {
            
        case aboutSchool:
            
            self.title = @"About School";
            self.topConstraint.constant = 259;
            [self callAPIForStaticPage:@"1"];
         
            break;
        case contactUs:
            
            self.title = @"Contact Us";
            self.topConstraint.constant = 259;
          //  [self callAPIForStaticPage:@"2"];

            break;
        case privacyPolicy:
            
            self.title = @"Privacy";
            self.topConstraint.constant = 0;
            self.logoImageView.hidden = YES;
            self.topImageView.hidden = YES;
            [self callAPIForStaticPage:@"2"];

            break;
        case support:
            
            self.title = @"Support";
            self.topConstraint.constant = 0;
            self.logoImageView.hidden = YES;
            self.topImageView.hidden = YES;
            [self callAPIForStaticPage:@"3"];

            break;
        default:
            break;
    }
    
}


#pragma MARK: UIButton Actions

-(void)leftBarButtonAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForStaticPage:(NSString*)type {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setValue:type forKey:@"contentType"];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiForStaticData andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            NSArray *staticTempArray = [result objectForKeyNotNull:pStaticdata expectedObj:[NSArray new]];
            
            for ( NSDictionary *contentDict in staticTempArray) {
                self.textView.text = [contentDict valueForKey:@"contentData"];
                
                NSData* data = [[NSData alloc] initWithBase64EncodedString:[contentDict objectForKeyNotNull:@"schoolPhoto" expectedObj:@""] options:0];
                self.logoImageView.image = [UIImage imageNamed:@"NGURU-01 (1)"];
                
                if (!data.length)
                    [self.topImageView setImage:[UIImage imageNamed:@"placeholder"]];
                else
                    [self.topImageView setImage:[UIImage imageWithData:data]];
            }
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}


@end
