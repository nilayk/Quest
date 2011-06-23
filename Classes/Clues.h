//
//  Clues.h
//  QuestApp
//
//  Created by Siddharth Gami on 4/18/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Clues : NSObject {
	NSString *_cKey;
	NSString *_scode;
	NSString *_dcode;
	NSString *_cTypeOne;
	NSString *_cTypeTwo;
	NSString *_cTypeThree;
	NSString *_cValOne;
	NSString *_cValTwo;
	NSString *_cValThree;		
}

@property(nonatomic, retain) NSString *_cKey;
@property(nonatomic, retain) NSString *_scode;
@property(nonatomic, retain) NSString *_dcode;
@property(nonatomic, retain) NSString *_cTypeOne;
@property(nonatomic, retain) NSString *_cTypeTwo;
@property(nonatomic, retain) NSString *_cTypeThree;
@property(nonatomic, retain) NSString *_cValOne;
@property(nonatomic, retain) NSString *_cValTwo;
@property(nonatomic, retain) NSString *_cValThree;

-(id)initWithPkey:(NSString *)pkey 
			scode:(NSString *)scode 
	        dcode:(NSString *)dcode 
		 cTypeOne:(NSString *)cTypeOne 
		 cTypeTwo:(NSString *)cTypeTwo 
	   cTypeThree:(NSString *)cTypeThree 
		  cValOne:(NSString *)cValOne
		  cValTwo:(NSString *)cValTwo 
		cValThree:(NSString *)cValThree;


@end
