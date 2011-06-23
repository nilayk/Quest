//
//  musicPlayer.h
//  Quest
//
//  Created by Siddharth Gami on 4/26/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <MediaPlayer/MPMediaPickerController.h>

@interface MusicPlayer : UIViewController<MPMediaPickerControllerDelegate> {
	
	IBOutlet UISegmentedControl *playSwitch;
	IBOutlet UIButton *selectPlaylist;
	
	MPMusicPlayerController *player;
	MPMediaPickerController *picker;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *playSwitch;
@property (nonatomic, retain) IBOutlet UIButton *selectPlaylist;

@property (nonatomic, retain) MPMusicPlayerController *player;
@property (nonatomic, retain) MPMediaPickerController *picker;

-(void)playPauseMusic:(id)sender;
- (IBAction) loadPlaylist:(id)sender;

@end
