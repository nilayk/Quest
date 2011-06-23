//
//  FirstViewController.h
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GameView.h"

@interface MapViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *myMapView;
	NSString *code;
	NSString *name;
	GameView *infoViewController;
	IBOutlet UIView *viewInfo;
	
	IBOutlet UIWebView *myWebView;
	
	IBOutlet UITextView *myLabel;
	IBOutlet UITextView *myText;
	
	NSMutableArray *listOfItems;
}

-(IBAction)returnToMap:(id)sender;
-(void)prepareWebView;
-(IBAction)gotoGameView:(id)sender;

@property (nonatomic,retain) GameView *infoViewController;
@property (nonatomic,retain) MKMapView *myMapView;
@property (nonatomic,retain) IBOutlet UIView *viewInfo;
@property (nonatomic, retain) IBOutlet UITextView *myLabel;
@property (nonatomic, retain) IBOutlet UITextView *myText;
@property (nonatomic, retain) IBOutlet UIWebView *myWebView;
@property (nonatomic, retain) NSMutableArray *listOfItems;

@end
