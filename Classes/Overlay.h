//
//  Overlay.h
//  Buildings
//
//  Created by Siddharth Gami on 4/4/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuildingsListViewController;

@interface Overlay : UIViewController {
	BuildingsListViewController *rvController;
}

@property (nonatomic,retain) BuildingsListViewController *rvController;

@end
