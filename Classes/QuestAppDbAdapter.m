//
//  QuestAppDbAdapter.m
//  QuestApp
//
//  Created by Nilay Khandelwal on 3/29/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "QuestAppDbAdapter.h"
#import "BuildingsListItem.h"
#import "Questions.h"
#import "Clues.h"

@implementation QuestAppDbAdapter

-(void) checkAndCreateDatabase {
	
    // Setting the name of the database
	databaseName = @"buildingsList.sql";
    
	// Setting the path of the database file
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
																 NSUserDomainMask, 
																 YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];	
	
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
	//[fileManager release];
}

-(NSMutableArray *)fetchAllBuildings {
	
	// Init the results array
	NSMutableArray* results = [[[NSMutableArray alloc] init] autorelease];
	
	//initialisation before reading the database
	databaseName = @"buildingsList.sql";
	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
																 NSUserDomainMask, 
																 YES);
	NSString* documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Setup the database object
	sqlite3 *database;
	
	@try {
		// Open the database from the users filessytem
		if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			// Setup the SQL Statement and compile it for faster access
			const char *sqlStatement = "SELECT * FROM [buildingsList]";
			
			sqlite3_stmt *compiledStatement;
			
			if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
				
				// Loop through the results and add them to the feeds array
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
					
					// Read the data from the result row
					NSString *bPkey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
					NSString *bCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]; 
					NSString *bName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
					NSString *bLatitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
					NSString *bLongitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
					NSString *bBid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
					NSString *bCampus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
					NSString *bImage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
					NSString *bDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
					NSString *bAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
					NSString *bType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
					NSString *bURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
					
					// Create a new building object with the data from the database
					BuildingsListItem *row = [[BuildingsListItem alloc] initWithPkey:(NSString *)bPkey 
																				code:(NSString *)bCode 
																				name:(NSString *)bName 
																			latitude:(NSString *)bLatitude 
																		   longitude:(NSString *)bLongitude 
																				 bid:(NSString *)bBid 
																			  campus:(NSString *)bCampus 
																			   image:(NSString *)bImage 
																		 description:(NSString *)bDescription 
																			 address:(NSString *)bAddress 
																				type:(NSString *)bType 
																				 url:(NSString *)bURL];
					
					// Add the building object to the buildings Array
					[results addObject:row];
					[row release];
				}
			}
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
			
		}
		sqlite3_close(database);
	}
	@catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	}
	@finally {
		NSLog(@"finally");
	}
	
	return results;
}

- (NSMutableArray *)fetchBuildingItemForKey:(int)primarykey {
	
	// Init the results array
	NSMutableArray* results = [[[NSMutableArray alloc] init] autorelease];
	
	//initialisation before reading the database
	databaseName = @"buildingsList.sql";
	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
																 NSUserDomainMask, 
																 YES);
	NSString* documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Setup the database object
	sqlite3 *database;
	
	@try {
		// Open the database from the users filessytem
		if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			// Setup the SQL Statement and compile it for faster access
			const char *sqlStatement = "SELECT * FROM [buildingsList] WHERE [_id] = ?";
			
			sqlite3_stmt *compiledStatement;
			
			if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
				
				// Bind query objects to prepared statement
				sqlite3_bind_int(compiledStatement, 1, primarykey);
				
				// Loop through the results and add them to the feeds array
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
					
					// Read the data from the result row
					NSString *bPkey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
					NSString *bCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]; 
					NSString *bName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
					NSString *bLatitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
					NSString *bLongitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
					NSString *bBid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
					NSString *bCampus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
					NSString *bImage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
					NSString *bDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
					NSString *bAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
					NSString *bType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
					NSString *bURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
					
					// Create a new building object with the data from the database
					BuildingsListItem *row = [[BuildingsListItem alloc] initWithPkey:(NSString *)bPkey 
																				code:(NSString *)bCode 
																				name:(NSString *)bName 
																			latitude:(NSString *)bLatitude 
																		   longitude:(NSString *)bLongitude 
																				 bid:(NSString *)bBid 
																			  campus:(NSString *)bCampus 
																			   image:(NSString *)bImage 
																		 description:(NSString *)bDescription 
																			 address:(NSString *)bAddress 
																				type:(NSString *)bType 
																				 url:(NSString *)bURL];
					
					// Add the building object to the buildings Array
					[results addObject:row];
					//[row release];
				}
			}
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
			
		}
		sqlite3_close(database);
	}
	@catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	}
	@finally {
		NSLog(@"finally");
	}
	
	return results;
}

- (NSMutableArray *)fetchBuildingItemForCode:(NSString *)code {
	
	// Init the results array
	NSMutableArray* results = [[[NSMutableArray alloc] init] autorelease];
	
	//initialisation before reading the database
	databaseName = @"buildingsList.sql";
	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
																 NSUserDomainMask, 
																 YES);
	NSString* documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Setup the database object
	sqlite3 *database;
	
	@try {
		// Open the database from the users filessytem
		if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			// Setup the SQL Statement and compile it for faster access
			const char *sqlStatement = "SELECT * FROM [buildingsList] WHERE [code] = ?";
			
			sqlite3_stmt *compiledStatement;
			
			if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
				
				// Bind query objects to prepared statement
				sqlite3_bind_text(compiledStatement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
				
				// Loop through the results and add them to the feeds array
				
				//	NSLog(compiledStatement);
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
					
					// Read the data from the result row
					NSString *bPkey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
					NSString *bCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]; 
					NSString *bName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
					NSString *bLatitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
					NSString *bLongitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
					NSString *bBid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
					NSString *bCampus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
					NSString *bImage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
					NSString *bDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
					NSString *bAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
					NSString *bType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
					NSString *bURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
					
					// Create a new building object with the data from the database
					BuildingsListItem *row = [[BuildingsListItem alloc] initWithPkey:(NSString *)bPkey 
																				code:(NSString *)bCode 
																				name:(NSString *)bName 
																			latitude:(NSString *)bLatitude 
																		   longitude:(NSString *)bLongitude 
																				 bid:(NSString *)bBid 
																			  campus:(NSString *)bCampus 
																			   image:(NSString *)bImage 
																		 description:(NSString *)bDescription 
																			 address:(NSString *)bAddress 
																				type:(NSString *)bType 
																				 url:(NSString *)bURL];
					
					// Add the building object to the buildings Array
					[results addObject:row];
					//[row release];
				}
			}
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
			
		}
		sqlite3_close(database);
	}
	@catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	}
	@finally {
		NSLog(@"finally");
	}
	
	return results;
}

- (NSMutableArray *)fetchAllDestinationCodes {
	
	// Init the results array
	NSMutableArray* results = [[[NSMutableArray alloc] init] autorelease];
	
	//initialisation before reading the database
	databaseName = @"buildingsList.sql";
	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
																 NSUserDomainMask, 
																 YES);
	NSString* documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Setup the database object
	sqlite3 *database;
	
	@try {
		// Open the database from the users filesystem
		if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			// Setup the SQL statement and compile it for faster access
			const char *sqlStatement = "SELECT [bcode] FROM [buildingsQuiz]";
			
			sqlite3_stmt *compiledStatement;
			
			if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
				
				// Loop through the results and add them to the feeds array
				while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
					
					// Read the data from the result row
					NSString *bcode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
					
					// Add the building code to the results array
					[results addObject:bcode];
				}
			}
			
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
		}
		
		sqlite3_close(database);
	}
	@catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	}
	
	return results;
}

- (NSString *)fetchNextDestinationCode:(NSString *)currentBuildingCode {
	
	NSString *destinationBuildingCode = [[[NSString alloc] init] autorelease];
	
	//initialisation before reading the database
	databaseName = @"buildingsList.sql";
	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
																 NSUserDomainMask, 
																 YES);
	NSString* documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Setup the database object
	sqlite3 *database;
	
	@try {
		// Open the database from the users filesystem
		if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			// Setup the SQL statement and compile it for faster access
			const char *sqlStatement = "SELECT [dcode] FROM [buildingsPath] WHERE [scode] = ?";
			
			sqlite3_stmt *compiledStatement;
			
			if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
				
				// Bind query object to prepared statement
				sqlite3_bind_text(compiledStatement, 1, [currentBuildingCode UTF8String], -1, SQLITE_TRANSIENT);
				
				// Loop through the results and add them to the feeds array
				while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
					
					// Read the data from the result row
					destinationBuildingCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				}
			}
			
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
		}
		
		sqlite3_close(database);
	}
	@catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	}
	
	return destinationBuildingCode;
}

- (CLLocationCoordinate2D)buildingCoords:(NSString *)buildingCode {

	CLLocationCoordinate2D coords;
	
	//initialisation before reading the database
	databaseName = @"buildingsList.sql";
	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
																 NSUserDomainMask, 
																 YES);
	NSString* documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Setup the database object
	sqlite3 *database;
	
	@try {
		// Open the database from the users filesystem
		if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			// Setup the SQL statement and compile it for faster access
			const char *sqlStatement = "SELECT [latitude], [longitude] FROM [buildingsList] WHERE [code] = ?";
			
			sqlite3_stmt *compiledStatement;
			
			if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
				
				// Bind query object to prepared statement
				sqlite3_bind_text(compiledStatement, 1, [buildingCode UTF8String], -1, SQLITE_TRANSIENT);
				
				// Loop through the results and add them to the feeds array
				while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
					
					// Read the data from the result row
					NSString* latitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
					NSString* longitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
					
					coords.latitude = [latitude floatValue];
					coords.longitude = [longitude floatValue];
				}
			}
			
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
		}
		
		sqlite3_close(database);
	}
	@catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	}
	
	return coords;
}

- (NSMutableArray *)getQuizForCode:(NSString *)code{
	
	// Init the results array
	NSMutableArray* results = [[[NSMutableArray alloc] init] autorelease];
	
	//initialisation before reading the database
	databaseName = @"buildingsList.sql";
	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
																 NSUserDomainMask, 
																 YES);
	NSString* documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Setup the database object
	sqlite3 *database;
	
	@try {
		// Open the database from the users filessytem
		if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			// Setup the SQL Statement and compile it for faster access
			const char *sqlStatement = "select * from buildingsQuiz where bcode = ?";
			
			sqlite3_stmt *compiledStatement;
			
			if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
				
				// Bind query objects to prepared statement
				sqlite3_bind_text(compiledStatement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
				
				// Loop through the results and add them to the feeds array
				
				//	NSLog(compiledStatement);
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
					
					// Read the data from the result row
					NSString *qkeyR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
					NSString *qcodeR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]; 
					NSString *questionR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
					NSString *qopt1R = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
					NSString *qopt2R = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
					NSString *qopt3R = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
					NSString *qopt4R = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
					NSString *qsolR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
					
					// Create a new building object with the data from the database
					Questions *row = [[Questions alloc] initWithPkey:qkeyR 
																code:qcodeR 
															question:questionR 
															 option1:qopt1R 
															 option2:qopt2R 
															 option3:qopt3R 
															 option4:qopt4R 
															solution:qsolR];					
					// Add the building object to the buildings Array
					[results addObject:row];
					//[row release];
				}
			}
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
			
		}
		sqlite3_close(database);
	}
	@catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	}
	@finally {
		NSLog(@"finally");
	}
	
	return results;
	
}

- (NSMutableArray *)getCluesForCode:(NSString *)code {
	// Init the results array
	NSMutableArray* results = [[[NSMutableArray alloc] init] autorelease];
	
	//initialisation before reading the database
	databaseName = @"buildingsList.sql";
	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
																 NSUserDomainMask, 
																 YES);
	NSString* documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Setup the database object
	sqlite3 *database;
	
	@try {
		// Open the database from the users filessytem
		if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			// Setup the SQL Statement and compile it for faster access
			const char *sqlStatement = "select * from buildingsPath WHERE dcode = ?";
			
			sqlite3_stmt *compiledStatement;
			
			if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
				
				// Bind query objects to prepared statement
				sqlite3_bind_text(compiledStatement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
				
				// Loop through the results and add them to the feeds array
				
				//	NSLog(compiledStatement);
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
					
					// Read the data from the result row
					NSString *cKeyR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
					NSString *scodeR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]; 
					NSString *dcodeR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
					NSString *cTypeOneR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
					NSString *cTypeTwoR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
					NSString *cTypeThreeR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
					NSString *cValOneR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
					NSString *cValTwoR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
					NSString *cValThreeR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
					
					// Create a new building object with the data from the database
					Clues *row = [[Clues alloc] initWithPkey:cKeyR 
													   scode:scodeR 
													   dcode:dcodeR 
													cTypeOne:cTypeOneR 
													cTypeTwo:cTypeTwoR 
												  cTypeThree:cTypeThreeR 
													 cValOne:cValOneR 
													 cValTwo:cValTwoR 
												   cValThree:cValThreeR];
					// Add the building object to the buildings Array
					[results addObject:row];
					//[row release];
				}
			}
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
			
		}
		sqlite3_close(database);
	}
	@catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	}
	@finally {
		NSLog(@"finally");
	}
	
	return results;
}

- (NSString *)getNameForCode:(NSString *)dest{
	
	NSString *destName = [[[NSString alloc] init] autorelease];
	
	//initialisation before reading the database
	databaseName = @"buildingsList.sql";
	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
																 NSUserDomainMask, 
																 YES);
	NSString* documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Setup the database object
	sqlite3 *database;
	
	@try {
		// Open the database from the users filesystem
		if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			// Setup the SQL statement and compile it for faster access
			const char *sqlStatement = "select name from buildingsList where code = ?";
			
			sqlite3_stmt *compiledStatement;
			
			if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
				
				// Bind query object to prepared statement
				sqlite3_bind_text(compiledStatement, 1, [dest UTF8String], -1, SQLITE_TRANSIENT);
				
				// Loop through the results and add them to the feeds array
				while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
					
					// Read the data from the result row
					destName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				}
			}
			
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
		}
		
		sqlite3_close(database);
	}
	@catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	}
	
	return destName;
}

@end
