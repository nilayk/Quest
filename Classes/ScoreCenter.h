//
//  Timer.h
//  Quest
//
//  Created by Siddharth Gami on 4/23/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDColoredProgressView.h"

@interface ScoreCenter : UIViewController {
	NSTimer *timer;

	IBOutlet UILabel *timerLabel;
	IBOutlet UILabel *scoreLabel;
	
	IBOutlet UIProgressView *gameProgress;
	
	IBOutlet UILabel *distanceTraveled;
	IBOutlet UILabel *steps;
	
	int hour,minute,sec,visitedBuildingsCount,unVisitedBuildingsCount;
	float incrementStep;
	
	PDColoredProgressView *progressBar;
}

- (void)time;
- (IBAction)gotoGameView:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *timerLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;

@property (nonatomic, retain) IBOutlet PDColoredProgressView *progressBar;

@property (nonatomic, retain) IBOutlet UILabel *distanceTraveled;
@property (nonatomic, retain) IBOutlet UILabel *steps;

@end
