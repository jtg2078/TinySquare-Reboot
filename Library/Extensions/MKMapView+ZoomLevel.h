//
//  MKMapView+ZoomLevel.h
//  testNaviWithCommonBG
//
//  Created by jason on 2011/8/3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface MKMapView (ZoomLevel)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;
@end 
