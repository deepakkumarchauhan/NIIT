//
//  BookReserveViewController.h
//  ParentApp
//
//  Created by Prince Kadian on 17/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol reserveProtocol <NSObject>
//
//-(void)callLibraryDetailApi;
//@end

@interface BookReserveViewController : UIViewController
//@property (nonatomic,strong)NSString *bookId;
@property(nonatomic,strong) LibraryModal *libraryInfo;

//@property(nonatomic,strong) id<reserveProtocol> delegate;

@end
