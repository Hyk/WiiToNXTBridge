//
//  TestButtonCounter.h
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <LegoNXT/LegoNXT.h>
#import "WiiBoardPosCalc.h"
#import <WiiRemote/WiiRemote.h>
#import <WiiRemote/WiiRemoteDiscovery.h>

@interface TestButtonCounter : NSView {
    //IBOutlet KeyConfiguration_AppDelegate* appDelegate;
	IBOutlet NSArrayController* mappingController;
    IBOutlet NSButton* aButton;
    
    //IBOutlet NXT *_nxt;
    //IBOutlet NSLevelIndicator *batteryLevelIndicator;
    //IBOutlet NSTextField *connectMessage;
    
    IBOutlet NSButton *connectButton;
    
@private
    WiiRemoteDiscovery *discovery;
	WiiRemote* wii;
    NXT* _nxt;
    WiiBoardPosCalc* _wii;
    
    int currentSpeedA;
    int currentSpeedB;
    int currentPresureTR;
    int currentPresureTL;
    int currentPresureBR;
    int currentPresureBL;
    
    
    int wiiboardPosX;
    int wiiboardPosY;
    
    //bounderies
    
    NSTextField *textField;
    NSTextField *labelText;
}

- (IBAction)doConnect:(id)sender;
    

@property (assign) IBOutlet NSTextField *textField;

@property (assign) IBOutlet NSTextField *labelText;

- (IBAction)buttonPress:(id)sender;
- (void) updateMotorSpeedEvent:(NSTimer*)thetimer;

#pragma mark -
#pragma mark WiiRemoteDiscovery delegates

- (void) willStartWiimoteConnections;

@end
