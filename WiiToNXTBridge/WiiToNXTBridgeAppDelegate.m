//
//  WiiToNXTBridgeAppDelegate.m
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WiiToNXTBridgeAppDelegate.h"
#import <WiiRemote/WiiRemote.h>
#import <WiiRemote/WiiRemoteDiscovery.h>

@implementation WiiToNXTBridgeAppDelegate
@synthesize labelT;

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    counter = 0;
    
    discovery = [[WiiRemoteDiscovery alloc] init];
	[discovery setDelegate:self];
    // Insert code here to initialize your application
    
    // Ragsters comments is now gone.. gone I say :) :-)
    
    //Jubii virker stadig idag den 23/6-2011
}

- (IBAction)buttonP:(id)sender 
{
    counter++;
    NSString *msg1 = @"You have pressed the button ";
    NSString *msg2 = @" times.";
    NSString *counterAsString = [NSString stringWithFormat:@"%d", counter];
    
    NSString *hwString = [msg1 stringByAppendingString:counterAsString];
    hwString = [hwString stringByAppendingString:msg2];
    
    [labelT setStringValue:hwString];
    
    
    
    [discovery start];
	[labelT setStringValue:@"Please press 1 button and 2 button simultaneously"];
	//[discoverySpinner startAnimation:self];

    
    //[wii setLEDEnabled1:[led1 state] enabled2:[led2 state] enabled3:[led3 state] enabled4:[led4 state]];
    
}



#pragma mark -
#pragma mark WiiRemoteDiscovery delegates

- (void) WiiRemoteDiscoveryError:(int)code {
	//[discoverySpinner stopAnimation:self];
    
    [labelT setStringValue:@"Fejl"];
}

- (void) willStartWiimoteConnections {
    [labelT setStringValue:@"Opening connection."];
}


- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote {
	
	//	[discovery stop];
	
	// the wiimote must be retained because the discovery provides us with an autoreleased object
	wii = [wiimote retain];
	[wiimote setDelegate:self];
	
    [labelT setStringValue:@"===== Connected to WiiRemote ====="];
    
	//[discoverySpinner stopAnimation:self];
	
	[wiimote setLEDEnabled1:YES enabled2:NO enabled3:NO enabled4:NO];
	//[wiimoteQCView setValue:[NSNumber numberWithBool:[led1 state] ] forInputKey:[NSString stringWithString:@"LED_1"]];
    
	[wiimote setMotionSensorEnabled:YES];
    //	[wiimote setIRSensorEnabled:YES];
    
	//[graphView startTimer];
	//[graphView2 startTimer];
    
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	//[mappingController setSelectionIndex:[[defaults objectForKey:@"selection"] intValue]];
}



@end
