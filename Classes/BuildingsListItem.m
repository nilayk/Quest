//
//  BuildingsListItem.m
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "BuildingsListItem.h"


@implementation BuildingsListItem
@synthesize _pkey, _code, _name, _latitude, _longitude, _bid;
@synthesize _campus, _image, _description, _address, _type, _url;

-(id)initWithPkey:(NSString *)pkey 
			 code:(NSString *)code 
			 name:(NSString *)name 
		 latitude:(NSString *)latitude 
		longitude:(NSString *)longitude 
			  bid:(NSString *)bid 
		   campus:(NSString *)campus 
			image:(NSString *)image 
	  description:(NSString *)description 
		  address:(NSString *)address 
			 type:(NSString *)type 
			  url:(NSString *)url;
{
	self._pkey = pkey;
	self._name = name;
	self._code = code;
	self._latitude = latitude;
	self._longitude = longitude;
	self._bid = bid;
	self._campus = campus;
	self._image = image;
	self._description =description;
	self._address = address;
	self._type = type;
	self._url = url;
	return self;
}

@end
