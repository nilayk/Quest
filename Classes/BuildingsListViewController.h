//
//  BuildingsListViewController.h
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Overlay;
@class BuildingInfoViewController;

@interface BuildingsListViewController : UITableViewController <UISearchBarDelegate> {
	NSMutableArray *BuildingsDatabaseReturnVal;
	NSString *primaryKey;
	NSMutableArray *listOfItems;
	NSMutableArray *copyListOfItemsName;
	NSMutableArray *copyListOfItemsKey;
	NSMutableArray *copyListOfItemsCode;
	IBOutlet UISearchBar *searchBox;
	IBOutlet UITableView *buildingsTableView;
	BuildingInfoViewController *detailViewController;
	BOOL searching;
	BOOL letUserSelectRow;
	
	Overlay *ovController; 
	
	
}

-(NSString *)getPrimaryKey;
-(void) doneSearching_Clicked:(id)sender;
-(UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;
-(void) searchTableView;
-(void)gotoGameView;

@property (nonatomic,retain) NSMutableArray *BuildingsDatabaseReturnVal;
@property (nonatomic,retain) IBOutlet UISearchBar *searchBox;
@property (nonatomic,retain) IBOutlet UITableView *buildingsTableView;
@property (nonatomic,retain) BuildingInfoViewController *detailViewController;


@end
