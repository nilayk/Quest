//
//  DetailedInfo.m
//  Buildings
//
//  Created by Siddharth Gami on 3/29/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "BuildingsListViewController.h"
#import "QuestAppAppDelegate.h"
#import "QuestAppDbAdapter.h"
#import "BuildingsListItem.h"
#import "BuildingInfoViewController.h"
#import "Overlay.h"
#import "TabNavController.h"


@implementation BuildingInfoViewController
@synthesize BuildingsDatabaseReturnVal;
@synthesize infoTableView;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	//self.title = @"Detailed Information";
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
}

-(void)givePrimaryKey:(NSString *)primaryKey{
	pkey = [primaryKey intValue];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	QuestAppDbAdapter *adapter = [[QuestAppDbAdapter alloc] init];
	BuildingsDatabaseReturnVal = [adapter fetchBuildingItemForKey:(pkey)];	
	listOfItems = [[NSMutableArray alloc] init];
	[listOfItems addObjectsFromArray:BuildingsDatabaseReturnVal];
	[adapter release];
	//NSLog([BuildingsDatabaseReturnVal count]);
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 
 }*/

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
    return 11;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
  //  NSLog([NSString stringWithFormat:@"%d",[ResultSet count] ]);
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *sectionName = nil;
	
	switch (section) {
		case 0:
			sectionName = [NSString stringWithFormat:@"Code of the Building"];
			break;
		case 1:
			sectionName = [NSString stringWithFormat:@"Name of the Building"];
			break;
		case 2:
			sectionName = [NSString stringWithFormat:@"Latitude"];
			break;
		case 3:
			sectionName = [NSString stringWithFormat:@"Longitude"];
			break;
		case 4:
			sectionName = [NSString stringWithFormat:@"Builiding ID"];
			break;
		case 5:
			sectionName = [NSString stringWithFormat:@"Campus"];
			break;
		case 6:
			sectionName = [NSString stringWithFormat:@"Image"];
			break;
		case 7:
			sectionName = [NSString stringWithFormat:@"Description"];
			break;
		case 8:
			sectionName = [NSString stringWithFormat:@"Address"];
			break;
		case 9:
			sectionName = [NSString stringWithFormat:@"Type Of the Building"];
			break;
		case 10:
			sectionName = [NSString stringWithFormat:@"URL"];
			break;
			
	}
	
	return sectionName;
}


/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}*/
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
   	building = [listOfItems objectAtIndex:indexPath.row];
	 
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = building._code;//[NSString stringWithFormat:@"Name of the Building"];
			break;
		case 1:
			cell.textLabel.text = building._name; //[NSString stringWithFormat:@"Latitude"];
			break;
		case 2:
			cell.textLabel.text = building._latitude;// [NSString stringWithFormat:@"Longitude"];
			break;
		case 3:
			cell.textLabel.text = building._longitude;//[NSString stringWithFormat:@"Campus"];
			break;
		case 4:
			cell.textLabel.text = building._bid;//[NSString stringWithFormat:@"Address"];
			break;
		case 5:
			cell.textLabel.text = building._campus;//[NSString stringWithFormat:@"URL"];
			break;
		case 6:
			cell.textLabel.text = building._image;//[NSString stringWithFormat:@"Name of the Building"];
			break;
		case 7:
			cell.textLabel.text = building._description; //[NSString stringWithFormat:@"Latitude"];
			//cell.textLabel.numberOfLines = ;
			//cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
			break;
		case 8:
			cell.textLabel.text = building._address;// [NSString stringWithFormat:@"Longitude"];
			break;
		case 9:
			cell.textLabel.text = building._type;//[NSString stringWithFormat:@"Campus"];
			break;
		case 10:
			cell.textLabel.text = building._url;//[NSString stringWithFormat:@"Address"];
			
	}
	
    return cell;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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

/*
- (void)dealloc {
    [super dealloc];
}
*/

@end

