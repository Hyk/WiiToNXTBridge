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
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
