//
//  Timer.m
//  Quest
//
//  Created by Siddharth Gami on 4/23/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "ScoreCenter.h"
#import "QuestAppAppDelegate.h"
#import "Global.h"


@implementation ScoreCenter
@synthesize timerLabel, progressBar, scoreLabel, distanceTraveled, steps;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
//   	[timerLabel setFont:[UIFont fontWithName:@"DBLCDTempBlack" 
//										size:32.0]];
	
	// Add the tab bar controller's view to the window and display.
	UIColor *background = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	self.view.backgroundColor = background;
	
	hour = 0;
	minute = 0;
	sec = 0;
	visitedBuildingsCount = 0;
	unVisitedBuildingsCount = 0;
	Global *global = [Global getInstance];
	//int r = [global.unvisitedBuildings count];
	incrementStep = (1.0/(float)[global.unvisitedBuildings count]);
	
	timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) 
											 target:self 
										   selector:@selector(time) 
										   userInfo:nil 
											repeats:YES];
	
	progressBar = [[PDColoredProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	
	CGRect frame = progressBar.frame;
	frame.origin.x = 47;
	frame.origin.y = 304;
	frame.size.width = 218;
	
	progressBar.frame = frame;
	[progressBar setTintColor: [UIColor brownColor]];
	[self.view addSubview:progressBar];
	
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)time {
	
	Global *global = [Global getInstance];

	scoreLabel.text = global.score;
	
	distanceTraveled.text = [NSString stringWithFormat:@"%.0fm", [global.totalDistance floatValue]];
	
	int stepCounter = [global.totalDistance floatValue]/0.762f;
	steps.text = [NSString stringWithFormat:@"%d", stepCounter];
	
	timerLabel.text = [NSString stringWithFormat:@"%02d : %02d : %02d",hour,minute,sec];
	sec++;
	global.second = [NSString stringWithFormat:@"%d",sec];
	
	//gameProgress.progress = 1;
	if(visitedBuildingsCount != [global.visitedBuildings count])
	{
		//float increment = (float)[global.visitedBuildings count]/((float)[global.visitedBuildings count] + (float)[global.unvisitedBuildings count]);
		progressBar.progress = progressBar.progress + incrementStep;
		visitedBuildingsCount = [global.visitedBuildings count];
		
	}
	
	if(sec == 59)
	{
		sec = 0;
		minute++;
		global.minute = [NSString stringWithFormat:@"%d",minute];
	}
	if(minute == 59)
	{
		minute = 0;
		hour ++;
		global.hour = [NSString stringWithFormat:@"%d",hour];
	}
}

-(IBAction)gotoGameView:(id)sender{
	QuestAppAppDelegate *delegate = (QuestAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:delegate.window cache:YES];
	[delegate.tabBarController.view removeFromSuperview];
	[UIView commitAnimations];
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
    [super dealloc];
}


@end
