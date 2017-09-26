//
//  PhotoGalleryModal.h
//  ParentApp
//
//  Created by Prince Kadian on 19/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoGalleryModal : NSObject

@property(nonatomic,strong) NSString    *galleryID;
@property(nonatomic,strong) NSString    *sectionDescription;

@property(nonatomic,strong) NSMutableArray    *photoListArray;

+(PhotoGalleryModal *)parsePhotoGalleryInfo:(NSDictionary*)photosGalleryDictionary;

@end


@interface PhotoModal : NSObject

@property(nonatomic,strong) NSString    *photoID;
@property(nonatomic,strong) NSString    *photoURL;
@property(nonatomic,strong) NSData    *photoData;

+(PhotoModal *)parsePhotoInfo:(NSDictionary*)photosDictionary;

@end