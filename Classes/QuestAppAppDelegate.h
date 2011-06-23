//
//  QuestAppAppDelegate.h
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TabNavController.h"
#import "LocationController.h"
#import "PDColoredProgressView.h"

@class GameView;
@class HomeScreen;

@interface QuestAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, LocationControllerDelegate, UIAlertViewDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	TabNavController *buildingsNavController;
	
	IBOutlet UIView *destReachedView;
	IBOutlet UITextView *textView;
	
	IBOutlet UILabel *score;
	IBOutlet UILabel *time;
	IBOutlet UILabel *distanceLabel;
	
	IBOutlet UIWebView *myWebView;
	
	BOOL mapsFlag;
	
	IBOutlet UIButton *destinationReachedButton;
	
	HomeScreen *homeView;
	GameView *viewOverLay;
	
	LocationController *locationController;
	
	PDColoredProgressView *progressBar;
	
	NSMutableArray *listOfItems;
	
	NSMutableArray *userCoordsLatitude;
	NSMutableArray *userCoordsLongitude;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet TabNavController *buildingsNavController;
@property (nonatomic, retain) IBOutlet GameView *viewOverLay;
@property (nonatomic, retain) IBOutlet HomeScreen *homeView;
@property (nonatomic, retain) IBOutlet UIView *destReachedView;
@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UILabel *score;
@property (nonatomic, retain) IBOutlet UILabel *time;
@property (nonatomic, retain) IBOutlet UIWebView *myWebView;
@property (nonatomic, retain) IBOutlet UIButton *destinationReachedButton;
@property (nonatomic, retain) NSMutableArray *userCoordsLatitude;
@property (nonatomic, retain) NSMutableArray *userCoordsLongitude;

@property (nonatomic, retain) IBOutlet PDColoredProgressView *progressBar;

- (void)locationUpdate:(CLLocation *)userLocation;
- (void)locationError:(NSError *)error;
- (void)startUpdatingUserLocation:(NSNotification *)notification;
- (IBAction)DestReached:(UIButton *)button; 
- (void)prepareDestViewWith:(NSString *)code;
- (void)boreTheUser:(id) object;

@end
