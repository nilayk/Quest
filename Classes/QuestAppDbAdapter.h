//
//  QuestAppDbAdapter.h
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>

@interface QuestAppDbAdapter : NSObject {
	NSString* databaseName;
	NSString* databasePath;
}

- (void) checkAndCreateDatabase;
- (NSMutableArray *)fetchAllBuildings;
- (NSMutableArray *)fetchBuildingItemForKey:(int)primarykey;
- (NSMutableArray *)fetchBuildingItemForCode:(NSString *)code;
- (NSMutableArray *)fetchAllDestinationCodes;
- (NSString *)fetchNextDestinationCode:(NSString *)currentBuildingCode;
- (CLLocationCoordinate2D)buildingCoords:(NSString *)buildingCode;
- (NSMutableArray *)getQuizForCode:(NSString *)code;
- (NSMutableArray *)getCluesForCode:(NSString *)code;
- (NSString *)getNameForCode:(NSString *)dest;

@end
