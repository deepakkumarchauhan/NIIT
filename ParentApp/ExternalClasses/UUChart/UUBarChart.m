//
//  UUBarChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBarChart.h"
#import "UUChartLabel.h"
#import "UUBar.h"
#import "Header.h"

@interface UUBarChart ()
{
    UIScrollView *myScrollView;
}
@end

@implementation UUBarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, (frame.size.width-UUYLabelwidth), frame.size.height)];
        
        myScrollView.showsHorizontalScrollIndicator = NO;
        
        
        [self addSubview:myScrollView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;
    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    max = 100;
    if (max < 5) {
        max = 5;
    }
    if (self.showRange) {
        _yValueMin = (int)min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    float level = (_yValueMax-_yValueMin) /10.0;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /10.0;
    
    for (int i=0; i<11; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth, UULabelHeight)];
		label.text = [NSString stringWithFormat:@"%.f",level * i+_yValueMin];
		[self addSubview:label];
    }
	
}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    NSInteger num;
    if (xLabels.count>=8) {
        num = 6;
    }else if (xLabels.count<=4){
        num = 4;
    }else{
        num = xLabels.count;
    }
    
    if (xLabels.count>6) {
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
            _xLabelWidth = myScrollView.frame.size.width/num;
        }
        else
            _xLabelWidth = myScrollView.frame.size.width/(num*2);
    }
    else
        _xLabelWidth = myScrollView.frame.size.width/num;
    
    
    for (int i=0; i<xLabels.count; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake((i * _xLabelWidth - 5.0 ), self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = xLabels[i];
        [myScrollView addSubview:label];
    }
    
//    float max = (([xLabels count]-1)*_xLabelWidth + chartMargin)+_xLabelWidth;
//    if (myScrollView.frame.size.width < max-10) {
//        
//        myScrollView.contentSize = CGSizeMake(max, self.frame.size.height);
//        
//        NSDateFormatter *currentDTFormatter = [[NSDateFormatter alloc] init];
//        [currentDTFormatter setDateFormat:@"MMM"];
//        NSString *monthString = [currentDTFormatter stringFromDate:[NSDate date]];
//        
//        NSInteger index = [xLabels indexOfObject:monthString];
//        
//        if (myScrollView.contentSize.width - index*_xLabelWidth > [UIScreen mainScreen].bounds.size.width - _xLabelWidth + 5) {
//            [myScrollView setContentOffset:CGPointMake(index*_xLabelWidth, 0)];
//        }else
//            [myScrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];
//    }
    
    float max = (([xLabels count]-1)*_xLabelWidth + chartMargin)+_xLabelWidth;
    if (myScrollView.frame.size.width < max-10) {
        myScrollView.contentSize = CGSizeMake(max, self.frame.size.height);
    }
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}
-(void)strokeChart
{
    NSArray *rainbowColors = [[NSArray alloc] initWithObjects:
                     [UIColor colorWithRed:1 green:0 blue:0 alpha:1],
                     [UIColor colorWithRed:1 green:0.25 blue:0 alpha:1],
                     [UIColor colorWithRed:1 green:0.5 blue:0 alpha:1],
                     [UIColor colorWithRed:1 green:0.75 blue:0 alpha:1],
                     [UIColor colorWithRed:1 green:1 blue:0 alpha:1],
                     [UIColor colorWithRed:0.75 green:1 blue:0 alpha:1],
                     [UIColor colorWithRed:0.5 green:1 blue:0 alpha:1],
                     [UIColor colorWithRed:0.25 green:1 blue:0 alpha:1],
                     [UIColor colorWithRed:0 green:1 blue:0 alpha:1],
                     [UIColor colorWithRed:0 green:1 blue:0.25 alpha:1],
                     [UIColor colorWithRed:0 green:1 blue:0.5 alpha:1],
                     [UIColor colorWithRed:0 green:1 blue:0.75 alpha:1],
                     [UIColor colorWithRed:0 green:1 blue:1 alpha:1],
                     [UIColor colorWithRed:0 green:0.75 blue:1 alpha:1],
                     [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1],
                     [UIColor colorWithRed:0 green:0.25 blue:1 alpha:1],
                     [UIColor colorWithRed:0 green:0 blue:1 alpha:1],
                     [UIColor colorWithRed:0.25 green:0 blue:1 alpha:1],
                     [UIColor colorWithRed:0.5 green:0 blue:1 alpha:1],
                     [UIColor colorWithRed:0.75 green:0 blue:1 alpha:1],
                     [UIColor colorWithRed:1 green:0 blue:1 alpha:1],
                     [UIColor colorWithRed:1 green:0 blue:0.75 alpha:1],
                     [UIColor colorWithRed:1 green:0 blue:0.5 alpha:1],
                     [UIColor colorWithRed:1 green:0 blue:0.25 alpha:1],nil];
    
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
	
    for (int i=0; i<_yValues.count; i++) {
        if (i==2)
            return;
        NSArray *childAry = _yValues[i];
        for (int j=0; j<childAry.count; j++) {
            NSString *valueString = childAry[j];
            float value = [valueString floatValue];
            float grade = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
            
            //Manage Bar Width (_yValues.count==1?0.6:0.45)
            UUBar * bar = [[UUBar alloc] initWithFrame:CGRectMake((j+(_yValues.count==1?0.1:0.05))*_xLabelWidth+i*_xLabelWidth * 0.47, UULabelHeight, _xLabelWidth * (_yValues.count==1?0.6:0.45), chartCavanHeight)];
            bar.barColor = [rainbowColors objectAtIndex:j];
           // bar.barColor = [UIColor greenColor];
            bar.grade = grade;
            
            UIButton *barButton = [[UIButton alloc] initWithFrame:bar.frame];
            [barButton setBackgroundColor:[UIColor clearColor]];
            [bar setTintColor:[UIColor clearColor]];
            barButton.tag = j+1;
            [barButton addTarget:self action:@selector(barButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [myScrollView addSubview:bar];
            [myScrollView addSubview:barButton];
        }
    }
}

-(void)barButtonAction:(UIButton *)sender
{
    [self.delegate barChartClickedAtIndex:sender.tag];
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
