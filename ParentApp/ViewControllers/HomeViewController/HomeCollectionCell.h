//
//  HomeCollectionCell.h
//  ParentApp
//
//  Created by Abhishek Agarwal on 03/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *categoryImageView;

@property (strong, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryInformationInNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberSpecificationLabel;

@end
