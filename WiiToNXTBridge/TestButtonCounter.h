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
#import "NXTMoterSpeedCalc.h"
#import <WiiRemote/WiiRemote.h>
#import <WiiRemote/WiiRemoteDiscovery.h>

@interface TestButtonCounter : NSView 
{
	IBOutlet NSArrayController* mappingController;
    IBOutlet NSButton* g_WiiConnectButton;
    IBOutlet NSButton* g_NXTConnectButton;
    IBOutlet NSImageView* g_WiiConnOkImage;
    IBOutlet NSImageView* g_NxtConnOkImage;
    
@private
    WiiRemoteDiscovery* m_WiiDiscovery;
	WiiRemote* m_WiiRemote;
    NXT* m_NXT;
    WiiBoardPosCalc* m_WiiBoardCalc;
    NXTMoterSpeedCalc* m_NxtMoterCalc;
    
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
    NSTextField *g_InfoLabel;
}

@property (assign) IBOutlet NSTextField *g_InfoLabel;

- (IBAction)connectToNXTButtonPressed:(id)sender;
- (IBAction)connectToWiiButtonPressed:(id)sender;
- (void) updateMotorSpeedEvent:(NSTimer*)thetimer;

#pragma mark -
#pragma mark WiiRemoteDiscovery delegates

- (void) willStartWiimoteConnections;

@end
