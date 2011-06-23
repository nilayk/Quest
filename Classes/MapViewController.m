//
//  FirstViewController.m
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "MapViewController.h"
#import "Global.h"
#import "QuestAppDbAdapter.h"
#import "BuildingsListItem.h"
#import "MapAnnotation.h"
#import "QuestAppAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <sqlite3.h>

@implementation MapViewController
@synthesize infoViewController, myMapView, viewInfo, myLabel, myText, myWebView,listOfItems; 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	//view1 = [[UIView alloc] init];
	
	myMapView.zoomEnabled = YES;
	myMapView.scrollEnabled = YES;
	myMapView.delegate = self;
	
	Global *global = [Global getInstance];
	global.didZoomToUserLocation = [NSNumber numberWithBool:NO];
	
	// Fetch all locations from database
	QuestAppDbAdapter* adapter = [[QuestAppDbAdapter alloc] init];
	NSMutableArray* allBuildings = [adapter fetchAllBuildings];
	[adapter release];
	
	// Create annotations for all locations to plot on map
	for (int i = 0; i < [allBuildings count]; i++) {
		NSUInteger pinID = [[[allBuildings objectAtIndex:i] _pkey] integerValue];
		NSString* pinName = [[allBuildings objectAtIndex:i] _name];
		NSString* pinCode = [[allBuildings objectAtIndex:i] _code];
		CGFloat latitude = [[[allBuildings objectAtIndex:i] _latitude] floatValue];
		CGFloat longitude = [[[allBuildings objectAtIndex:i] _longitude] floatValue];
		
		
		CLLocationCoordinate2D coordinate = { latitude, longitude };
		
		MapAnnotation* annotation = [[MapAnnotation alloc] initWithID:pinID 
																 name:pinName 
																 code:pinCode 
														   coordinate:coordinate];
		
		
		
		[myMapView addAnnotation:annotation];
		[annotation release];
	}
	
	
	[self.view addSubview:viewInfo];
	
	viewInfo.hidden = YES;
	
}
-(IBAction)gotoGameView:(id)sender{
	
	QuestAppAppDelegate *delegate = (QuestAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
						   forView:delegate.window 
							 cache:YES];
	
	[delegate.tabBarController.view removeFromSuperview];
	[UIView commitAnimations];
	
}

-(void)prepareWebView{
	listOfItems = [[NSMutableArray alloc] init];
	QuestAppDbAdapter* adapter = [[QuestAppDbAdapter alloc] init];
	NSMutableArray *buildings = [adapter fetchBuildingItemForCode:code];
	[listOfItems addObjectsFromArray:buildings];
	[adapter release];
	
	UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
	[self.viewInfo setBackgroundColor:background]; 
	
	NSString *URLString = @"http://web-app.usc.edu/venues/";
	NSString *temp = [URLString stringByAppendingString:code ];
	NSString *temp1 = [temp stringByAppendingString:@".jpg"];
	NSURL *requestURL = [NSURL URLWithString:temp1];
	[myWebView loadRequest:[NSURLRequest requestWithURL:requestURL]];
	
	NSString *labelText = [[[name stringByAppendingString:@" ("] stringByAppendingString:code] stringByAppendingString:@")"];
	
	myLabel.text = labelText;
	[myLabel setBackgroundColor:[UIColor clearColor]];
	
	myText.text = [[listOfItems objectAtIndex:0] _description];
	[myText setBackgroundColor:[UIColor clearColor]];
	[background release];
}

-(IBAction)returnToMap:(id)sender {
	
	CATransition *transition = [CATransition animation];
	transition.duration = 0.5;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	transition.type = kCATransitionPush;
	transition.subtype = kCATransitionFromLeft;
	transition.delegate = self;
	[self.view.layer addAnimation:transition forKey:nil];
	
	viewInfo.hidden = YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [super dealloc];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
	Global *global = [Global getInstance];
//	if ([global.didZoomToUserLocation compare:[NSNumber numberWithBool:NO]] == NSOrderedSame) {
		
		global.didZoomToUserLocation = [NSNumber numberWithBool:YES];
		MKCoordinateRegion region;
		region.center = userLocation.location.coordinate;
		MKCoordinateSpan span = { 0.001, 0.001 };
		region.span = span;
		[mapView setRegion:region animated:YES];
//		
//	} else {
//		return;
//	}
	
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView 
			viewForAnnotation:(id <MKAnnotation>)annotation {
	
	if( [[annotation title] isEqualToString:@"Current Location"] ) {
		return nil;
	}
	
	MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
	
	if (pinView == nil) {
		
		pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
												   reuseIdentifier:@"Pin"] autorelease];
		
		pinView.pinColor = MKPinAnnotationColorPurple;
		pinView.animatesDrop = YES;
		pinView.canShowCallout = YES;
	} else {
		pinView.annotation = annotation;
	}
	
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[rightButton addTarget:self
					action:nil
		  forControlEvents:UIControlEventTouchUpInside];
	
	pinView.rightCalloutAccessoryView = rightButton;
	
	return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	code = [view.annotation subtitle];
	name = [view.annotation title];
	
	CATransition *transition = [CATransition animation];
	transition.duration = 0.5;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	transition.type = kCATransitionPush;
	transition.subtype = kCATransitionFromRight;
	transition.delegate = self;
	[self.view.layer addAnimation:transition forKey:nil];
	
	[self prepareWebView];
	
	viewInfo.hidden = NO;
	
}

@end
