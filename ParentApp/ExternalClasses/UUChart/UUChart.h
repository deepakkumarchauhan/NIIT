//
//  UUChart.h
//	Version 0.1
//  UUChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUChart.h"
#import "UUColor.h"
#import "UULineChart.h"
#import "UUBarChart.h"
//Types of
typedef enum {
	UUChartLineStyle,
	UUChartBarStyle
} UUChartStyle;


@class UUChart;
@protocol UUChartDataSource <NSObject>

@required
//Array abscissa title
- (NSArray *)UUChart_xLableArray:(UUChart *)chart;

//Numerical multiple arrays
- (NSArray *)UUChart_yValueArray:(UUChart *)chart;

@optional
//Array of colors
- (NSArray *)UUChart_ColorArray:(UUChart *)chart;

//Display Value range
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart;

//Bar Chart Click Action
-(void)barChartClickedAtIndex:(NSInteger)index;

#pragma mark Exclusive line graph function
//Label value region
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart;

//Analyzing display horizontal lines
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;

//Analyzing show maximum and minimum
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index;
@end


@interface UUChart : UIView

//Whether to automatically display range
@property (nonatomic, assign) BOOL showRange;

@property (assign) UUChartStyle chartStyle;

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource>)dataSource withStyle:(UUChartStyle)style;

- (void)showInView:(UIView *)view;

-(void)strokeChart;

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
