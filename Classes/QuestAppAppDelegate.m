//
//  QuestAppAppDelegate.m
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "QuestAppAppDelegate.h"
#import "QuestAppDbAdapter.h"
#import "Global.h"
#import "BuildingsListItem.h"
#import "TabNavController.h"
#import "GameView.h"
#import "SoundEffect.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomStatusBar.h"

@implementation QuestAppAppDelegate

@synthesize window;
@synthesize buildingsNavController;
@synthesize tabBarController;
@synthesize viewOverLay;
@synthesize homeView;
@synthesize destReachedView;
@synthesize listOfItems;
@synthesize textView, destinationReachedButton;
@synthesize score,time,myWebView, progressBar, userCoordsLatitude, userCoordsLongitude;

#pragma mark -
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	// Override point for customization after application launch.
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(startUpdatingUserLocation:) 
												 name:@"StartLocationUpdates" 
											   object:nil];
	
	// Check and create database
	QuestAppDbAdapter* adapter = [[QuestAppDbAdapter alloc] init];
	[adapter checkAndCreateDatabase];
	
	Global *global = [Global getInstance];
	
	tabBarController.delegate = self;
	
	global.score = @"100";
	
	global.totalDistance = [NSNumber numberWithFloat:0.0f];
	global.nextDestinationDistance = [NSNumber numberWithFloat:0.0f];
	
	global.lastPositionLatitude = [NSNumber numberWithFloat:0.0f];
	global.lastPositionLongitude = [NSNumber numberWithFloat:0.0f];
	
	global.startGameFlag = [NSNumber numberWithBool:NO];	
	global.unvisitedBuildings = [[NSMutableArray alloc] init];
	global.visitedBuildings = [[NSMutableArray alloc] init];
	
	global.unvisitedBuildings = [adapter fetchAllDestinationCodes];
	global.isProximityFlagEnabled = [NSNumber numberWithBool:NO];
	global.currentBuilding = [global.unvisitedBuildings objectAtIndex:0];
	
	// check if location services are enabled
	if ([CLLocationManager locationServicesEnabled] == NO) {
		UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
																		message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." 
																	   delegate:nil 
															  cancelButtonTitle:@"OK" 
															  otherButtonTitles:nil];
		[servicesDisabledAlert show];
		[servicesDisabledAlert release];
	}
	
	[adapter release];
	
	mapsFlag = NO;
	
    // Add the tab bar controller's view to the window and display.
	UIColor *background = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	destReachedView.backgroundColor = background;
	
	[self.window addSubview:destReachedView];
	
	destReachedView.hidden = YES;

//	UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 48)];
//	float max = 255.0f;
//	float red = (float)(153 / max);
//	float green = (float)(102 / max);
//	float blue = (float)(51 / max);
//	[myView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:1]];
//	[myView setAlpha:0.5];
//	[tabBarController.tabBar insertSubview:myView atIndex:0];
//	[myView release];
	
	[self.window addSubview:tabBarController.view];
	[self.window addSubview:[viewOverLay view]];
	[self.window addSubview:[homeView view]];
	
	[self.window makeKeyAndVisible];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of 
	 temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application 
	 and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application 
	 state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
	 If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
 }
 */

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
 }
 */


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {	
	[tabBarController release];
    [window release];
	[locationController release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)locationUpdate:(CLLocation *)userLocation {
	
	// triggered everytime location is updated
	
	NSLog(@"Location :%@", [userLocation description]);
	
	Global *global = [Global getInstance];
	global.startGameFlag;
	
	if([global.startGameFlag compare:[NSNumber numberWithBool:YES]]== NSOrderedSame)
	{
		
		// update distance traveled by user
		
		if (([global.lastPositionLatitude compare:[NSNumber numberWithDouble:0.0f]] != NSOrderedSame)
			&& ([global.lastPositionLongitude compare:[NSNumber numberWithDouble:0.0f]] != NSOrderedSame)) {
			
			CLLocationCoordinate2D temp;
			temp.latitude = [global.lastPositionLatitude floatValue];
			temp.longitude = [global.lastPositionLongitude floatValue];
			
			CLLocation *lastKnownLocation = [[CLLocation alloc] initWithLatitude:temp.latitude 
																	   longitude:temp.longitude];
			
			float localDistance = [userLocation distanceFromLocation:lastKnownLocation];
			float old = [global.totalDistance floatValue];
			
			global.totalDistance = [NSNumber numberWithFloat:(old + localDistance)];
			NSLog(@"Total Distance: %f", [global.totalDistance floatValue]);
			[lastKnownLocation release];
		}
		
		global.lastPositionLatitude = [NSNumber numberWithDouble:userLocation.coordinate.latitude];
		global.lastPositionLongitude = [NSNumber numberWithDouble:userLocation.coordinate.longitude];
		
		NSLog(@"Current building: %s", [global.currentBuilding UTF8String]);
		
		global.userLatitude = [NSNumber numberWithDouble:userLocation.coordinate.latitude];
		global.userLongitude = [NSNumber numberWithDouble:userLocation.coordinate.longitude];
		
		// create DB adapter object
		QuestAppDbAdapter *adapter = [[QuestAppDbAdapter alloc] init];
		
		
		// get destination building coords
		CLLocationCoordinate2D currentCoords = [adapter buildingCoords:global.currentBuilding];
		
		
		// create CLLocation type object for destination coords
		CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:currentCoords.latitude 
																	 longitude:currentCoords.longitude];
		
		// calculate distance between user and destination location
		double distance = [userLocation distanceFromLocation:destinationLocation];
		global.nextDestinationDistance = [NSNumber numberWithFloat:distance];
		NSLog(@"Distance from destination '%s': %f", [global.currentBuilding UTF8String], distance);
		
		// check if in range
		if (distance <= 50) {
			
			// check if user has already been notified
			if ([global.isProximityFlagEnabled compare:[NSNumber numberWithBool:NO]] == NSOrderedSame) {
				
				// not notified yet
				
				[Sound soundEffect:@"DestinationReached"];
				global.score = [NSString stringWithFormat:@"%d", ([global.score intValue] + 50)];
				
				CustomStatusBar *_customStatusBar;
				_customStatusBar = [[CustomStatusBar alloc] initWithFrame:CGRectZero];
				[_customStatusBar showWithStatusMessage:@"50 aureus added!"];
				[self performSelector:@selector(boreTheUser:) 
						   withObject:_customStatusBar 
						   afterDelay:3];
				
				global.isProximityFlagEnabled = [NSNumber numberWithBool:YES];
				
				NSString *fontName = @"HelveticaNeue";
				[destinationReachedButton.titleLabel setFont:[UIFont fontWithName:fontName size:16]];
				destinationReachedButton.backgroundColor = [UIColor clearColor];
				
				CATransition *transition = [CATransition animation];
				transition.duration = 0.4;
				transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
				transition.type = kCATransitionFade;
				transition.subtype = kCATransitionFade;
				transition.delegate = self;
				
				//[[[viewContainer objectAtIndex:presentView] layer] addAnimation:transition forKey:nil];
				[self.window.layer addAnimation:transition forKey:nil];
				
				[[tabBarController view] setHidden:YES];
				[[viewOverLay view] setHidden:YES];
				
				destReachedView.hidden = NO;
				
				[global.unvisitedBuildings removeObjectAtIndex:0];
				[global.visitedBuildings addObject:global.currentBuilding];
				[self prepareDestViewWith:([global.visitedBuildings lastObject])];
				
				NSString *nextDestination = [adapter fetchNextDestinationCode:global.currentBuilding];
				
				NSLog(@"Next destination: %s", [nextDestination UTF8String]);
				
				if ([nextDestination length] == 0) {
					
					// reached end of the quest
					global.currentBuilding = @"END";
					
				} else {
					
					// still more quizzes to solve
					global.currentBuilding = nextDestination;
					
				}
				
				// broadcast destination updates
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DestinationChanged" object:nil];
			} else {
				// user already notified
				//global.isProximityFlagEnabled = [NSNumber numberWithBool:NO];
				
			}
		} else {
			global.isProximityFlagEnabled = [NSNumber numberWithBool:NO];
		}
		[destinationLocation release];
		[adapter release];
	}
}

- (IBAction)DestReached:(UIButton *)button{
	CATransition *transition = [CATransition animation];
	transition.duration = 0.4;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	transition.type = kCATransitionFade;
	transition.subtype = kCATransitionFade;
	transition.delegate = self;
	
	[self.window.layer addAnimation:transition forKey:nil];
	
	[destReachedView setHidden:YES];
	[[tabBarController view] setHidden:NO];
	[[viewOverLay view] setHidden:NO];
}

- (void)prepareDestViewWith:(NSString *)code {
	
	Global *global = [Global getInstance];
	listOfItems = [[NSMutableArray alloc] init];
	QuestAppDbAdapter *adapter = [[QuestAppDbAdapter alloc] init];
	listOfItems = [adapter fetchBuildingItemForCode:code];
	NSString *code1  = [[listOfItems objectAtIndex:0] _code];
	NSString *name = [adapter getNameForCode:code1];
	
	textView.backgroundColor = [UIColor clearColor];
	myWebView.backgroundColor = [UIColor clearColor];
	
	distanceLabel.text = [NSString stringWithFormat:@"%.0fm", [global.totalDistance floatValue]];
		
	textView.text = name;
	
	score.text = global.score;
	time.text = [NSString stringWithFormat:@"%02d : %02d : %02d", 
				 [global.hour intValue], 
				 [global.minute intValue], 
				 [global.second intValue]];
	
	progressBar = [[PDColoredProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	
	CGRect frame = progressBar.frame;
	frame.origin.x = 30;
	frame.origin.y = 348;
	frame.size.width = 260;
	
	progressBar.frame = frame;
	[progressBar setTintColor: [UIColor brownColor]];
	[destReachedView addSubview:progressBar];
	
	progressBar.progress = ((float)[global.visitedBuildings count]) / (((float)[global.visitedBuildings count]) 
																	   + ((float)[global.unvisitedBuildings count]));
		
	NSString *URLString = @"http://web-app.usc.edu/venues/";
	NSString *temp = [URLString stringByAppendingString:code ];
	NSString *temp1 = [temp stringByAppendingString:@".jpg"];
	NSURL *requestURL = [NSURL URLWithString:temp1];
	
	[myWebView loadRequest:[NSURLRequest requestWithURL:requestURL]];
	[destReachedView addSubview:myWebView];
	
	[adapter release];
}

-(void)tabBarController:(UITabBarController *)tabBarController1 didSelectViewController:(UIViewController *)viewController{
	if(tabBarController1.selectedIndex == 1)
	{
		Global *global = [Global getInstance];
		global.didZoomToUserLocation = [NSNumber numberWithBool:NO];

		if (mapsFlag == NO) {
			
			mapsFlag = YES;
			[Sound soundEffect:@"Alert"];
			
			CustomStatusBar *_customStatusBar;
			_customStatusBar = [[CustomStatusBar alloc] initWithFrame:CGRectZero];
			[_customStatusBar showWithStatusMessage:@"Map viewed. You lost 10 aureus!"];
			[self performSelector:@selector(boreTheUser:) 
					   withObject:_customStatusBar 
					   afterDelay:3];
			
			Global *global = [Global getInstance];
			global.score = [NSString stringWithFormat:@"%d",([global.score intValue] - 10)];
		}
	}
	else {
		mapsFlag = NO;
	}

}


- (void)startUpdatingUserLocation:(NSNotification *)notification {
	
	NSLog(@"Starting location manager");
	
	// Create a LocationController instance
	locationController = [[LocationController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];
}

- (void)locationError:(NSError *)error {
	
	NSLog(@"Error: %@", [error description]);
}

- (void)boreTheUser:(id) object {
	// empty boring function
	[object hide];
	[object release];
}

@end

