//
//  CustomStatusBar.h
//  Quest
//
//  Created by Nilay Khandelwal on 4/24/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomStatusBar : UIWindow {
	
@private
	UILabel* _statusLabel; // Text label to display informations
	UIActivityIndicatorView* _indicator; // The indicator
}

- (void) showWithStatusMessage:(NSString*)msg;
- (void) hide;

@end