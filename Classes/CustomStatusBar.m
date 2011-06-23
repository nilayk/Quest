//
//  CustomStatusBar.m
//  Quest
//
//  Created by Nilay Khandelwal on 4/24/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "CustomStatusBar.h"


@implementation CustomStatusBar

- (id) initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame]))
	{
		// Place the window on the correct level & position
		self.windowLevel = UIWindowLevelStatusBar + 1.0f;
		self.frame = [UIApplication sharedApplication].statusBarFrame;
		
		// Create an image view with an image to make it look like the standard grey status bar
		UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
		backgroundImageView.image = [[UIImage imageNamed:@"statusbar_background.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
		[self addSubview:backgroundImageView];
		[backgroundImageView release];

		_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_indicator.frame = (CGRect){.origin.x = 2.0f, .origin.y = 3.0f, .size.width = self.frame.size.height - 6, .size.height = self.frame.size.height - 6};
		_indicator.hidesWhenStopped = YES;
		[self addSubview:_indicator];

		_statusLabel = [[UILabel alloc] initWithFrame:(CGRect){.origin.x = self.frame.size.height, .origin.y = 0.0f, .size.width = 280.0f, .size.height = self.frame.size.height}];
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textColor = [UIColor whiteColor];
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		[self addSubview:_statusLabel];
	}
	return self;
}

- (void) dealloc {
	[_statusLabel release];
	[_indicator release];
	[super dealloc];
}

- (void) showWithStatusMessage:(NSString*)msg {
	if (!msg) return;
	_statusLabel.text = msg;
	[_indicator startAnimating];
	self.hidden = NO;
}

- (void) hide {
	[_indicator stopAnimating];
	self.hidden = YES;
}

@end