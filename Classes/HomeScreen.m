//
//  HomeScreen.m
//  Quest
//
//  Created by Siddharth Gami on 4/23/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "HomeScreen.h"
#import "PDColoredProgressView.h"
#import "Global.h"
#import "QuestAppAppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation HomeScreen
@synthesize pView, home, splash;
@synthesize rules, rulesText, playButton, rulesButton;
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
	
	NSString *fontName = @"HelveticaNeue";
	
	[playButton.titleLabel setFont:[UIFont fontWithName:fontName size:16]];
	[rulesButton.titleLabel setFont:[UIFont fontWithName:fontName size:16]];
	
	// Add the tab bar controller's view to the window and display.
	UIColor *background = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_background.png"]];
	home.backgroundColor = background;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"txt"];
	if (filePath) {
		NSString *myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
		if (myText) {
			rulesText.text= myText;
		}
	}
	
	playButton.backgroundColor = [UIColor clearColor];
	rulesButton.backgroundColor = [UIColor clearColor];

	// Add the tab bar controller's view to the window and display.
	background = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	rules.backgroundColor = background;
	
	rulesText.backgroundColor = [UIColor clearColor];
	
	[self.view addSubview:home];
	[self.view addSubview:rules];
	pView = [[PDColoredProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	CGRect frame = pView.frame;
	frame.origin.x = 0;
	frame.origin.y =452;
	frame.size.width = 320;
	pView.frame = frame;
	[pView setProgress: 1.0 animated: YES];
	[pView setTintColor: [UIColor brownColor]];
	[self.view addSubview: pView];
	[pView release];
	
	home.hidden = YES;
	rules.hidden = YES;
	
	[self performSelector:@selector(switchView) withObject:nil afterDelay:4.0];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction)gameViewAppears:(UIButton *)button{
	Global *global =  [Global getInstance];
	
	QuestAppAppDelegate *delegate = (QuestAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[UIView beginAnimations:@"flipview" context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp 
						   forView:delegate.window 
							 cache:YES];
	
	[[delegate.homeView view] removeFromSuperview];
	
	[UIView commitAnimations];
	
	global.startGameFlag = [NSNumber numberWithBool:YES];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"StartLocationUpdates" 
														object:nil];

}

- (IBAction)rulesViewAppears:(UIButton *)rulesButton {
	
	CATransition *transition = [CATransition animation];
	transition.duration = 0.5;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	transition.type = kCATransitionPush;
	transition.subtype = kCATransitionFromRight;
	transition.delegate = self;
	[self.view.layer addAnimation:transition forKey:nil];
	
	home.hidden = YES;
	rules.hidden = NO;
}

- (IBAction)backToHomeScreen:(id)backButton {
	
	CATransition *transition = [CATransition animation];
	transition.duration = 0.5;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	transition.type = kCATransitionPush;
	transition.subtype = kCATransitionFromLeft;
	transition.delegate = self;
	[self.view.layer addAnimation:transition forKey:nil];
	
	home.hidden = NO;
	rules.hidden = YES;
}

-(void)switchView{
	pView.hidden = YES;	

	CATransition *transition = [CATransition animation];
	transition.duration = 0.5;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	transition.type = kCATransitionFade;
	transition.subtype = kCATransitionFade;
	transition.delegate = self;
	[self.view.layer addAnimation:transition forKey:nil];
	
	home.hidden = NO;
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
