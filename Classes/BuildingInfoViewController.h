//
//  BuildingInfoViewController.h
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuildingsListViewController;
@class BuildingsListItem;

@interface BuildingInfoViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *BuildingsDatabaseReturnVal;
	int pkey;
	IBOutlet UITableView *infoTableView;
	BuildingsListItem *building;
	NSMutableArray *listOfItems;
}

-(void)givePrimaryKey:(NSString *)primaryKey;
@property (nonatomic,retain) NSMutableArray *BuildingsDatabaseReturnVal;
@property (nonatomic,retain) IBOutlet UITableView *infoTableView;
@end
