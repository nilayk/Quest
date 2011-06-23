//
//  AnnotationImage.h
//  QuestApp
//
//  Created by Siddharth Gami on 4/8/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleView.h"

@class CircleView;
@interface GameView : UIViewController <UIAccelerometerDelegate, UIAlertViewDelegate> {
	
	IBOutlet UIBarButtonItem *flipButton;
	
	IBOutlet UIButton *option1;
	IBOutlet UIButton *option2;
	IBOutlet UIButton *option3;
	IBOutlet UIButton *option4;
	
	IBOutlet UIButton *nextButton1;
	IBOutlet UIButton *nextButton2;
	
	IBOutlet UIView *cluesView1;
	IBOutlet UIView *cluesView2;
	IBOutlet UIView *cluesView3;
	IBOutlet UIView *endView;
	
	IBOutlet UIView *quizView;
	
	IBOutlet UITextView *textViewClues1;
	IBOutlet UITextView *textViewClues2;
	IBOutlet UITextView *textViewClues3;
	IBOutlet UITextView *myQuestion;
	
	IBOutlet UIImageView *imageViewClues1;
	IBOutlet UIImageView *imageViewClues2;
	IBOutlet UIImageView *imageViewClues3;
	
	IBOutlet UITextView *textViewClues1Heading;
	IBOutlet UITextView *textViewClues2Heading;
	IBOutlet UITextView *textViewClues3Heading;
	IBOutlet UITextView *startNote;
	
	IBOutlet UILabel *nextDestinationDistanceLabelClue1;
	IBOutlet UILabel *nextDestinationDistanceLabelClue2;
	IBOutlet UILabel *nextDestinationDistanceLabelClue3;
	
	CircleView *Circle;
	
	NSMutableArray *listOfItems;
	NSMutableArray *clues;
	NSMutableArray *clueListOfItems;
	NSMutableArray *quizValue;
	NSMutableArray *viewContainer;
	
	NSString *correctSol;
	NSString *type;
	
	int presentView;
	int shakeIndex;
	
	BOOL checkAcceleration;
	BOOL flagUnlockClue2;
	BOOL flagUnlockClue3;
	
	BOOL alertViewOff;
	BOOL flagForExecution;
 	
	float accelX;
	float accelY;
	
	NSTimeInterval lasttime;
	int shakecount;
	float lastX;
	float lastY;
	float biggestshake;
	
}

-(IBAction)flipView:(id)sender;
-(IBAction)quizResults:(UIButton *)button;
-(void)prepareQuizView:(NSMutableArray *)list;
-(void)wrongAnswer:(UIButton *)button;
-(IBAction)gotoPreviousClue:(id)sender;
-(IBAction)gotoNextClue:(UIButton *)button;
-(void)cluesViewController:(NSMutableArray *)list;
-(void)sortClueTypesforClue:(int)number;
-(void)CircleDetected;
- (void)destinationUpdated:(NSNotification *)notification;
- (void)makeQuiz;
- (BOOL) didShake:(UIAcceleration *)acceleration;
- (void)boreTheUser:(id) object;
- (void)waitForAnswer;
- (void)rightAnswer;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *flipButton;
@property (nonatomic, retain) IBOutlet UITextView *myQuestion;
@property (nonatomic, retain) IBOutlet UIButton *option1;
@property (nonatomic, retain) IBOutlet UIButton *option2;
@property (nonatomic, retain) IBOutlet UIButton *option3;
@property (nonatomic, retain) IBOutlet UIButton *option4;

@property (nonatomic, retain) IBOutlet UIButton *nextButton1;
@property (nonatomic, retain) IBOutlet UIButton *nextButton2;

@property (nonatomic, retain) IBOutlet UIView *cluesView1;
@property (nonatomic, retain) IBOutlet UIView *cluesView2;
@property (nonatomic, retain) IBOutlet UIView *cluesView3;

@property (nonatomic, retain) IBOutlet UILabel *nextDestinationDistanceLabelClue1;
@property (nonatomic, retain) IBOutlet UILabel *nextDestinationDistanceLabelClue2;
@property (nonatomic, retain) IBOutlet UILabel *nextDestinationDistanceLabelClue3;

@property (nonatomic, retain) IBOutlet UIView *quizView;
@property (nonatomic, retain) IBOutlet UIView *endView;

@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, retain) NSMutableArray *quizValue;
@property (nonatomic, retain) NSMutableArray *clues;
@property (nonatomic, retain) NSMutableArray *clueListOfItems;
@property (nonatomic, retain) NSMutableArray *viewContainer;
@property (nonatomic, retain) IBOutlet UITextView *textViewClues1;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewClues1;
@property (nonatomic, retain) IBOutlet UITextView *textViewClues1Heading;
@property (nonatomic, retain) IBOutlet UITextView *textViewClues2;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewClues2;
@property (nonatomic, retain) IBOutlet UITextView *textViewClues2Heading;
@property (nonatomic, retain) IBOutlet UITextView *textViewClues3;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewClues3;
@property (nonatomic, retain) IBOutlet UITextView *textViewClues3Heading;
@property (nonatomic, retain) IBOutlet UITextView *startNote;
@property (nonatomic, retain) CircleView *Circle;


@end
