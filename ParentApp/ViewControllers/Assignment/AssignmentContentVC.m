//
//  AssignmentContentVC.m
//  ParentApp
//
//  Created by Prince Kadian on 08/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "AssignmentContentVC.h"
#import "AssignmentInfoModal.h"
#import "PAExamination.h"
#import "CircularModel.h"
#import "PAUtility.h"

@interface AssignmentContentVC ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *fileContentWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation AssignmentContentVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.indicator startAnimating];
    //Navigation Bar
    
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    self.navigationController.navigationBarHidden = NO;
    
    if (self.assignmentObj) {
        self.title = @"Assignment Details";
        [_fileContentWebView loadData:self.assignmentObj.contentData MIMEType:self.assignmentObj.fileType textEncodingName:@"utf-8" baseURL:[NSURL URLWithString:@"http://"]];
    }else if (self.objCircularModal) {
        self.title = @"Circular Details";
        
        [_fileContentWebView loadData:self.objCircularModal.convertedContentData MIMEType:self.objCircularModal.circularFileType textEncodingName:@"utf-8" baseURL:[NSURL URLWithString:@"http://"]];
    }else {
        self.title = @"Exam Details";
        [_fileContentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.objExamModal.reportURL]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.indicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self.indicator stopAnimating];
}

#pragma MARK: UIButton Actions

-(void)leftBarButtonAction:(UIButton*)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
