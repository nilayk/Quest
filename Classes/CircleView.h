//
//  CircleView.h
//  QuestApp
//
//  Created by Siddharth Gami on 4/19/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import <UIKit/UIKit.h>

#define kCircleClosureAngleVariance     45.0
#define kCircleClosureDistanceVariance  50.0
#define kMaximumCircleTime              2.0
#define kRadiusVariancePercent          25.0
#define kOverlapTolerance               3

@class GameView;
@interface CircleView : UIView {
	IBOutlet UILabel *label;
	
	NSMutableArray *points;
	CGPoint firstTouch;
	NSTimeInterval firstTouchTime;
	
	int flagDetection;
	
	GameView *GameObject;
}

@property (nonatomic, retain) UILabel * label;
@property (nonatomic, retain) GameView *GameObject;
@property (nonatomic, retain) NSMutableArray *points;

- (void)eraseText;

@end
