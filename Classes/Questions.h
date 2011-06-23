//
//  Questions.h
//  QuestApp
//
//  Created by Siddharth Gami on 4/17/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Questions : NSObject {
	NSString *_qkey;
	NSString *_qcode;
	NSString *_question;
	NSString *_qopt1;
	NSString *_qopt2;
	NSString *_qopt3;
	NSString *_qopt4;
	NSString *_qsol;
}

-(id)initWithPkey:(NSString *)qkey 
			 code:(NSString *)qcode 
		 question:(NSString *)question 
		  option1:(NSString *)qopt1 
		  option2:(NSString *)qopt2 
		  option3:(NSString *)qopt3
		  option4:(NSString *)qopt4 
		 solution:(NSString *)qsol; 

@property (nonatomic, retain) NSString *_qkey;
@property (nonatomic, retain) NSString *_qcode;
@property (nonatomic, retain) NSString *_question;
@property (nonatomic, retain) NSString *_qopt1;
@property (nonatomic, retain) NSString *_qopt2;
@property (nonatomic, retain) NSString *_qopt3;
@property (nonatomic, retain) NSString *_qopt4;
@property (nonatomic, retain) NSString *_qsol;

@end
