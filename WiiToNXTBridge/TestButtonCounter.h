//
//  TestButtonCounter.h
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WiiRemote/WiiRemote.h>
#import <WiiRemote/WiiRemoteDiscovery.h>

@interface TestButtonCounter : NSView {
@private
    WiiRemoteDiscovery *discovery;
	WiiRemote* wii;
    
    NSTextField *textField;
    NSTextField *labelText;
}

@property (assign) IBOutlet NSTextField *textField;

@property (assign) IBOutlet NSTextField *labelText;

- (IBAction)buttonPress:(id)sender;

#pragma mark -
#pragma mark WiiRemoteDiscovery delegates

- (void) willStartWiimoteConnections;

@end
