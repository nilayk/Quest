//
//  Global.m
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "Global.h"

@implementation Global

@synthesize buildingCoords;
@synthesize unvisitedBuildings;
@synthesize visitedBuildings;

@synthesize currentBuilding;

@synthesize userLatitude;
@synthesize userLongitude;

@synthesize didZoomToUserLocation;
@synthesize isProximityFlagEnabled;

@synthesize totalDistance;
@synthesize nextDestinationDistance;

@synthesize lastPositionLatitude;
@synthesize lastPositionLongitude;

@synthesize startGameFlag;

@synthesize score;

@synthesize hour;
@synthesize minute;
@synthesize second;

static Global *g;

+ (Global *)getInstance {
	
	@synchronized ([Global class]) {
		if (g == nil) {
			g = [[Global alloc] init];
		}
	}
	
	return g;
}

@end

