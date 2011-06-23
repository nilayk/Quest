//
//  BuildingsListViewController.m
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "BuildingsListViewController.h"
#import "QuestAppAppDelegate.h"
#import "QuestAppDbAdapter.h"
#import "BuildingsListItem.h"
#import "BuildingInfoViewController.h"
#import "Overlay.h"
#import "TabNavController.h"

@implementation BuildingsListViewController
@synthesize BuildingsDatabaseReturnVal;
@synthesize searchBox;
@synthesize buildingsTableView;
@synthesize detailViewController;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Buildings";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"GameView" 
																			 style:UIBarButtonSystemItemDone 
																			target:self 
																			action:@selector(gotoGameView)];
	QuestAppDbAdapter *adapter = [[QuestAppDbAdapter alloc] init];
	BuildingsDatabaseReturnVal = [adapter fetchAllBuildings];
	
	listOfItems = [[NSMutableArray alloc] init];
	[listOfItems addObjectsFromArray:BuildingsDatabaseReturnVal];
	
	copyListOfItemsName = [[NSMutableArray alloc] init];	//initialising the copy array of names
	copyListOfItemsKey = [[NSMutableArray alloc] init];		//initialising the copy array of keys
	copyListOfItemsCode = [[NSMutableArray alloc] init];	//initialising the copy arrays of code
	
	self.tableView.tableHeaderView = searchBox;
	searchBox.autocorrectionType = UITextAutocorrectionTypeNo;
	
	searching = NO;
	letUserSelectRow = YES;
	
	[adapter release];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if(searching)
	{
		return [copyListOfItemsName count];
	}
	else
	{
		return [listOfItems count];
	}
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(searching)
	{
		NSString *info = [[NSNumber numberWithInt:[copyListOfItemsName count]] stringValue];
		NSString *ret = [info stringByAppendingString:@" Search Results"];
		return ret;
	}
	else 
		return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
		cell = [self getCellContentView:CellIdentifier];
	
	UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
	UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
	
	if(searching)
	{
		
		lblTemp1.text = [copyListOfItemsName objectAtIndex:indexPath.row];
		lblTemp2.text = [copyListOfItemsCode objectAtIndex:indexPath.row];;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    else
	{
		// Configure the cell.
		BuildingsListItem *building = [listOfItems objectAtIndex:indexPath.row];
		NSString *labelname = building._name;
		NSString *labelcode = building._code;
		
		lblTemp1.text = labelname;
		lblTemp2.text = labelcode;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return cell;
}

-(UITableViewCell *) getCellContentView:(NSString *)cellIdentifier{
	CGRect cellFrame = CGRectMake(0,0,300,60);
	CGRect label1Frame = CGRectMake(10, 10, 290, 25);
	CGRect label2Frame = CGRectMake(10, 33, 290, 25);

	UILabel *lblTemp;

	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:cellFrame 
													reuseIdentifier:cellIdentifier] autorelease];

	//initialising label 1
	lblTemp = [[UILabel alloc] initWithFrame:label1Frame];
	lblTemp.tag = 1;
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];

	//initialising label 2
	lblTemp = [[UILabel alloc] initWithFrame:label2Frame];
	lblTemp.tag = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor lightGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];

	return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	detailViewController = [[BuildingInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	if(searching) {
		primaryKey = [copyListOfItemsKey objectAtIndex:indexPath.row];
		detailViewController.title = [copyListOfItemsName objectAtIndex:indexPath.row];
	}
	else { 
		primaryKey = [[listOfItems objectAtIndex:indexPath.row] _pkey];
		detailViewController.title = [[listOfItems objectAtIndex:indexPath.row] _name];
	}
	
	[detailViewController givePrimaryKey:primaryKey];
	QuestAppAppDelegate *delegate = (QuestAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate.buildingsNavController pushViewController:detailViewController 
											   animated:YES];
	[detailViewController release];
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[searchBox resignFirstResponder];
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)SearchBar {
	
	//This method is called again when the user clicks back from teh detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	if(searching)
		return;
	
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[Overlay alloc] init];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;	
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.rvController = self;
	
	[self.tableView insertSubview:ovController.view 
					 aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	buildingsTableView.scrollEnabled = NO;
	
	//Add the done button.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																						   target:self 
																						   action:@selector(doneSearching_Clicked:)];
	
}

- (void)searchBar:(UISearchBar *)SearchBar textDidChange:(NSString *)searchText {
	
	//Remove all objects first.
	[copyListOfItemsName removeAllObjects];
	[copyListOfItemsKey removeAllObjects];
	[copyListOfItemsCode removeAllObjects];
	
	if([searchText length] > 0) 
	{
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		buildingsTableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else
	{
		[buildingsTableView insertSubview:ovController.view 
							 aboveSubview:self.parentViewController.view];
		searching = NO;
		letUserSelectRow = NO;
		buildingsTableView.scrollEnabled = NO;
	}
	
	[buildingsTableView reloadData];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)SearchBar {
	
	[self searchTableView];
}

- (void) searchTableView {
	
	NSString *searchText = searchBox.text;
	NSMutableArray *searchNameArray = [[NSMutableArray alloc] init];
	NSMutableArray *searchKeyArray = [[NSMutableArray alloc] init];
	NSMutableArray *searchCodeArray = [[NSMutableArray alloc] init];
	
	for (int i=0 ; i < [listOfItems count]; i++)
	{
		NSString *bName = [[listOfItems objectAtIndex:i] _name];
		NSString *bId = [[listOfItems objectAtIndex:i] _pkey];
		NSString *bCode = [[listOfItems objectAtIndex:i] _code];
		[searchNameArray addObject:bName]; 
		[searchKeyArray addObject:bId]; 
		[searchCodeArray addObject:bCode];
	}
	
	for (int i=0; i < [searchNameArray count]; i++)
	{
		NSString *tempName = [searchNameArray objectAtIndex:i];
		NSString *tempPkey = [searchKeyArray objectAtIndex:i];
		NSString *tempCode = [searchCodeArray objectAtIndex:i];
		
		NSRange titleResultsRange = [tempName rangeOfString:searchText 
													options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0)
		{
			[copyListOfItemsName addObject:tempName];
			[copyListOfItemsKey addObject:tempPkey];
			[copyListOfItemsCode addObject:tempCode];
		}
	}
	
	[searchNameArray release];
	searchNameArray = nil;
	
	[searchKeyArray release];
	searchKeyArray = nil;
	
	[searchCodeArray release];
	searchCodeArray = nil;
}

-(void)gotoGameView {
	QuestAppAppDelegate *delegate = (QuestAppAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
						   forView:delegate.window cache:YES];
	[delegate.tabBarController.view removeFromSuperview];
	[UIView commitAnimations];
	

}

- (void) doneSearching_Clicked:(id)sender {
	
	searchBox.text = @"";
	[searchBox resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	
	self.navigationItem.rightBarButtonItem = nil;
	
	//self.navigationItem.leftBarButtonItem.title = @"GameView";
	
											 
	buildingsTableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[buildingsTableView reloadData];
}

-(NSString *)getPrimaryKey{
	return primaryKey;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}



@end

