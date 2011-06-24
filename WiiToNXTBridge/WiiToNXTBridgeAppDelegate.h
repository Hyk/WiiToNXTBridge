//
//  WiiToNXTBridgeAppDelegate.h
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WiiToNXTBridgeAppDelegate : NSObject <NSApplicationDelegate> {
@private
    int counter;
    NSWindow *window;
    NSTextField *labelT;
}

@property (assign) IBOutlet NSWindow *window;
- (IBAction)buttonP:(id)sender;
@property (assign) IBOutlet NSTextField *labelT;

@end
