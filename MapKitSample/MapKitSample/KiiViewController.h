//
//  KiiViewController.h
//  MapKitSample
//
//  Created by Riza Alaudin Syah on 8/29/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;
@interface KiiViewController : UIViewController <MKMapViewDelegate,UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet MKMapView* map;
@property (nonatomic,strong) MKDirectionsResponse * response;

-(IBAction)getDirection:(id)sender;
@end
