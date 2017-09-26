//
//  ShowDescriptionWebView.m
//  ParentApp
//
//  Created by Abhishek Agarwal on 22/12/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "ShowDescriptionWebView.h"
#import "AssignmentInfoModal.h"
#import <QuartzCore/QuartzCore.h>
#import "CircularModel.h"
#import "Macro.h"

@interface ShowDescriptionWebView ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *descriptionWebView;

@property (strong, nonatomic) IBOutlet UIButton *crossButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation ShowDescriptionWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.indicator startAnimating];

    NSString *escapedString = [self.assignmentDescription.assignmentDetail stringByReplacingOccurrencesOfString:@" style=\"color: rgb(0, 0, 0); font-family: sans-serif; font-size: 13.3333px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: normal; text-align: -webkit-left;\"" withString:@""];

    if (self.assignmentDescription)
        [self.descriptionWebView loadHTMLString:[NSString stringWithFormat:@"<font face='Relay-Regular' size='12'>%@",escapedString] baseURL:nil];
    else
        [self.descriptionWebView loadHTMLString:[NSString stringWithFormat:@"<font face='Relay-Regular' size='12'>%@", self.circularDescriptionObj.circularDescription] baseURL:nil];
   
    self.crossButton.layer.cornerRadius = self.crossButton.frame.size.width/2.0f;
    self.descriptionWebView.delegate = self;
    
    [self dropShadowWithBlackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dropShadowWithBlackColor {
  
    self.descriptionWebView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.descriptionWebView.layer.shadowOpacity = 0.4;
    self.descriptionWebView.layer.shadowRadius = 3;
    self.descriptionWebView.layer.masksToBounds = NO;
    self.descriptionWebView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
}

- (IBAction)crossAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.indicator stopAnimating];
    [self.indicator setHidden:YES];
    
    CGSize fittingSize = [self.descriptionWebView sizeThatFits:CGSizeZero];
    [self.heightConstraint setConstant:(fittingSize.height > 100)?(fittingSize.height > 420)?420:fittingSize.height:100];
}

@end
