//
//  KiiViewController.m
//  MapKitSample
//
//  Created by Riza Alaudin Syah on 8/29/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "KiiViewController.h"

@interface KiiViewController ()

@end

@implementation KiiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_map.visibleMapRect = MKMapRectInset(
                                         MKMapRectMake(
                                                       MKMapRectGetMaxX(MKMapRectWorld),
                                                       MKMapRectGetMidY(MKMapRectWorld),
                                                       0, 0
                                                       ),
                                         -1000.0 * 1000.0 * MKMapPointsPerMeterAtLatitude(0),
                                         -1000.0 * 1000.0 * MKMapPointsPerMeterAtLatitude(0)
                                         );
    MKPointAnnotation *a = [[MKPointAnnotation alloc] init];
    a.title = @"Honolulu, HI";
    a.coordinate = CLLocationCoordinate2DMake(19.47695,-155.566406);
    MKPointAnnotation *b = [[MKPointAnnotation alloc] init];
    b.title = @"Sydney, Australia";
    b.coordinate = CLLocationCoordinate2DMake(-26.431228,151.347656);
    [_map showAnnotations:@[ a, b ] animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // Initialize request object
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBar.text;
    request.region = self.map.region;
    // Initialize search object
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    // Run search and display results
    [search startWithCompletionHandler:
     ^(MKLocalSearchResponse *response, NSError *error)
     {
         NSMutableArray *placemarks = [NSMutableArray array];
         for (MKMapItem *item in response.mapItems) {
             [placemarks addObject:item.placemark];
         }
         [self.map removeAnnotations:[self.map annotations]];
         [self.map showAnnotations:placemarks animated:NO];
     }];

}
-(IBAction)getDirection:(id)sender{
    
    MKPointAnnotation *a = [[MKPointAnnotation alloc] init];
    a.title = @"Uniqlo Ginza";
    a.coordinate = CLLocationCoordinate2DMake(35.670205,139.763598);
    MKPointAnnotation *b = [[MKPointAnnotation alloc] init];
    b.title = @"Ropponggi Itchome";
    b.coordinate = CLLocationCoordinate2DMake(35.663405,139.738637);
    [_map showAnnotations:@[ a, b ] animated:NO];
    
    MKPlacemark* placeA=[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(35.670205,139.763598) addressDictionary:nil];
    MKPlacemark* placeB=[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(35.663405,139.738637) addressDictionary:nil];
    
    MKMapItem *uniqlo= [[MKMapItem alloc] initWithPlacemark:placeA];
    MKMapItem *ropponggi= [[MKMapItem alloc] initWithPlacemark:placeB];
    
    CLLocationCoordinate2D ground = a.coordinate;
    CLLocationCoordinate2D eye = a.coordinate;
    MKMapCamera *myCamera = [MKMapCamera cameraLookingAtCenterCoordinate:ground fromEyeCoordinate:eye eyeAltitude:100];
      //                       _map.camera = myCamera;
    
    [self findDirectionsFrom:uniqlo to:ropponggi];
    
}

- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;
    request.requestsAlternateRoutes = YES;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             [self handleError:error];
         } else {
             [self showDirections:response];
         }
     }];
}
-(void) handleError:(NSError*) error{
    
}
- (void)showDirections:(MKDirectionsResponse *)response
{
    self.response = response;
    MKRoute *route = self.response.routes[0];
    [self.map addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
//    for (MKRoute *route in self.response.routes) {
//        [self.map addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
//    }
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay{
    NSLog(@"%s : %@ - line %i ",__func__,NSStringFromSelector(_cmd),__LINE__);
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
        renderer.strokeColor = [UIColor blueColor];
        renderer.lineWidth = 1.0;
        return renderer;
    }
    
    return nil;
}
@end
