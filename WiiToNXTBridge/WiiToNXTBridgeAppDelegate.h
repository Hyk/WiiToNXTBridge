//
//  WiiToNXTBridgeAppDelegate.h
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WiiRemote/WiiRemote.h>
#import <WiiRemote/WiiRemoteDiscovery.h>

@interface WiiToNXTBridgeAppDelegate : NSObject <NSApplicationDelegate> {
    
    WiiRemoteDiscovery *discovery;
	WiiRemote* wii;
    
    
@private
    int counter;
    NSWindow *window;
    NSTextField *labelT;
}

@property (assign) IBOutlet NSWindow *window;
//- (IBAction)buttonP:(id)sender;
@property (assign) IBOutlet NSTextField *labelT;


/*
#pragma mark -
#pragma mark WiiRemoteDiscovery delegates

- (void) willStartWiimoteConnections;
*/
@end
