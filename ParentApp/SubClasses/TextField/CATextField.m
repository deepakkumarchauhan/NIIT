//
//  BNTextFiled.m
//  BuildByNerds
//
//  Created by Ankit Jaiswal on 26/11/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "CATextField.h"
#import "Header.h"

@interface CATextField ()

@property (strong, nonatomic) UIImageView *iconImageView;

@end

@implementation CATextField

-(void) awakeFromNib {
    
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.masksToBounds = YES;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self defaultSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self =  [super initWithCoder:aDecoder];
    if(self){
        
        [self defaultSetup];
    }
    return self;
}
- (void)defaultSetup {
    
    self.textColor = [UIColor blackColor];
    self.font = AppFont(16);
    
    [self setupPlaceHolder];
}


- (void)setupPlaceHolder {
    
    if (self.placeholder.length) {//for avoiding nil placehoder
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSFontAttributeName :AppFont(14),NSForegroundColorAttributeName:[UIColor whiteColor]}];
      //  RGBCOLOR(114, 114, 114, 1)
    }
}

- (void)setPlaceHolderText:(NSString *)text {
    if (text.length) {//for avoiding nil placehoder
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName :AppFont(17),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
}
- (void)setPlaceHolderTextBlack:(NSString *)text {
    if (text.length) {//for avoiding nil placehoder
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName :AppFont(17),NSForegroundColorAttributeName:RGBCOLOR(37, 35, 35, 1)}];
    }
}
- (void)setPlaceHolderTextLightGray:(NSString *)text {
    if (text.length) {//for avoiding nil placehoder
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName :AppFont(17),NSForegroundColorAttributeName:RGBCOLOR(112, 112, 112, 1)}];
    }
}

- (void)addPaddingWithValue:(CGFloat )value {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, value, self.frame.size.height)];
    [self setLeftView:paddingView];
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self addplaceHolderImageInsideView:paddingView];
}


- (void)addplaceHolderImageInsideView:(UIView *)view {
    UIImageView *placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 20, 20)];
    placeHolderImageView.contentMode = UIViewContentModeScaleToFill;
    placeHolderImageView.center = view.center;
    placeHolderImageView.tag = 999;
    self.iconImageView = placeHolderImageView;
    [view addSubview:placeHolderImageView];
    
}
- (void)setPaddingIcon:(UIImage *)iconImage {
    UIImageView *placeHolderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];

    
    UIImageView *placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 20, 50)];
    
    [placeHolderImageView setContentMode:UIViewContentModeScaleAspectFit];
    [placeHolderImageView setImage:iconImage];
    [placeHolderView addSubview:placeHolderImageView];

    [self setLeftView:placeHolderView];
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
}

- (void)setPaddingValue:(NSInteger)value {
    [self addPaddingWithValue:value];
}

@end
