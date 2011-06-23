//
//  MapAnnotation.m
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation

@synthesize coordinate = _coordinate;

- (id)initWithID:(NSUInteger)pinID 
			name:(NSString *)name 
			code:(NSString *)code
	  coordinate:(CLLocationCoordinate2D)coordinate {
	self = [super init];
	
	if (self != nil) {
		_pinID = pinID;
		_pinName = name;
		_pinCode = code;
		_coordinate = coordinate;
	}
	
	return self;
}

- (NSString *)title {
	return _pinName;
}

- (NSString *)subtitle {
	return _pinCode;
}

@end
