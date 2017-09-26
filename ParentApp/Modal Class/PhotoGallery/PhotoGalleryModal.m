//
//  PhotoGalleryModal.m
//  ParentApp
//
//  Created by Prince Kadian on 19/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "PhotoGalleryModal.h"
#import "ISConstants.h"
#import "NSDictionary+NullChecker.h"

@implementation PhotoGalleryModal

+(PhotoGalleryModal *)parsePhotoGalleryInfo:(NSDictionary*)photosGalleryDictionary {
    
    PhotoGalleryModal *photosInfo = [[PhotoGalleryModal alloc] init];
    photosInfo.photoListArray = [NSMutableArray array];
    
    photosInfo.galleryID = [photosGalleryDictionary objectForKeyNotNull:pGalleryID expectedObj:@""];
    photosInfo.sectionDescription = [photosGalleryDictionary objectForKeyNotNull:pDescription expectedObj:@""];
    
    NSArray *photoDetailArray =  [NSArray arrayWithArray:[photosGalleryDictionary objectForKeyNotNull:pPhotoList expectedObj:[NSArray array]]];

    for (NSDictionary *photoDict in photoDetailArray)
        [photosInfo.photoListArray addObject:[PhotoModal parsePhotoInfo:photoDict]];

    return photosInfo;
}

@end

@implementation PhotoModal

+(PhotoModal *)parsePhotoInfo:(NSDictionary*)photosDictionary {
    
    PhotoModal *photosObj = [[PhotoModal alloc] init];
    
    photosObj.photoID = [photosDictionary objectForKeyNotNull:pPhotoID expectedObj:@""];
    photosObj.photoURL = [photosDictionary objectForKeyNotNull:pPhoto expectedObj:@""];
     photosObj.photoData = [[NSData alloc] initWithBase64EncodedString:photosObj.photoURL options:0];

    return photosObj;
}

@end
