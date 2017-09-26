//
//  PARootDetailsViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 03/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//
#import "PARouteDetailsViewController.h"
#import "CoreLocation/CoreLocation.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TransportModal.h"
#import "PinView.h"
#import "PAUtility.h"

@interface PARouteDetailsViewController ()<UITableViewDelegate>
{
    __weak IBOutlet GMSMapView *viewMap;
    NSDictionary *transportInfo;
    NSTimer *getBusLocationTimer;
    NSString *oldLat;
    NSString *oldLong;
    NSString *busAddress;

    NSMutableArray *arrMapList;
  //  NSArray *array;
    int index;
    int ind;


}


@property (weak, nonatomic) IBOutlet UITableView *transportTableView;


@property(strong,nonatomic) TransportModal *transportObj;

@property (assign, nonatomic)  CLLocationCoordinate2D source;
@property (assign, nonatomic)  CLLocationCoordinate2D destination;
@property (assign, nonatomic)  CLLocationCoordinate2D currentLocation;
@property (assign, nonatomic)  CLLocationCoordinate2D oldLocation;

@end

@implementation PARouteDetailsViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self customInitialization];
    
    // array = [[NSArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"28.419154",@"lat",@"77.039803",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.419777",@"lat",@"77.039589",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.421042",@"lat",@"77.039229",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.424448",@"lat",@"77.038205",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.428165",@"lat",@"77.036810",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.428316",@"lat",@"77.035801",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.428448",@"lat",@"77.035726",@"", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.428845",@"lat",@"77.036971",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.429165",@"lat",@"77.036799",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.428986",@"lat",@"77.037014",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.428892",@"lat",@"77.037529",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.428675",@"lat",@"77.037250",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.428401",@"lat",@"77.035211",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.428024",@"lat",@"77.034836",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.427203",@"lat",@"77.032186",@"lng", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"28.427250",@"lat",@"77.033184",@"lng", nil], nil];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [getBusLocationTimer invalidate];

}


#pragma MARK: Helper Methods

-(void)customInitialization{
    
    //Set Navigation Properties
    self.title = @"Route Details";
    
    if (self.fromNotification) {
        self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    }
    else
        self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");
    
    self.transportObj = [[TransportModal alloc]init];
    arrMapList = [NSMutableArray array];

    //Register TableView Cell
    [self.transportTableView registerNib:[UINib nibWithNibName:@"TransportTableViewCell" bundle:nil] forCellReuseIdentifier:@"TransportTableViewCell"];
    self.transportTableView.alwaysBounceVertical = NO;
    self.transportTableView.estimatedRowHeight = 35;
    self.transportTableView.rowHeight = UITableViewAutomaticDimension;
    
    //Allocations
    transportInfo = [NSDictionary new];
    
    getBusLocationTimer = [NSTimer scheduledTimerWithTimeInterval:8.0
                                                           target:self
                                                         selector:@selector(getBusLatLong)
                                                         userInfo:nil
                                                          repeats:YES];
    
    //Call Transport Api
    [self callAPIForRouteDetails];
}

-(void)addRouteOnGoogleMapWith:(CLLocation *)source andDestination:(CLLocation *)desti
{
    
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", source.coordinate.latitude, source.coordinate.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", desti.coordinate.latitude, desti.coordinate.longitude];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false&avoid=highways&mode=driving",saddr,daddr]];
    
    __block NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    __block NSURLResponse *response = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: &error];
        NSError *e;
        
        if (responseData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&e];
            
            NSArray *routeArr = [dict objectForKeyNotNull:@"routes" expectedObj:[NSArray class]];
            if (routeArr.count>0) {
                GMSPath *path =[GMSPath pathFromEncodedPath:dict[@"routes"][0][@"overview_polyline"][@"points"]];
                NSDictionary *arr=dict[@"routes"][0][@"legs"];
                
                [self drawLine:path withDataDict:arr];
            }
        }
    });
}

-(void)drawLine:(GMSPath *)Path withDataDict:(NSDictionary *)dict
{
    
    NSMutableArray *loc = [[NSMutableArray alloc]init];
    NSLog(@"%@",loc);
    
    loc = [[dict valueForKey:@"start_location"]valueForKey:@"lat"];
    _source.latitude = [[loc firstObject] doubleValue];
    
    loc = [[dict valueForKey:@"start_location"]valueForKey:@"lng"];
    _source.longitude = [[loc firstObject] doubleValue];
    
    loc = [[dict valueForKey:@"end_location"]valueForKey:@"lat"];
    _destination.latitude = [[loc firstObject] doubleValue];
    
    loc = [[dict valueForKey:@"end_location"]valueForKey:@"lng"];
    _destination.longitude = [[loc firstObject] doubleValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        float getAngle = [self angleFromCoordinate:_oldLocation toCoordinate:_currentLocation];
//        
//        GMSMarker *marker = arrMapList[0];
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:2.0];
//        marker.position = CLLocationCoordinate2DMake(_currentLocation.latitude, _currentLocation.longitude);
//        marker.icon = [UIImage imageNamed:@"busIcon"];
//        marker.rotation = getAngle * (180.0 / M_PI);
//        
//        CLLocation *tempBusAddress = [[CLLocation alloc] initWithLatitude:_currentLocation.latitude longitude:_currentLocation.longitude];
//
//        [self getAddressFromLatLon:tempBusAddress];
//        marker.title = busAddress;
//        
//        [CATransaction commit];
//        oldLat = [NSString stringWithFormat:@"%f",_oldLocation.latitude];
//        oldLong = [NSString stringWithFormat:@"%f",_oldLocation.longitude];
//        index++;
        
        GMSMarker *marker2 = [GMSMarker markerWithPosition:_destination];
        
        marker2.title= self.transportObj.pickUpLocation;
        marker2.appearAnimation = kGMSMarkerAnimationPop;
        marker2.icon = [UIImage imageNamed:@"student"];
        marker2.map = viewMap;
        
    });
}



-(void)addRouteToDestinationOnGoogleMapWith:(CLLocation *)source andDestination:(CLLocation *)desti
{
    
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", source.coordinate.latitude, source.coordinate.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", desti.coordinate.latitude, desti.coordinate.longitude];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false&avoid=highways&mode=driving",saddr,daddr]];
    
    __block NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    __block NSURLResponse *response = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: &error];
        NSError *e;
        
        if (responseData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&e];
            
            NSArray *routeArr = [dict objectForKeyNotNull:@"routes" expectedObj:[NSArray class]];
            if (routeArr.count>0) {
                GMSPath *path =[GMSPath pathFromEncodedPath:dict[@"routes"][0][@"overview_polyline"][@"points"]];
                NSDictionary *arr=dict[@"routes"][0][@"legs"];
                
                [self drawLineToDestination:path withDataDict:arr];
            }
        }
    });
}

-(void)drawLineToDestination:(GMSPath *)Path withDataDict:(NSDictionary *)dict
{
    
    NSMutableArray *loc = [[NSMutableArray alloc]init];
    NSLog(@"%@",loc);
    
    loc = [[dict valueForKey:@"start_location"]valueForKey:@"lat"];
    _source.latitude = [[loc firstObject] doubleValue];
    
    loc = [[dict valueForKey:@"start_location"]valueForKey:@"lng"];
    _source.longitude = [[loc firstObject] doubleValue];
    
    loc = [[dict valueForKey:@"end_location"]valueForKey:@"lat"];
    _destination.latitude = [[loc firstObject] doubleValue];
    
    loc = [[dict valueForKey:@"end_location"]valueForKey:@"lng"];
    _destination.longitude = [[loc firstObject] doubleValue];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        GMSMarker *marker2 = [GMSMarker markerWithPosition:_source];
        NSArray *startAddress = [dict valueForKey:@"start_address"];

        marker2.title= [startAddress firstObject];
        marker2.appearAnimation = kGMSMarkerAnimationPop;
        marker2.icon = [UIImage imageNamed:@"student"];
        marker2.map = viewMap;
        
        
        GMSMarker *marker = [GMSMarker markerWithPosition:_destination];
        NSArray *destinationAddress = [dict valueForKey:@"end_address"];
        
        marker.title= [destinationAddress firstObject];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.icon = [UIImage imageNamed:@"schoolIcon"];
        marker.map = viewMap;
        
        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:Path];
        singleLine.strokeWidth = 5;
        singleLine.strokeColor = AppBlueColor;
        singleLine.map = viewMap;
    });
}



#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransportTableViewCell *cell = (TransportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TransportTableViewCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"Transport Incharge Name";
            cell.detailLabel.text = [transportInfo objectForKeyNotNull:pDriverName expectedObj:@""];
            break;
            
        case 1:
            cell.titleLabel.text = @"Route Number";
            cell.detailLabel.text = [transportInfo objectForKeyNotNull:pRouteNo expectedObj:@""];
            break;
            
        case 2:
            cell.titleLabel.text = @"Phone No.";
            cell.detailLabel.text = [transportInfo objectForKeyNotNull:pContactNo expectedObj:@""];
            break;
            
        case 3:
            cell.titleLabel.text = @"Student Address";
            cell.detailLabel.text = [transportInfo objectForKeyNotNull:pPickupLocation expectedObj:@""];
            break;
            
        case 4:
            cell.titleLabel.text = @"School Address";
            cell.detailLabel.text = [transportInfo objectForKeyNotNull:pDropLocation expectedObj:@""];
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

#pragma MARk: UIButton Actions

-(void)leftBarButtonAction:(UIButton*)sender{
    
    if (self.fromNotification) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
        [itrSideMenu presentLeftMenuViewController];
    }
}

#pragma mark - Selector Method

- (void)getBusLatLong {
    
    [self callAPIForGetBusLocation];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForRouteDetails {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiGetRouteDetails andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            transportInfo = result;
            [self.transportTableView reloadData];
            
            self.transportObj.sourceLat =[transportInfo objectForKeyNotNull:pSourceLat expectedObj:@""];
            self.transportObj.sourceLong =[transportInfo objectForKeyNotNull:pSourceLong expectedObj:@""];
            self.transportObj.destinationLat =[transportInfo objectForKeyNotNull:pDestinationLat expectedObj:@""];
            self.transportObj.destinationLong =[transportInfo objectForKeyNotNull:pDestinationLong expectedObj:@""];
            
            self.transportObj.busLat =[transportInfo objectForKeyNotNull:pBusLat expectedObj:@""];
            self.transportObj.busLong =[transportInfo objectForKeyNotNull:pBusLong expectedObj:@""];
            self.transportObj.pickUpLocation =[transportInfo objectForKeyNotNull:pPickupLocation expectedObj:@""];
            
            oldLat  = self.transportObj.busLat;
            oldLong = self.transportObj.busLong;

            CLLocation *source = [[CLLocation alloc] initWithLatitude:self.transportObj.busLat.doubleValue longitude:self.transportObj.busLong.doubleValue];
            CLLocation *desti = [[CLLocation alloc] initWithLatitude:self.transportObj.sourceLat.doubleValue longitude:self.transportObj.sourceLong.doubleValue];
            CLLocation *desti2 = [[CLLocation alloc] initWithLatitude:self.transportObj.destinationLat.doubleValue longitude:self.transportObj.destinationLong.doubleValue];
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:oldLat.doubleValue  longitude:oldLong.doubleValue zoom:15];
            [viewMap setCamera:camera];
            [viewMap setMapType:kGMSTypeNormal];
            [viewMap setMyLocationEnabled:YES];

            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(self.source.latitude, self.source.longitude);
            marker.map = viewMap;
            [arrMapList addObject:marker];
            
          //  [self addRouteOnGoogleMapWith:source andDestination:desti];
            [self addRouteToDestinationOnGoogleMapWith:desti andDestination:desti2];
            
            [self updateDriverBusPosition];
            
        } else
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:20.0 andController:self];
    }];
}


-(void)callAPIForGetBusLocation {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiForGetBusLocation andController:self cache:NO withprogresHud:ISProgressNotShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
//            NSDictionary *dict;
//            if (index < array.count) {
//                dict = [array objectAtIndex:index];
//            }
//            self.transportObj.busLat =[dict objectForKeyNotNull:@"lat" expectedObj:@""];
//            self.transportObj.busLong =[dict objectForKeyNotNull:@"lng" expectedObj:@""];

            self.transportObj.busLat =[result objectForKeyNotNull:pBusLat expectedObj:@""];
            self.transportObj.busLong =[result objectForKeyNotNull:pBusLong expectedObj:@""];
//
          //  CLLocation *source = [[CLLocation alloc] initWithLatitude:self.transportObj.busLat.doubleValue longitude:self.transportObj.busLong.doubleValue];
        //    CLLocation *desti = [[CLLocation alloc] initWithLatitude:self.transportObj.sourceLat.doubleValue longitude:self.transportObj.sourceLong.doubleValue];
            
          //  CLLocation *desti2 = [[CLLocation alloc] initWithLatitude:self.transportObj.destinationLat.doubleValue longitude:self.transportObj.destinationLong.doubleValue];
            
           // [self addRouteOnGoogleMapWith:source andDestination:desti2];
           // [self addRouteToDestinationOnGoogleMapWith:desti andDestination:desti2];
            [self updateDriverBusPosition];
            
        } else
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:20.0 andController:self];
    }];
}


- (float)angleFromCoordinate:(CLLocationCoordinate2D)first
                toCoordinate:(CLLocationCoordinate2D)second {
    
    float deltaLongitude = second.longitude - first.longitude;
    float deltaLatitude = second.latitude - first.latitude;
    float angle = (M_PI * .5f) - atan(deltaLatitude / deltaLongitude);
    
    if (deltaLongitude > 0)      return angle;
    else if (deltaLongitude < 0) return angle + M_PI;
    else if (deltaLatitude < 0)  return M_PI;
    
    return 0.0f;
}


- (void) getAddressFromLatLon:(CLLocation *)bestLocation
{
    NSLog(@"%f %f", bestLocation.coordinate.latitude, bestLocation.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:bestLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];         
         
         busAddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];

         
         
         //NSString *strTemp = [NSString stringWithFormat:@"%@ %@,%@",placemark.subLocality,placemark.subAdministrativeArea,placemark.administrativeArea];
       //  busAddress = strTemp;
         
     }];
    
}


- (void)updateDriverBusPosition {
    
    _currentLocation.latitude = [self.transportObj.busLat doubleValue];
    _currentLocation.longitude = [self.transportObj.busLong doubleValue]
    ;
    _oldLocation.latitude = [oldLat doubleValue];
    _oldLocation.longitude = [oldLong doubleValue]
    ;
    
    float getAngle = [self angleFromCoordinate:_oldLocation toCoordinate:_currentLocation];
    
    GMSMarker *marker = arrMapList[0];
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    marker.position = CLLocationCoordinate2DMake(_currentLocation.latitude, _currentLocation.longitude);
    marker.icon = [UIImage imageNamed:@"yellowBus"];
    marker.rotation = getAngle * (180.0 / M_PI);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_currentLocation.latitude
                                                            longitude:_currentLocation.longitude zoom: 16];
    [viewMap animateToCameraPosition: camera];

    CLLocation *tempBusAddress = [[CLLocation alloc] initWithLatitude:_currentLocation.latitude longitude:_currentLocation.longitude];
    
    [self getAddressFromLatLon:tempBusAddress];
    marker.title = busAddress;
    
    [CATransaction commit];
    oldLat = [NSString stringWithFormat:@"%f",_oldLocation.latitude];
    oldLong = [NSString stringWithFormat:@"%f",_oldLocation.longitude];
    index++;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
