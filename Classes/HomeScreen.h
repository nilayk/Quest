//
//  HomeScreen.h
//  Quest
//
//  Created by Siddharth Gami on 4/23/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDColoredProgressView.h"

//@class GameView;
@interface HomeScreen : UIViewController {
	PDColoredProgressView *pView;
	
	IBOutlet UIView *splash;
	IBOutlet UIView *home;
	IBOutlet UIView *rules;
	
	IBOutlet UIButton *playButton;
	IBOutlet UIButton *rulesButton;
	
	IBOutlet UITextView *rulesText;
}

- (void) switchView;

- (IBAction) gameViewAppears:(UIButton *)button;
- (IBAction) rulesViewAppears:(UIButton *)rulesButton;
- (IBAction) backToHomeScreen:(id)backButton;

@property (nonatomic, retain) IBOutlet UIView *splash;
@property (nonatomic, retain) IBOutlet UIView *home;
@property (nonatomic, retain) IBOutlet UIView *rules;

@property (nonatomic, retain) IBOutlet UITextView *rulesText;

@property (nonatomic, retain) PDColoredProgressView *pView;

@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *rulesButton;
@end
