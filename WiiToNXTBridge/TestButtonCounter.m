//
//  TestButtonCounter.m
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestButtonCounter.h"
#import "WiiBoardPosCalc.h"
#import <LegoNXT/LegoNXT.h>
#import <WiiRemote/WiiRemote.h>
#import <WiiRemote/WiiRemoteDiscovery.h>

@implementation TestButtonCounter
@synthesize g_InfoLabel;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [textField release];
    [m_NxtMoterCalc release];
    [m_WiiBoardCalc release];
    [m_WiiRemote release];
    [m_NXT release];
    [m_WiiDiscovery release];
    
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    //[labelText setStringValue:@"Press the button to connect to the Wii remote."];
}


/******************************************************
 //
 // Handles the click event on the g_NXTConnectionButton. 
 // The function establishes the connection to the NXT and
 // starts the timer that updates the motor speed continiously
 // 
 *******************************************************/
- (IBAction)connectToNXTButtonPressed:(id)sender
{
    NSBeep();
    NSLog(@"doConnect");
    
    m_NXT = [[NXT alloc] init];
    [m_NXT connect:self];
    
    [m_NXT setOutputState:kNXTMotorA power:100 mode:kNXTMotorOn regulationMode:kNXTRegulationModeMotorSpeed turnRatio:1 runState:kNXTMotorRunStateRunning tachoLimit:0];
    
    currentSpeedA = 0;
    currentSpeedB = 0;
    
    //setup timer event
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateMotorSpeedEvent:) userInfo:nil repeats:YES];
}


/******************************************************
 //
 // Handles the click event on the g_WiiConnectionButton. 
 // The function establishes the connection to the Wii board
 // 
*******************************************************/ 
- (IBAction)connectToWiiButtonPressed:(id)sender 
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(expansionPortChanged:)
                                                 name:@"WiiRemoteExpansionPortChangedNotification"
                                               object:nil];
    		
    
    [g_InfoLabel setStringValue:@"Starting up connection..."];
    
    m_WiiDiscovery = [[WiiRemoteDiscovery alloc] init];
	[m_WiiDiscovery setDelegate:self];
    
    [m_WiiDiscovery start];
}


- (void)expansionPortChanged:(NSNotification *)nc{
    
	//[textView setString:[NSString stringWithFormat:@"%@\n===== Expansion port status changed. =====", [textView string]]];
	
	WiiRemote* tmpWii = (WiiRemote*)[nc object];
	
	// Check that the Wiimote reporting is the one we're connected to.
	if (![[tmpWii address] isEqualToString:[m_WiiRemote address]]){
		return;
	}
	
	// Set the view for the expansion port drawer.
	WiiExpansionPortType epType = [m_WiiRemote expansionPortType];
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
            [g_InfoLabel setStringValue:@"Connection Balanceboard."]; 
            break;
			
		case WiiExpNotAttached:
		default:
            [g_InfoLabel setStringValue:@"Default."];
			//[epDrawer setContentView: nil];
			//[epDrawer close];
            
            
	}
	
	if ([m_WiiRemote isExpansionPortAttached]){
		[m_WiiRemote setExpansionPortEnabled:YES];
		NSLog(@"** Expansion Port Enabled");
	} else {
		[m_WiiRemote setExpansionPortEnabled:NO];
		NSLog(@"** Expansion Port Disabled");
	}	
}


/******************************************************
 //
 // The function is called continuosly by the timer event set
 // in the connectToWiiButtonPressed function.
 // It calculates the motor speed from the current pressure sensor
 // values from the Wii board. Also the connection image is shown.
 // 
 *******************************************************/
- (void) updateMotorSpeedEvent:(NSTimer*)thetimer
{
    NSLog(@"Adjusting motor speed");
    
    //Enable connected image
    if([m_NXT isConnected])
    {
        [g_NxtConnOkImage setHidden:FALSE];
    }
    
    //Get the wii board position
    WiiBoardPos wiiBoardPos = [m_WiiBoardCalc GetWiiBoardPosition:currentPresureTR pressureTL:currentPresureTL pressureBR:currentPresureBR pressureBL:currentPresureBL];
    
    //Calculate the speed of the motors from the wii board position
    NXTMotorSpeed nxtMotorSpeed = [m_NxtMoterCalc CalcMotorSpeed:wiiBoardPos];
    
    //Set the motor speeds on the NXT
    [m_NXT moveServo:kNXTMotorA power:nxtMotorSpeed.MotorSpeedA tacholimit:0];
    [m_NXT moveServo:kNXTMotorB power:nxtMotorSpeed.MotorSpeedB tacholimit:0];
}


#pragma mark -
#pragma mark WiiRemoteDiscovery delegates

/******************************************************
 //
 // The function is called continuosly from the wii framework.
 // It sets the nxt button as enabled and shows the connected
 // image. Furthermore the current pressure sensors are updated.
 // 
 *******************************************************/
- (void) pressureChanged:(WiiPressureSensorType)type 
              pressureTR:(float) pressureTR 
              pressureBR:(float) pressureBR 
              pressureTL:(float) pressureTL 
              pressureBL:(float) pressureBL 
{
    //Enable the "check" image on the wii board
    if([g_WiiConnOkImage isHidden])
    {
        [g_WiiConnOkImage setHidden:FALSE];
    }
    
    if([g_NXTConnectButton isEnabled] == FALSE)
    {
        [g_NXTConnectButton setEnabled:TRUE];
    }
    
    //Save the current pressure states
    if (type == WiiBalanceBoardPressureSensor)
    {   
        currentPresureBL = pressureBL;
        currentPresureBR = pressureBR;
        currentPresureTL = pressureTL;
        currentPresureTR = pressureTR;
	}
}


/******************************************************
 //
 // The function is called if for some reason the connection
 // to the Wii board did not succed.
 // 
 *******************************************************/
- (void) WiiRemoteDiscoveryError:(int)code 
{
	//[discoverySpinner stopAnimation:self];
    
    [g_InfoLabel setStringValue:@"Fejl"];
}


/******************************************************
 //
 // The function is called by the wii conponent when it 
 // starts to connect to the wii board.
 // 
 *******************************************************/
- (void) willStartWiimoteConnections 
{
    [g_InfoLabel setStringValue:@"Opening connection."];
}


/******************************************************
 //
 // Called when the wii board is found.
 // The function establishes the connection to the Wii board
 // 
 *******************************************************/
- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote {
	
    [m_WiiDiscovery stop];
	
	// the wiimote must be retained because the discovery provides us with an autoreleased object
	m_WiiRemote = [wiimote retain];
	[wiimote setDelegate:self];
	
	[wiimote setLEDEnabled1:YES enabled2:NO enabled3:NO enabled4:NO];
    
	[wiimote setMotionSensorEnabled:YES];
    
    //Create calculators
    m_WiiBoardCalc = [[WiiBoardPosCalc alloc] init];
    m_NxtMoterCalc = [[NXTMoterSpeedCalc alloc] init];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[mappingController setSelectionIndex:[[defaults objectForKey:@"selection"] intValue]];
    
	//NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
}


/******************************************************
 //
 // Dummy function used when testing
 // 
 *******************************************************/
- (void) accelerationChanged:(WiiAccelerationSensorType)type 
                        accX:(unsigned short)accX 
                        accY:(unsigned short)accY 
                        accZ:(unsigned short)accZ
{
    //NSLog(@"Acceleration changed A");
}

/******************************************************
 //
 // Dummy function used when testing
 // 
 *******************************************************/
- (void) allPressureChanged:(WiiPressureSensorType)type 
                     bbData:(WiiBalanceBoardGrid) bbData 
                 bbDataInKg:(WiiBalanceBoardGrid) bbDataInKg 
{
	//This part is for writing data to a file.  Data is scaled to local gravitational acceleration and contains absolute local times.
	
	//[labelText setStringValue:@"===== Balance board test allpreacure ====="];
	
	//End of part for writing data to file.	
}	


/******************************************************
 //
 // Dummy function used when testing
 // 
 *******************************************************/
- (void) buttonChanged:(WiiButtonType)type 
             isPressed:(BOOL)isPressed
{
    [g_InfoLabel setStringValue:@"===== Jubii button changed ====="];
    NSLog(@"Button changed");
    
    //id mappings = [mappingController selection];
	//id map = nil;
	if (type == WiiRemoteAButton)
    {
        NSLog(@"Button changed A");
        [g_InfoLabel setStringValue:@"===== Button A Pressed ====="];
        
        //[_nxt startProgram:@"helloworld.rxe"];
        
        [m_NXT playTone:1 duration:200];
        
        [m_NXT messageWrite:1 message:@"Test" size:4];
        
    }
    else if(type == WiiRemoteUpButton)
    {
        [g_InfoLabel setStringValue:@"===== Button Up Pressed ====="];
        
        
        //[_nxt moveServo:kNXTMotorA power:currentSpeed tacholimit:0];
                
        if(currentSpeedA < 100)
            currentSpeedA += 10;
        if(currentSpeedB < 100)
            currentSpeedB += 10;
        
    }
    else if(type == WiiRemoteDownButton)
    {
        [g_InfoLabel setStringValue:@"===== Button Down Pressed ====="];
    
        //[_nxt moveServo:kNXTMotorA power:0 tacholimit:0];
        //currentSpeed = 0;

        
        if(currentSpeedA > -100)
            currentSpeedA -= 10;
        if(currentSpeedB > -100)
            currentSpeedB -= 10;
    }
    else if(type == WiiRemoteRightButton)
    {
        [g_InfoLabel setStringValue:@"===== Button Right Pressed ====="];
        
        
    }
    else if(type == WiiRemoteLeftButton)
    {
        [g_InfoLabel setStringValue:@"===== Button Left Pressed ====="];
        
        
    }
    else if(type == WiiRemoteBButton)
    {
        [g_InfoLabel setStringValue:@"===== Button B Pressed ====="];
        
        [m_NXT stopProgram];
    }
    [m_NXT moveServo:kNXTMotorA power:currentSpeedA tacholimit:0];
    
    [m_NXT moveServo:kNXTMotorB power:currentSpeedB tacholimit:0];
}

@end
