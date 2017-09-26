//
//  TransportModal.h
//  ParentApp
//
//  Created by Krati Agarwal on 16/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransportModal : NSObject

@property (nonatomic,strong) NSString           *driverName;
@property (nonatomic,strong) NSString           *routeNumber;
@property (nonatomic,strong) NSString           *contactNumber;
@property (nonatomic,strong) NSString           *pickUpLocation;
@property (nonatomic,strong) NSString           *dropLocation;
@property (nonatomic,strong) NSString           *sourceLat;
@property (nonatomic,strong) NSString           *sourceLong;
@property (nonatomic,strong) NSString           *destinationLat;
@property (nonatomic,strong) NSString           *destinationLong;
@property (nonatomic,strong) NSString           *busLat;
@property (nonatomic,strong) NSString           *busLong;

@end
