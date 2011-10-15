//
//  MyAppDelegate.mm
//  CCGLTouchSplitView example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//

#import "MyAppDelegate.h"


@implementation MyAppDelegate

- (void)launch
{    
	// OpenGL View
	MyCinderGLView *aView = [[MyCinderGLView alloc] init];
	glView = aView;
	[aView release];
	glView = [[MyCinderGLView alloc] initWithFrame:CGRectMake(0.0, 44.0, (float)[UIScreen mainScreen].bounds.size.width, (float)[UIScreen mainScreen].bounds.size.height-44.0)];//[UIScreen mainScreen].bounds];
	[[detailViewController view] addSubview:glView];
	
    // set Detail View Controller's prop
    [detailViewController setGLView:glView];
    
    
    // use splitViewController as the root view controller
    super.window.rootViewController = splitViewController;
}

- (void)dealloc
{
    [detailViewController release];
    [rootViewController release];
    [glView release];
    [splitViewController release];
    [super dealloc];
}

@end