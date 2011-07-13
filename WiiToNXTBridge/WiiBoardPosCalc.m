//
//  WiiBoardPosCalc.m
//  WiiToNXTBridge
//
//  Created by Rasmus Gulbaek on 13/07/11.
//  Copyright 2011 Gulbaek I/S. All rights reserved.
//

#import "WiiBoardPosCalc.h"


@implementation WiiBoardPosCalc

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        straightForward.Right   = 2;
        straightForward.Left    = -2;
        straightForward.Upper   = 1000;
        straightForward.Lower   = 2;
        
        straightBackward.Right  = 2;
        straightBackward.Left   = -2;
        straightBackward.Upper  = -2;
        straightBackward.Lower  = -1000;
        
        rotateLeft.Right        = -2;
        rotateLeft.Left         = -1000;
        rotateLeft.Upper        = 2;
        rotateLeft.Lower        = -2;
        
        rotateRight.Right       = 1000;
        rotateRight.Left        = 2;
        rotateRight.Upper       = 2;
        rotateRight.Lower       = -2;
        
        idle.Right              = 2;
        idle.Left               = -2;
        idle.Upper              = 2;
        idle.Lower              = -2;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (WiiBoardPos) ConvertPressurePoints:(float)topRight pressureTL:(float)topLeft pressureBR:(float)buttomRight pressureBL:(float)buttomLeft
{
    WiiBoardPos wiiboardPos;
    
    /* Center Of Gravity Widget logic */
    int x = (topRight + buttomRight) - (topLeft + buttomLeft);
    int y = (topLeft + topRight) - (buttomLeft + buttomRight);
    int weight = (topRight + buttomRight + topLeft + buttomLeft);
    
    wiiboardPos.X = x;
    wiiboardPos.Y = y;
    
    if([self IsWithinIdleArea:x y:y])
    {
        wiiboardPos.Q = Idle;
    }
    else if([self IsWithinRotateLeftArea:x y:y])
    {
        wiiboardPos.Q = Rotate;
    }
    ...
    else
    {
        wiiboardPos.Q = Turn;
    }
    
    return wiiboardPos;
}

- (BOOL) IsWithinArea:(int)xPos y:(int)yPos area:(Boundaries)boundaries
{
    if (xPos < boundaries.Left) 
    {
        return FALSE;
    }
    
    if (xPos > boundaries.Right) 
    {
        return FALSE;
    }
    
    if (xPos < boundaries.Lower) 
    {
        return FALSE;
    }
    
    if (yPos > boundaries.Upper) 
    {
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL) IsWithinIdleArea:(int)xPos y:(int)yPos
{
    return [self IsWithinArea:xPos y:yPos area:idle];
}

- (BOOL) IsWithinRotateLeftArea:(int)xPos y:(int)yPos:(int)xPos y:(int)yPos
{
    return [self IsWithinArea:xPos y:yPos area:rotateLeft];
}

- (BOOL) IsWithinRotateRightArea:(int)xPos y:(int)yPos:(int)xPos y:(int)yPos
{
    return [self IsWithinArea:xPos y:yPos area:rotateRight];
}

- (BOOL) IsWithinStraightForwardArea:(int)xPos y:(int)yPos:(int)xPos y:(int)yPos
{
    return [self IsWithinArea:xPos y:yPos area:straightForward];
}

- (BOOL) IsWithinStraingtBackwardArea:(int)xPos y:(int)yPos:(int)xPos y:(int)yPos:(int)xPos y:(int)yPos
{
    return [self IsWithinArea:xPos y:yPos area:straightBackward];
}

@end
