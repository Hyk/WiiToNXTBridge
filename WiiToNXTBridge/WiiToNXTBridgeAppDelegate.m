//
//  WiiToNXTBridgeAppDelegate.m
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WiiToNXTBridgeAppDelegate.h"

@implementation WiiToNXTBridgeAppDelegate
@synthesize labelT;

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    counter = 0;
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
}
@end
