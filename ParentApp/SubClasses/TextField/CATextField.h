//
//  BNTextFiled.h
//  BuildByNerds
//
//  Created by Ankit Jaiswal on 26/11/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CATextField : UITextField

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, setter=setPaddingValue:) IBInspectable NSInteger paddingValue;

- (void)setPaddingIcon:(UIImage *)iconImage;
- (void)setPlaceHolderText:(NSString *)text;
- (void)setPlaceHolderTextBlack:(NSString *)text;
- (void)setPlaceHolderTextLightGray:(NSString *)text;

@end
