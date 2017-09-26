//
//  ExaminationCustomAlertView.m
//  ParentApp
//
//  Created by PRIYANKA JAISWAL on 04/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "TimetableCustomAlertView.h"

@implementation TimetableCustomAlertView

-(void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Animation Method

-(void)addSubviewWithBounce:(UIView*)theView {
    theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    theView.alpha = 0;
    [UIView animateWithDuration: 1.0 animations: ^{ theView.alpha = 1.0; }];
    theView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1.0);
    CAKeyframeAnimation *bounceAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.1],
                              [NSNumber numberWithFloat:1.0],
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 1.5;
    
    bounceAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.1],nil];
    bounceAnimation.duration = 0.01;
    
    bounceAnimation.removedOnCompletion = NO;
    [theView.layer addAnimation: bounceAnimation forKey: @"bounce"];
    theView.layer.transform = CATransform3DIdentity;
}

-(void)removeViewWithAnimation :(UIView*)theView{
    theView.alpha = 1.0;
    [UIView animateWithDuration: 0.4 animations: ^{ theView.alpha = 0.0; } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)cancleButtonAction:(UIButton *)sender {
    [self removeFromSuperview];
}


@end
