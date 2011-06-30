//
//  TestButtonCounter.m
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestButtonCounter.h"
#import <WiiRemote/WiiRemote.h>
#import <WiiRemote/WiiRemoteDiscovery.h>

@implementation TestButtonCounter
@synthesize textField;
@synthesize labelText;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [textField release];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    //[labelText setStringValue:@"Press the button to connect to the Wii remote."];
}

- (IBAction)buttonPress:(id)sender 
{
    NSBeep();
    [labelText setStringValue:@"Starting up connection..."];
    
    discovery = [[WiiRemoteDiscovery alloc] init];
	[discovery setDelegate:self];
    
    
    [discovery start];    
}

#pragma mark -
#pragma mark WiiRemoteDiscovery delegates

- (void) WiiRemoteDiscoveryError:(int)code {
	//[discoverySpinner stopAnimation:self];
    
    [labelText setStringValue:@"Fejl"];
}

- (void) willStartWiimoteConnections {
    [labelText setStringValue:@"Opening connection."];
}


- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote {
	
	//	[discovery stop];
	
	// the wiimote must be retained because the discovery provides us with an autoreleased object
	wii = [wiimote retain];
	[wiimote setDelegate:self];
	
    [labelText setStringValue:@"===== Connected to WiiRemote ====="];
	
	[wiimote setLEDEnabled1:YES enabled2:NO enabled3:NO enabled4:NO];
    
	[wiimote setMotionSensorEnabled:YES];
    
	//NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
}

- (void) buttonChanged:(WiiButtonType)type isPressed:(BOOL)isPressed{
    [labelText setStringValue:@"===== Jubii button changed ====="];
    NSLog(@"Button changed");
}

@end
