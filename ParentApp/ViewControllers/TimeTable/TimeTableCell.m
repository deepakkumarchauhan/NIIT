//
//  TimeTableCell.m
//  ParentApp
//
//  Created by Abhishek Agarwal on 20/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "TimeTableCell.h"
#import "TimeTableCollectionViewCell.h"
#import "TimeTableInfo.h"
#import "PAUtility.h"
#import "TimetableCustomAlertView.h"

@interface TimeTableCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) TimeTableValue *valueObj;

@end

@implementation TimeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.timeTableCollectionView registerNib:[UINib nibWithNibName:@"TimeTableCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"TimeTableCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reloadCellwithData:(NSArray *)array andTimeTable:(TimeTableValue *)timeValue
{
    self.dataSourceArray = array;
    self.valueObj = timeValue;
    
    [self.timeTableCollectionView reloadData];
}

#pragma mark - UICollectionView Datasource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
   return [self.dataSourceArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeTableCollectionViewCell *timeTableCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeTableCollectionViewCell" forIndexPath:indexPath];
    [timeTableCell.timeTableTitleLabel setTextColor:[UIColor blackColor]];
    
    timeTableCell.timeTableTitleLabel.numberOfLines = 5;
    
    if (!self.indexPath) {
        [timeTableCell.timeTableTitleLabel setTextColor:[UIColor whiteColor]];
        [timeTableCell.timeTableTitleLabel setText:[self.dataSourceArray objectAtIndex:indexPath.row]];
        timeTableCell.timeTableTitleLabel.font = AppFont(12);
        
    }else {
        
        [timeTableCell.timeTableTitleLabel setText:[self.dataSourceArray objectAtIndex:indexPath.row]];
    }
    
    return timeTableCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(WINWIDTH/7,60);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.valueObj && indexPath.row) {
        NSArray *nibContents = [[NSBundle mainBundle]loadNibNamed:@"TimetableCustomAlertView" owner:nil options:nil];

        TimetableCustomAlertView *view = (TimetableCustomAlertView *)[nibContents lastObject];

        switch (indexPath.row) {
            case 1: {
                view.label_TeacherName.text = self.valueObj.monPeriodTeacher;
                view.label_SubjectName.text = self.valueObj.monday;
                view.label_Remark.text = self.valueObj.time;
            }
                break;
            case 2: {
                view.label_TeacherName.text = self.valueObj.tuesPeriodTeacher;
                view.label_SubjectName.text = self.valueObj.tuesday;
                view.label_Remark.text = self.valueObj.time;
            }
                break;
            case 3: {
                view.label_TeacherName.text = self.valueObj.wedPeriodTeacher;
                view.label_SubjectName.text = self.valueObj.wednesday;
                view.label_Remark.text = self.valueObj.time;
            }
                break;
            case 4: {
                view.label_TeacherName.text = self.valueObj.thurPeriodTeacher;
                view.label_SubjectName.text = self.valueObj.thursday;
                view.label_Remark.text = self.valueObj.time;
            }
                break;
            case 5: {
                view.label_TeacherName.text = self.valueObj.friPeriodTeacher;
                view.label_SubjectName.text = self.valueObj.friday;
                view.label_Remark.text = self.valueObj.time;
            }
                break;
            case 6: {
                view.label_TeacherName.text = self.valueObj.satPeriodTeacher;
                view.label_SubjectName.text = self.valueObj.sat;
                view.label_Remark.text = self.valueObj.time;
            }
                break;
                
            default:
                break;
        }

        [view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        [[APPDELEGATE window] addSubview: view];
    }
}

@end
