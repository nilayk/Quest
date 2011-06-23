//
//  SoundEffect.m
//  Quest
//
//  Created by Nilay Khandelwal on 4/23/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "SoundEffect.h"
#import "MusicPlayer.h"

@implementation Sound

+ (void) soundEffect:(NSString *)effectName {
	
	NSString *effect = @"";
	NSString *type = @"";
	
	NSString *path;
	NSURL *url;
	
	if (effectName == @"DestinationReached") {
		effect = @"destination_reached";
		type = @"caf";
	}
	else if (effectName == @"WrongAnswer") {
		effect = @"wrong_answer";
		type = @"caf";
	}
	else if (effectName == @"Alert") {
		effect = @"alert";
		type = @"mp3";
	}
	else if (effect == @"PlayGame") {
		effect = @"play";
		type = @"mp3";
	}
	else if (effect == @"FlipView") {
		effect = @"flip_sound";
		type = @"mp3";
	}
	else if (effect == @"GestureShake") {
		effect = @"shake_success";
		type = @"mp3";
	}
	
	@try {		
		path = [[NSBundle mainBundle] pathForResource:effect ofType:type];
		url = [NSURL fileURLWithPath:path];
		
		AVAudioPlayer *player;
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
		
		[player play];
		
		MusicPlayer *music = [[MusicPlayer alloc] init];
		[music.player play];
	}
	@catch (NSException * e) {
		NSLog(@"Error playing audio clip: %@", e);
	}
}

- (void)dealloc {
	[super dealloc];
}

@end
