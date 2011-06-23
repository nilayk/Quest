//
//  MapAnnotation.h
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapAnnotation : NSObject <MKAnnotation> {
	NSUInteger _pinID;
	NSString* _pinName;
	NSString* _pinCode;
	CLLocationCoordinate2D _coordinate;	
}

- (id)initWithID:(NSUInteger)pinID 
			name:(NSString *)name 
			code:(NSString *)code
	  coordinate:(CLLocationCoordinate2D)coordinate;

@end
