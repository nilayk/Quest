//
//  musicPlayer.m
//  Quest
//
//  Created by Siddharth Gami on 4/26/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "MusicPlayer.h"


@implementation MusicPlayer

@synthesize playSwitch,player,picker, selectPlaylist;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	//[playSwitch insertSegmentWithImage:[UIImage imageNamed:@"up_button.png"] atIndex:0 animated:YES];
	//[playSwitch insertSegmentWithImage:[UIImage imageNamed:@"down_button.png"] atIndex:1 animated:YES];
	//playSwitch.segmentedControlStyle = UISegmentedControlStyleBar;
	//playSwitch.tintColor = [UIColor brownColor];
	//playSwitch.frame = CGRectMake(40, 200, 240, 60);
	//[playSwitch setMomentary:YES];
	
	player = [MPMusicPlayerController iPodMusicPlayer];
	picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
	picker.delegate = self;
	[playSwitch addTarget:self action:@selector(playPauseMusic:) forControlEvents:UIControlEventValueChanged];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) loadPlaylist:(id)sender {
	[self presentModalViewController:picker animated:YES];
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
	[player setQueueWithItemCollection:mediaItemCollection];
	[self dismissModalViewControllerAnimated:YES];
	[player play];
	playSwitch.selectedSegmentIndex = 0;
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
	[self dismissModalViewControllerAnimated:YES];
	playSwitch.selectedSegmentIndex = 1;
}

- (void)playPauseMusic:(id)sender{
	if(playSwitch.selectedSegmentIndex == 0)
	{
		[player play];
	}
	else if(playSwitch.selectedSegmentIndex == 1)
		[player pause];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
