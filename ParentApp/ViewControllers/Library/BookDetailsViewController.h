//
//  BookDetailsViewController.h
//  ParentApp
//
//  Created by Prince Kadian on 17/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LibraryModal;

@protocol reserveProtocol <NSObject>

-(void)callLibraryDetailApi;
@end
@interface BookDetailsViewController : UIViewController

@property(nonatomic,strong) NSString *bookNumber;
@property(nonatomic,strong) LibraryModal *libraryInfo;
@property(nonatomic,assign) BOOL isReserve;
@property(nonatomic,assign) BOOL bookButtonFromLibrary;
@property(nonatomic,strong) id<reserveProtocol> delegate;


@end
