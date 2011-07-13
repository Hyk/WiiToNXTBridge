//
//  TestButtonCounter.m
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestButtonCounter.h"
#import <LegoNXT/LegoNXT.h>
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

- (IBAction)doConnect:(id)sender
{
    NSBeep();
    NSLog(@"doConnect");
    
    
    
    //[connectMessage setStringValue:[NSString stringWithFormat:@"Connecting..."]];

    _nxt = [[NXT alloc] init];
    [_nxt connect:self];
    
    [_nxt setOutputState:kNXTMotorA power:100 mode:kNXTMotorOn regulationMode:kNXTRegulationModeMotorSpeed turnRatio:1 runState:kNXTMotorRunStateRunning tachoLimit:0];
    
    currentSpeedA = 0;
    currentSpeedB = 0;
    
    [labelText setStringValue:@"===== Connected to NXT før ====="];
    
    //setup timer event
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateMotorSpeedEvent:) userInfo:nil repeats:YES];
    
    [labelText setStringValue:@"===== Connected to NXT efter ====="];
    
}

- (IBAction)buttonPress:(id)sender 
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(expansionPortChanged:)
                                                 name:@"WiiRemoteExpansionPortChangedNotification"
                                               object:nil];
    

	//[self setupInitialKeyMappings];		
    
    
    NSBeep();
    [labelText setStringValue:@"Starting up connection..."];
    
    discovery = [[WiiRemoteDiscovery alloc] init];
	[discovery setDelegate:self];
    
    
    [discovery start];   
    
}


- (void)expansionPortChanged:(NSNotification *)nc{
    
	//[textView setString:[NSString stringWithFormat:@"%@\n===== Expansion port status changed. =====", [textView string]]];
	
	WiiRemote* tmpWii = (WiiRemote*)[nc object];
	
	// Check that the Wiimote reporting is the one we're connected to.
	if (![[tmpWii address] isEqualToString:[wii address]]){
		return;
	}
	
	// Set the view for the expansion port drawer.
	WiiExpansionPortType epType = [wii expansionPortType];
	switch (epType) 
    {
            
		case WiiNunchuk:
			//[epDrawer setContentView: nunchukView];
			//[epDrawer open];
            break;
            
		case WiiClassicController:
			//[epDrawer setContentView: ccView];
			//[epDrawer open];
            break;
            
		case WiiBalanceBoard:
			//[bbDrawer open];
            [labelText setStringValue:@"Connection Balanceboard."]; 
            break;
			
		case WiiExpNotAttached:
		default:
            [labelText setStringValue:@"Default."];
			//[epDrawer setContentView: nil];
			//[epDrawer close];
            
            
	}
	
	if ([wii isExpansionPortAttached]){
		[wii setExpansionPortEnabled:YES];
		NSLog(@"** Expansion Port Enabled");
	} else {
		[wii setExpansionPortEnabled:NO];
		NSLog(@"** Expansion Port Disabled");
	}	
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
    
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[mappingController setSelectionIndex:[[defaults objectForKey:@"selection"] intValue]];
    
    
	//NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
}

- (void) accelerationChanged:(WiiAccelerationSensorType)type accX:(unsigned short)accX accY:(unsigned short)accY accZ:(unsigned short)accZ{
    //NSLog(@"Acceleration changed A");
}

- (void) allPressureChanged:(WiiPressureSensorType)type bbData:(WiiBalanceBoardGrid) bbData bbDataInKg:(WiiBalanceBoardGrid) bbDataInKg {
	//This part is for writing data to a file.  Data is scaled to local gravitational acceleration and contains absolute local times.
	
	//[labelText setStringValue:@"===== Balance board test allpreacure ====="];
	
	//End of part for writing data to file.	
}





- (void) updateMotorSpeedEvent:(NSTimer*)thetimer
{
    NSLog(@"Adjusting motor speed");
    
    [_nxt moveServo:kNXTMotorA power:currentSpeedA tacholimit:0];
    
    [_nxt moveServo:kNXTMotorB power:currentSpeedB tacholimit:0];
}


- (void) pressureChanged:(WiiPressureSensorType)type pressureTR:(float) pressureTR pressureBR:(float) pressureBR 
              pressureTL:(float) pressureTL pressureBL:(float) pressureBL {
    
    //[labelText setStringValue:@"===== Balance board 1 ====="];
    
    NSLog([NSString stringWithFormat:@"%F", pressureTR]);
    
	if (type == WiiBalanceBoardPressureSensor){
        int weightR = (pressureTR - pressureBR);
        int weightL = (pressureTL - pressureBL);
        

        
        currentSpeedA = weightL * 2;
        currentSpeedB = weightR * 2;
        
        [labelText setStringValue: [NSString stringWithFormat:@"%d", weightL]];
        [textField setStringValue: [NSString stringWithFormat:@"%d", weightR]];
        
        //[bPressureTR setStringValue: [NSString stringWithFormat:@"%.2fkg", pressureTR]];
		//[bPressureBR setStringValue: [NSString stringWithFormat:@"%.2fkg", pressureBR]];
		//[bPressureTL setStringValue: [NSString stringWithFormat:@"%.2fkg", pressureTL]];
		//[bPressureBL setStringValue: [NSString stringWithFormat:@"%.2fkg", pressureBL]];
		//[bbQCView setValue:[NSNumber numberWithFloat: 0.1 + (pressureTR/5)] forInputKey:[NSString stringWithString:@"sizeTR"]];
		//[bbQCView setValue:[NSNumber numberWithFloat: 0.1 + (pressureBR/5)] forInputKey:[NSString stringWithString:@"sizeBR"]];
		//[bbQCView setValue:[NSNumber numberWithFloat: 0.1 + (pressureTL/5)] forInputKey:[NSString stringWithString:@"sizeTL"]];
		//[bbQCView setValue:[NSNumber numberWithFloat: 0.1 + (pressureBL/5)] forInputKey:[NSString stringWithString:@"sizeBL"]];
		
		//This part is for writing data to a file.  Data is scaled to local gravitational acceleration and contains absolute local times.
		
		//struct tm *t;
		//struct timeval tval;
		//struct timezone tzone;
		
		
		//gettimeofday(&tval, &tzone);
		//t = localtime(&(tval.tv_sec));
        
		
	
	}
}	


- (void) buttonChanged:(WiiButtonType)type isPressed:(BOOL)isPressed{
    [labelText setStringValue:@"===== Jubii button changed ====="];
    NSLog(@"Button changed");
    
    //id mappings = [mappingController selection];
	//id map = nil;
	if (type == WiiRemoteAButton)
    {
        NSLog(@"Button changed A");
        [labelText setStringValue:@"===== Button A Pressed ====="];
        
        //[_nxt startProgram:@"helloworld.rxe"];
        
        [_nxt playTone:1 duration:200];
        
        [_nxt messageWrite:1 message:@"Test" size:4];
        
    }
    else if(type == WiiRemoteUpButton)
    {
        [labelText setStringValue:@"===== Button Up Pressed ====="];
        
        
        //[_nxt moveServo:kNXTMotorA power:currentSpeed tacholimit:0];
                
        if(currentSpeedA < 100)
            currentSpeedA += 10;
        if(currentSpeedB < 100)
            currentSpeedB += 10;
        
    }
    else if(type == WiiRemoteDownButton)
    {
        [labelText setStringValue:@"===== Button Down Pressed ====="];
    
        //[_nxt moveServo:kNXTMotorA power:0 tacholimit:0];
        //currentSpeed = 0;

        
        if(currentSpeedA > -100)
            currentSpeedA -= 10;
        if(currentSpeedB > -100)
            currentSpeedB -= 10;
    }
    else if(type == WiiRemoteRightButton)
    {
        [labelText setStringValue:@"===== Button Right Pressed ====="];
        
        
    }
    else if(type == WiiRemoteLeftButton)
    {
        [labelText setStringValue:@"===== Button Left Pressed ====="];
        
        
    }
    else if(type == WiiRemoteBButton)
    {
        [labelText setStringValue:@"===== Button B Pressed ====="];
        
        [_nxt stopProgram];
    }
    [_nxt moveServo:kNXTMotorA power:currentSpeedA tacholimit:0];
    
    [_nxt moveServo:kNXTMotorB power:currentSpeedB tacholimit:0];
}

@end
