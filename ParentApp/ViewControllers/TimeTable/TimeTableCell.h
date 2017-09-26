//
//  TimeTableCell.h
//  ParentApp
//
//  Created by Abhishek Agarwal on 20/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeTableValue;

@protocol HistoryCellDelegate <NSObject>

@optional

-(void)didSelectedIndexPath:(NSIndexPath *)indexPath;

@end

@interface TimeTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *timeButton;

@property (strong, nonatomic) IBOutlet UICollectionView *timeTableCollectionView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<HistoryCellDelegate> delegate;

-(void)reloadCellwithData:(NSArray *)array andTimeTable:(TimeTableValue *)timeValue;

@end
