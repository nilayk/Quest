//
//  Clues.m
//  QuestApp
//
//  Created by Siddharth Gami on 4/18/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "Clues.h"


@implementation Clues
@synthesize _cKey,_scode,_dcode,_cTypeOne,_cTypeTwo,_cTypeThree,_cValOne,_cValTwo,_cValThree;

-(id)initWithPkey:(NSString *)pkey 
			scode:(NSString *)scode 
	        dcode:(NSString *)dcode 
		 cTypeOne:(NSString *)cTypeOne 
		 cTypeTwo:(NSString *)cTypeTwo 
	   cTypeThree:(NSString *)cTypeThree 
		  cValOne:(NSString *)cValOne
		  cValTwo:(NSString *)cValTwo 
		cValThree:(NSString *)cValThree{
	self._cKey = pkey;
	self._scode = scode;
	self._dcode = dcode;
	self._cTypeOne = cTypeOne;
	self._cTypeTwo = cTypeTwo;
	self._cTypeThree = cTypeThree;
	self._cValOne = cValOne;
	self._cValTwo = cValTwo;
	self._cValThree = cValThree;
	
	return self;
	
}

@end
