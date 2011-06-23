//
//  LocationController.m
//  Quest
//
//  Created by Nilay Khandelwal on 4/19/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "LocationController.h"


@implementation LocationController

@synthesize locationManager;
@synthesize delegate;

- (id)init {
	self = [super init];
	
	if (self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.delegate = self; // send location updates to myself
		self.locationManager.distanceFilter = kCLDistanceFilterNone;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	}
	
	return self;
}

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	
	[self.delegate locationUpdate:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	
	[self.delegate locationError:error];
}

 -(void)dealloc {
	 [self.locationManager release];
	 [super dealloc];
}

@end
