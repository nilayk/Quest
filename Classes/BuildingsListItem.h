//
//  BuildingsListItem.h
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BuildingsListItem : NSObject {
	NSString *_pkey;
	NSString *_code;
	NSString *_name;
	NSString *_latitude;
	NSString *_longitude;
	NSString *_bid;
	NSString *_campus;
	NSString *_image;
	NSString *_description;
	NSString *_address;
	NSString *_type;
	NSString *_url;
}

@property (nonatomic,retain) NSString *_pkey;
@property (nonatomic,retain) NSString *_code;
@property (nonatomic,retain) NSString *_name;
@property (nonatomic,retain) NSString *_latitude;
@property (nonatomic,retain) NSString *_longitude;
@property (nonatomic,retain) NSString *_bid;
@property (nonatomic,retain) NSString *_campus;
@property (nonatomic,retain) NSString *_image;
@property (nonatomic,retain) NSString *_description;
@property (nonatomic,retain) NSString *_address;
@property (nonatomic,retain) NSString *_type;
@property (nonatomic,retain) NSString *_url;

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

@end
