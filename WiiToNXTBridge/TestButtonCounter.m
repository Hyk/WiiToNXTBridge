//
//  TestButtonCounter.m
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestButtonCounter.h"


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
    [labelText setStringValue:@"2"];
}

- (IBAction)buttonPress:(id)sender 
{
    NSBeep();
    [labelText setStringValue:@"2"];
}

@end
