//
//  Questions.m
//  QuestApp
//
//  Created by Siddharth Gami on 4/17/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "Questions.h"


@implementation Questions
@synthesize _qkey,_qcode,_question,_qopt1,_qopt2,_qopt3,_qopt4,_qsol;

-(id)initWithPkey:(NSString *)qkey 
			 code:(NSString *)qcode 
		 question:(NSString *)question 
		  option1:(NSString *)qopt1 
		  option2:(NSString *)qopt2 
		  option3:(NSString *)qopt3
		  option4:(NSString *)qopt4 
		 solution:(NSString *)qsol {

	self._qkey = qkey;
	self._qcode = qcode;
	self._question = question;
	self._qopt1 = qopt1;
	self._qopt2 = qopt2;
	self._qopt3 = qopt3;
	self._qopt4 = qopt4;
	self._qsol = qsol;
	
	return self;


}

@end
