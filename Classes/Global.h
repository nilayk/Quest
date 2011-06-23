//
//  Global.h
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Global : NSObject {
	
	NSMutableArray* buildingCoords;
	NSMutableArray* unvisitedBuildings;
	NSMutableArray* visitedBuildings;
	
	NSString* currentBuilding;
	
	NSNumber *userLatitude;
	NSNumber *userLongitude;
	
	NSNumber *didZoomToUserLocation;
	NSNumber *isProximityFlagEnabled;
		
	NSNumber *totalDistance;
	NSNumber *nextDestinationDistance;
	
	NSNumber *lastPositionLatitude;
	NSNumber *lastPositionLongitude;
	
	NSNumber *startGameFlag;
	
	NSString *score;
	
	NSString *hour;
	NSString *minute;
	NSString *second;
}

@property (nonatomic, retain) NSMutableArray *buildingCoords;
@property (nonatomic, retain) NSMutableArray *unvisitedBuildings;
@property (nonatomic, retain) NSMutableArray *visitedBuildings;

@property (nonatomic, retain) NSString *currentBuilding;

@property (nonatomic, retain) NSNumber *userLatitude;
@property (nonatomic, retain) NSNumber *userLongitude;

@property (nonatomic, retain) NSNumber *didZoomToUserLocation;
@property (nonatomic, retain) NSNumber *isProximityFlagEnabled;

@property (nonatomic, retain) NSNumber *totalDistance;
@property (nonatomic, retain) NSNumber *nextDestinationDistance;

@property (nonatomic, retain) NSNumber *lastPositionLatitude;
@property (nonatomic, retain) NSNumber *lastPositionLongitude;

@property (nonatomic, retain) NSNumber *startGameFlag;

@property (nonatomic, retain) NSString *score;

@property (nonatomic, retain) NSString *hour;
@property (nonatomic, retain) NSString *minute;
@property (nonatomic, retain) NSString *second;


+ (Global *)getInstance;

@end
