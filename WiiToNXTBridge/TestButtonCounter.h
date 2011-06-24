//
//  TestButtonCounter.h
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TestButtonCounter : NSView {
@private
    
    NSTextField *textField;
    NSTextField *labelText;
}

@property (assign) IBOutlet NSTextField *textField;

@property (assign) IBOutlet NSTextField *labelText;

- (IBAction)buttonPress:(id)sender;

@end
