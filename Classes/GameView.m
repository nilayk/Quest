//
//  AnnotationImage.m
//  QuestApp
//
//  Created by Siddharth Gami on 4/8/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "GameView.h"
#import "QuestAppAppDelegate.h"
#import "QuestAppDbAdapter.h"
#import "Questions.h"
#import "Clues.h"
#import <QuartzCore/QuartzCore.h>
#import "CircleView.h"
#import "Global.h"
#import "SoundEffect.h"
#import "CustomStatusBar.h"


#define kFilteringFactor 0.7

@implementation GameView
@synthesize flipButton,option1,option2,option3,option4,myQuestion,listOfItems,
quizValue,viewContainer,cluesView1,cluesView2,cluesView3,clues,clueListOfItems,textViewClues1,textViewClues1Heading,imageViewClues1,
textViewClues2,textViewClues2Heading,imageViewClues2,textViewClues3,textViewClues3Heading,imageViewClues3,Circle,quizView, startNote, endView, 
nextButton1, nextButton2, nextDestinationDistanceLabelClue1, nextDestinationDistanceLabelClue2, nextDestinationDistanceLabelClue3;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIColor *background = [UIColor colorWithPatternImage:[UIImage imageNamed:@"start_background.png"]];
	self.view.backgroundColor = background;
	
	background = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	cluesView1.backgroundColor = background;
	cluesView2.backgroundColor = background;
	cluesView3.backgroundColor = background;
	quizView.backgroundColor = background;
	[background release];
	
	// set labels transparent
	
	textViewClues1Heading.backgroundColor = [UIColor clearColor];
	textViewClues2Heading.backgroundColor = [UIColor clearColor];
	textViewClues3Heading.backgroundColor = [UIColor clearColor];
	
//	NSString *fontName = @"HelveticaNeue";
//	
//	startNote.font = [UIFont fontWithName:fontName size:16];
//	
//	myQuestion.font = [UIFont fontWithName:fontName size:18];
//	
//	[option1.titleLabel setFont:[UIFont fontWithName:fontName size:16]];
//	[option2.titleLabel setFont:[UIFont fontWithName:fontName size:16]];
//	[option3.titleLabel setFont:[UIFont fontWithName:fontName size:16]];
//	[option4.titleLabel setFont:[UIFont fontWithName:fontName size:16]];
	
	nextDestinationDistanceLabelClue1.backgroundColor = [UIColor clearColor];
	nextDestinationDistanceLabelClue2.backgroundColor = [UIColor clearColor];
	nextDestinationDistanceLabelClue3.backgroundColor = [UIColor clearColor];
	
	startNote.backgroundColor = [UIColor clearColor];
	
	myQuestion.backgroundColor = [UIColor clearColor];
	textViewClues1.backgroundColor = [UIColor clearColor];
	textViewClues2.backgroundColor = [UIColor clearColor];
	textViewClues3.backgroundColor = [UIColor clearColor];
	
	option1.backgroundColor = [UIColor clearColor];
	option2.backgroundColor = [UIColor clearColor];
	option3.backgroundColor = [UIColor clearColor];
	option4.backgroundColor = [UIColor clearColor];
	
	nextButton1.backgroundColor = [UIColor clearColor];
	nextButton2.backgroundColor = [UIColor clearColor];
	
	// register for destination location changes
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(destinationUpdated:) 
												 name:@"DestinationChanged" 
											   object:nil];
	
	checkAcceleration = NO;
	
	UIAccelerometer *myAccel = [UIAccelerometer sharedAccelerometer];
	myAccel.updateInterval = .01;
	myAccel.delegate = self;
	
	accelX = 0;
	accelY = 0;
	lastX = 0;
	lastY = 0;
	
	//startNote.font = [UIFont fontWithName:@"Helvetica" size:16];
	startNote.text = @"Hello! Start the game from Lyon Center.";
	
	Circle = [[CircleView alloc] initWithFrame:CGRectMake(20, 128, 280, 260)];
	
	[Circle setBackgroundColor:[UIColor clearColor]];
	
	Circle.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 270, 50)];
	[Circle.label setBackgroundColor:[UIColor clearColor]];
	
	Circle.layer.borderColor = [UIColor brownColor].CGColor;
	Circle.layer.borderWidth = 3.0f;
	
	[Circle addSubview:Circle.label];
	
	viewContainer = [[NSMutableArray alloc] init];
	
	[viewContainer addObject:cluesView1];
	[viewContainer addObject:cluesView2];
	[viewContainer addObject:cluesView3];
	
	for(int i = 0; i < [viewContainer count]; i++)
		[self.view addSubview:[viewContainer objectAtIndex:i]];
	
	for(int i=0; i < [viewContainer count]; i++)
	{
		UIView *tempView = [viewContainer objectAtIndex:i];
		tempView.hidden = YES;
	}
	
	[self.view addSubview:quizView];
	quizView.hidden = YES;
	
	[self.view addSubview:endView];
	endView.hidden = YES;
	
	NSLog(@"Inside viewDidLoad");
}

- (void)destinationUpdated:(NSNotification *)notification {
	Global *global = [Global getInstance];
	nextDestinationDistanceLabelClue1.text = [NSString stringWithFormat:@"Next Destination: %.0fm", [global.nextDestinationDistance floatValue]];
	nextDestinationDistanceLabelClue2.text = [NSString stringWithFormat:@"Next Destination: %.0fm", [global.nextDestinationDistance floatValue]];
	nextDestinationDistanceLabelClue3.text = [NSString stringWithFormat:@"Next Destination: %.0fm", [global.nextDestinationDistance floatValue]];
	
	[self makeQuiz];
}

- (void)makeQuiz {
	
	flagUnlockClue2 = NO;
	flagUnlockClue3 = NO;
	
	option1.alpha = 100;
	option1.enabled = YES;
	
	option2.alpha = 100;
	option2.enabled = YES;
	
	option3.alpha = 100;
	option3.enabled = YES;
	
	option4.alpha = 100;
	option4.enabled = YES;
	
	QuestAppDbAdapter *adapter = [[QuestAppDbAdapter alloc] init];
	
	Global *global = [Global getInstance];
	NSLog(@"Fetching quiz for %s", [[global.visitedBuildings lastObject] UTF8String]);
	quizValue = [adapter getQuizForCode:[global.visitedBuildings lastObject]];
	
	listOfItems = [[NSMutableArray alloc] init];
	[listOfItems addObjectsFromArray:quizValue];
	
	[self prepareQuizView:(listOfItems)];
	[adapter release];
	NSLog(@"Inside makeQuiz");
	
}


- (void)prepareQuizView:(NSMutableArray *)list{
	myQuestion.text = [[list objectAtIndex:0] _question];
	[option1 setTitle:[[list objectAtIndex:0] _qopt1] forState:UIControlStateNormal];
	[option2 setTitle:[[list objectAtIndex:0] _qopt2] forState:UIControlStateNormal];
	[option3 setTitle:[[list objectAtIndex:0] _qopt3] forState:UIControlStateNormal];
	[option4 setTitle:[[list objectAtIndex:0] _qopt4] forState:UIControlStateNormal];
	correctSol = [[list objectAtIndex:0] _qsol]; 
	quizView.hidden = NO;
	NSLog(@"Inside prepareQuizView");
	
}


-(void)CircleDetected{
	
	Circle.label.text = @"";
	Circle.hidden = YES;
	[Circle release];
}

- (void)boreTheUser:(id) object {
	// empty boring function
	[object hide];
	[object release];
}

- (void)wrongAnswer:(UIButton *)button{
	
	
	Global *global = [Global getInstance];
	global.score = [NSString stringWithFormat:@"%d", ([global.score intValue] - 5)];
	
	[Sound soundEffect:@"WrongAnswer"];

	CustomStatusBar *_customStatusBar;
	_customStatusBar = [[CustomStatusBar alloc] initWithFrame:CGRectZero];
	[_customStatusBar showWithStatusMessage:@"Wrong answer! You lost 5 aureus!"];
	[self performSelector:@selector(boreTheUser:) 
			   withObject:_customStatusBar 
			   afterDelay:3];
		
	CGAffineTransform leftShift = CGAffineTransformTranslate(CGAffineTransformIdentity, -20.0,0.0);
	CGAffineTransform rightShift = CGAffineTransformTranslate(CGAffineTransformIdentity, +20.0,0.0);
	
	button.transform = leftShift;  // starting point
	
	[UIView beginAnimations:@"wobble" context:button];
	[UIView setAnimationRepeatAutoreverses:YES]; // important
	[UIView setAnimationRepeatCount:15];
	[UIView setAnimationDuration:0.04];
	[UIView setAnimationDelegate:self];
	
	button.transform = rightShift; // end here & auto-reverse
	
	[UIView commitAnimations];
	button.transform = CGAffineTransformIdentity;
	
	button.alpha = 1.0;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	button.alpha = 0.0;
	[UIView commitAnimations];
	button.enabled = NO;
	
	NSLog(@"Inside wrongAnswer");
}

-(void) cluesViewController:(NSMutableArray *)list {
	
	Global *global = [Global getInstance];
	
	if ([global.currentBuilding compare:@"END"] == NSOrderedSame) {
		// reached end of quest
		quizView.hidden = YES;
		endView.hidden = NO;
		return;
	}
	
	presentView = 0;
	
	NSLog(@"Inside cluesViewController");
	NSLog(@"presentView: %d", presentView);
	
	Circle.hidden = YES;
	
	imageViewClues1.hidden = YES;
	textViewClues1Heading.hidden = YES;
	textViewClues1.hidden = YES;
	
	imageViewClues2.hidden = YES;
	textViewClues2Heading.hidden = YES;
	textViewClues2.hidden = YES;
	
	imageViewClues3.hidden = YES;
	textViewClues3Heading.hidden = YES;
	textViewClues3.hidden = YES;
	
	checkAcceleration = NO;
	shakeIndex = -1;
	
	QuestAppDbAdapter *adapter = [[QuestAppDbAdapter alloc] init];
	NSString *source = global.currentBuilding;
	NSLog(@"Preparing clues for %s", [source UTF8String]);
	clues = [adapter getCluesForCode:source];
	clueListOfItems = [[NSMutableArray alloc] init];
	[clueListOfItems addObjectsFromArray:clues];
	
	type = [[clueListOfItems objectAtIndex:0] _cTypeOne];
	[self sortClueTypesforClue:(1)];
	
	type = [[clueListOfItems objectAtIndex:0] _cTypeTwo];
	[self sortClueTypesforClue:(2)];
	
	
	type = [[clueListOfItems objectAtIndex:0] _cTypeThree];
	[self sortClueTypesforClue:(3)];
	
	if((presentView ) == shakeIndex)
		checkAcceleration = YES;
	
	[[viewContainer objectAtIndex:presentView] setHidden:NO];
	[[viewContainer objectAtIndex:(presentView + 1)] setHidden:YES];
	[[viewContainer objectAtIndex:(presentView + 2)] setHidden:YES];
	
	[adapter release];
}

- (void)sortClueTypesforClue:(int)number{
	
	if(number == 1)
	{
		NSLog(@"Inside sortClueType 1");
		
		if([type isEqualToString:@"Text"])
		{
			textViewClues1.hidden = NO;
			textViewClues1.text = [[clueListOfItems objectAtIndex:0] _cValOne];
		}
		else if([type isEqualToString:@"Image"])
		{	
			imageViewClues1.hidden = NO;
			UIImage *image = [UIImage imageNamed:[[clueListOfItems objectAtIndex:0] _cValOne]];
			[imageViewClues1 setImage:image];
		}
		else if([type isEqualToString:@"TouchGesture"] || [type isEqualToString:@"Accelerometer"])
		{	
			if([type isEqualToString:@"TouchGesture"] )
			{
				[cluesView1 addSubview:Circle];
				textViewClues1Heading.text = [[clueListOfItems objectAtIndex:0] _cValOne];
				textViewClues1Heading.hidden = NO;
				Circle.hidden = NO;
				
			}
			else
			{
				shakeIndex = 0;
				textViewClues1Heading.hidden = NO;
				textViewClues1Heading.text = [[clueListOfItems objectAtIndex:0] _cValOne];
			}
		}
	}
	else if(number == 2)
	{
		NSLog(@"Inside sortClueType 2");
		
		if([type isEqualToString:@"Text"])
		{
			textViewClues2.hidden = NO;
			textViewClues2.text = [[clueListOfItems objectAtIndex:0] _cValTwo];
		}
		else if([type isEqualToString:@"Image"])
		{	
			imageViewClues2.hidden = NO;
			UIImage *image = [UIImage imageNamed:[[clueListOfItems objectAtIndex:0] _cValTwo]];
			[imageViewClues2 setImage:image];
		}
		else if([type isEqualToString:@"TouchGesture"] || [type isEqualToString:@"Accelerometer"])
		{
			if([type isEqualToString:@"TouchGesture"] )
			{
				[cluesView2 addSubview:Circle];
				textViewClues2Heading.text = [[clueListOfItems objectAtIndex:0] _cValTwo];
				textViewClues2Heading.hidden = NO;
				Circle.hidden = NO;
				
			}
			else
			{
				shakeIndex = 1;
				textViewClues2Heading.hidden = NO;
				textViewClues2Heading.text = [[clueListOfItems objectAtIndex:0] _cValTwo];
			}
		}
	}
	else if(number == 3)
	{
		NSLog(@"Inside sortClueType 3");
		
		if([type isEqualToString:@"Text"])
		{
			textViewClues3.hidden = NO;
			textViewClues3.text = [[clueListOfItems objectAtIndex:0] _cValThree];
		}
		else if([type isEqualToString:@"Image"])
		{	
			imageViewClues3.hidden = NO;
			UIImage *image = [UIImage imageNamed:[[clueListOfItems objectAtIndex:0] _cValThree]];
			[imageViewClues3 setImage:image];
		}
		else if([type isEqualToString:@"TouchGesture"] || [type isEqualToString:@"Accelerometer"])
		{
			if([type isEqualToString:@"TouchGesture"] )
			{
				[cluesView3 addSubview:Circle];
				textViewClues3Heading.text = [[clueListOfItems objectAtIndex:0] _cValThree];
				textViewClues3Heading.hidden = NO;
				Circle.hidden = NO;
				
			}
			else
			{
				shakeIndex = 2;
				textViewClues3Heading.hidden = NO;
				textViewClues3Heading.text = [[clueListOfItems objectAtIndex:0] _cValThree];
				
			}
		}
	}
	
}

-(IBAction)gotoPreviousClue:(id)sender{
	
	CATransition *transition = [CATransition animation];
	transition.duration = 0.4;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	transition.type = kCATransitionPush;
	transition.subtype = kCATransitionFromLeft;
	transition.delegate = self;
	
	[self.view.layer addAnimation:transition forKey:nil];
	[[viewContainer objectAtIndex:(presentView - 1)] setHidden:NO];
	[[viewContainer objectAtIndex:presentView] setHidden:YES];
	
	presentView--;
	
	NSLog(@"Inside gotoPreviousClue");
	NSLog(@"presentView: %d", presentView);
}

-(IBAction)gotoNextClue:(UIButton *)button{
	
	NSString *alertTitle = @"Alert";
	NSString *alertMessage = @"You'll lose 20 aureus. Continue?";
	
	if(presentView == 0)
	{
		if(flagUnlockClue2 == NO)
		{
			[Sound soundEffect:@"Alert"];
			
			CustomStatusBar *_customStatusBar;
			_customStatusBar = [[CustomStatusBar alloc] initWithFrame:CGRectZero];
			[_customStatusBar showWithStatusMessage:@"20 aureus deducted!"];
			[self performSelector:@selector(boreTheUser:) 
					   withObject:_customStatusBar 
					   afterDelay:3];
			
			UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:alertTitle 
																   message:alertMessage 
																  delegate:self 
														 cancelButtonTitle:@"Yes" 
														 otherButtonTitles:@"No", nil];
			
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 10, 25, 25)];
			
			NSString *path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] 
															   stringByAppendingPathComponent:@"warning.png"]];
			
			UIImage *bkgImg = [[UIImage alloc] initWithContentsOfFile:path];
			[imageView setImage:bkgImg];
			[bkgImg release];
			[path release];
			
			[successAlert addSubview:imageView];
			[imageView release];
			
			[successAlert show];
			[successAlert release];
		}
		else 
		{
			CATransition *transition = [CATransition animation];
			transition.duration = 0.4;
			transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
			transition.type = kCATransitionPush;
			transition.subtype = kCATransitionFromRight;
			transition.delegate = self;
			if((presentView + 1) == shakeIndex)
				checkAcceleration = YES;

			[self.view.layer addAnimation:transition forKey:nil];
			[[viewContainer objectAtIndex:(presentView + 1)] setHidden:NO];
			[[viewContainer objectAtIndex:presentView] setHidden:YES];

			presentView++;
		}
	}
	
	else if(presentView == 1)
	{
		if(flagUnlockClue3 == NO)
		{
			[Sound soundEffect:@"Alert"];
			
			CustomStatusBar *_customStatusBar;
			_customStatusBar = [[CustomStatusBar alloc] initWithFrame:CGRectZero];
			[_customStatusBar showWithStatusMessage:@"20 aureus deducted!"];
			[self performSelector:@selector(boreTheUser:) 
					   withObject:_customStatusBar 
					   afterDelay:3];
			
			UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:alertTitle 
																   message:alertMessage
																  delegate:self 
														 cancelButtonTitle:@"Yes" 
														 otherButtonTitles:@"No", nil];
			
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 10, 20, 20)];
			
			NSString *path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] 
															   stringByAppendingPathComponent:@"warning.png"]];
			
			UIImage *bkgImg = [[UIImage alloc] initWithContentsOfFile:path];
			[imageView setImage:bkgImg];
			[bkgImg release];
			[path release];
			
			[successAlert addSubview:imageView];
			[imageView release];
			
			[successAlert show];
			[successAlert release];
		}
		else
		{
			CATransition *transition = [CATransition animation];
			transition.duration = 0.4;
			transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
			transition.type = kCATransitionPush;
			transition.subtype = kCATransitionFromRight;
			transition.delegate = self;
			if((presentView + 1) == shakeIndex)
				checkAcceleration = YES;

			[self.view.layer addAnimation:transition forKey:nil];
			[[viewContainer objectAtIndex:(presentView + 1)] setHidden:NO];
			[[viewContainer objectAtIndex:presentView] setHidden:YES];
			
			presentView++;
		}		
	}
}

-(void)waitForAnswer{
	if (alertViewOff) {
		if(flagForExecution)
		{
			CATransition *transition = [CATransition animation];
			transition.duration = 0.4;
			transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
			transition.type = kCATransitionPush;
			transition.subtype = kCATransitionFromRight;
			transition.delegate = self;
			if((presentView + 1) == shakeIndex)
				checkAcceleration = YES;
			//	[[[viewContainer objectAtIndex:presentView] layer] addAnimation:transition forKey:nil];
			[self.view.layer addAnimation:transition forKey:nil];
			[[viewContainer objectAtIndex:(presentView + 1)] setHidden:NO];
			[[viewContainer objectAtIndex:presentView] setHidden:YES];
			
			presentView++;
			
			NSLog(@"Inside gotoNextClue");
			NSLog(@"presentView: %d", presentView);
			alertViewOff = 0;
		}
		else
		{
			alertViewOff = 0;
			//return;
		}
	}
}

- (void) rightAnswer {
	
	CustomStatusBar *_customStatusBar;
	_customStatusBar = [[CustomStatusBar alloc] initWithFrame:CGRectZero];
	[_customStatusBar showWithStatusMessage:@"Correct! 20 aureus added!"];
	[self performSelector:@selector(boreTheUser:) 
			   withObject:_customStatusBar 
			   afterDelay:3];
	
	Global *global = [Global getInstance];
	global.score = [NSString stringWithFormat:@"%d",([global.score intValue] + 25)];
	CATransition *transition = [CATransition animation];
	transition.duration = 0.4;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	transition.type = kCATransitionFade;
	transition.subtype = kCATransitionFromLeft;
	transition.delegate = self;
	[self.view.layer addAnimation:transition forKey:nil];
	//cluesView.hidden = NO;
	quizView.hidden = YES;
	[self cluesViewController:(listOfItems)];
}

-(IBAction)quizResults:(UIButton *)button{
	NSLog(@"Inside quizResults");
	int correctOption = [correctSol intValue];
	
	if(button == option1)
	{
		if(correctOption == 1)
		{
			[self rightAnswer];
		}
		else 
			[self wrongAnswer:(option1)];
	}
	
	else if(button == option2)
	{
		if(correctOption == 2)
		{
			[self rightAnswer];
		}
		else 
			[self wrongAnswer:(option2)];
	}
	
	else if(button == option3)
	{
		if(correctOption == 3)
		{
			[self rightAnswer];
		}
		else 
			[self wrongAnswer:(option3)];
	}
	
	else if(button == option4)
	{
		if(correctOption == 4)
		{
			[self rightAnswer];
		}
		else 
			[self wrongAnswer:(option4)];
	}
	
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	alertViewOff = 1;
	if(buttonIndex == 0)
	{
		if(presentView == 0)
		{
			CustomStatusBar *_customStatusBar;
			_customStatusBar = [[CustomStatusBar alloc] initWithFrame:CGRectZero];
			[_customStatusBar showWithStatusMessage:@"Clue unlocked! You lost 20 aureus!"];
			[self performSelector:@selector(boreTheUser:) 
					   withObject:_customStatusBar 
					   afterDelay:3];
			
			Global *global = [Global getInstance];
			global.score = [NSString stringWithFormat:@"%d",([global.score intValue] - 20)];
			flagUnlockClue2 = 1;
		}
		
		if(presentView == 1)
		{
			CustomStatusBar *_customStatusBar;
			_customStatusBar = [[CustomStatusBar alloc] initWithFrame:CGRectZero];
			[_customStatusBar showWithStatusMessage:@"Clue unlocked! You lost 20 aureus!"];
			[self performSelector:@selector(boreTheUser:) 
					   withObject:_customStatusBar 
					   afterDelay:3];
			
			Global *global = [Global getInstance];
			global.score = [NSString stringWithFormat:@"%d",([global.score intValue] - 20)];
			flagUnlockClue3 = 1;
		}
		flagForExecution = 1;
	}
	
	if(buttonIndex == 1)
	{
		if(presentView == 0)
			flagUnlockClue2 = 0;
		
		if(presentView == 1)
			flagUnlockClue3 = 0;
		
		flagForExecution = 0;
	}
	[self waitForAnswer];
}


-(IBAction)flipView:(id)sender{
	QuestAppAppDelegate *delegate = (QuestAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:delegate.window cache:YES];

	[delegate.window addSubview:delegate.tabBarController.view];
	[UIView commitAnimations];
	delegate.tabBarController.selectedIndex = 0;
	NSLog(@"Inside flipView");
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
	if (checkAcceleration == YES) {
		if ([self didShake:(UIAcceleration *)acceleration]) {
			
			QuestAppDbAdapter *adapter = [[QuestAppDbAdapter alloc] init];
			
			Global *global = [Global getInstance];
			
			NSString *dest = [adapter fetchNextDestinationCode:[global.visitedBuildings lastObject]];
			
			NSLog(@"Destination: %s", [dest UTF8String]);
			
			NSString *temp = @"Good. Now proceed to ";
			NSString *name = [adapter getNameForCode:dest];
			NSString *labelText = [temp stringByAppendingString:name];
			
			NSLog(@"%s", [labelText UTF8String]);
			
			[adapter release];
			
			if (presentView == 0) 
			{
				textViewClues1.text = labelText;
				textViewClues1.hidden = NO;
			}
			else if (presentView == 1)
			{
				textViewClues2.text = labelText;
				textViewClues2.hidden = NO;
			} 
			else if (presentView == 2)
			{
				textViewClues3.text = labelText;
				textViewClues3.hidden = NO;
			} 
			
			checkAcceleration = NO;
			shakeIndex = -1;
		}
	}
}

- (BOOL) didShake:(UIAcceleration *)acceleration {
	accelX = 
	((acceleration.x * kFilteringFactor)
	 + (accelX * (1 - kFilteringFactor)));	
	
	float moveX = acceleration.x - accelX;
	
	accelY = 
	((acceleration.x * kFilteringFactor)
	 + (accelY * (1 - kFilteringFactor)));	
	
	float moveY = acceleration.x - accelY;
	
	if (lasttime && acceleration.timestamp > lasttime + .25) {
		
		BOOL result;
		
		if (shakecount >= 3 && biggestshake >= 1.25) {
			result = YES;
		} else {
			result = NO;
		}
		
		lasttime = 0;
		shakecount = 0;
		biggestshake = 0;
		
		return result;
		
	} else {
		if (fabs(moveX) >= fabs(moveY)) {
			if ((fabs(moveX) > .75) && (moveX * lastX <= 0)) {
				
				lasttime = acceleration.timestamp;
				shakecount++;
				lastX = moveX;
				if (fabs(moveX) > biggestshake) biggestshake = fabs(moveX);
			}
		} else {
			if ((fabs(moveY) > .75) && (moveY * lastY <= 0)) {
				
				lasttime = acceleration.timestamp;
				shakecount++;
				lastY = moveY;
				if (fabs(moveY) > biggestshake) biggestshake = fabs(moveY);
			}
		}
    	return NO;
	}
}


@end
