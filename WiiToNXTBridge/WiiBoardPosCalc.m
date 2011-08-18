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
        straightForward.Right   = 7;
        straightForward.Left    = -7;
        straightForward.Upper   = 1000;
        straightForward.Lower   = 10;
        
        straightBackward.Right  = 7;
        straightBackward.Left   = -7;
        straightBackward.Upper  = -10;
        straightBackward.Lower  = -1000;
        
        rotateLeft.Right        = -10;
        rotateLeft.Left         = -1000;
        rotateLeft.Upper        = 10;
        rotateLeft.Lower        = -10;
        
        rotateRight.Right       = 1000;
        rotateRight.Left        = 10;
        rotateRight.Upper       = 10;
        rotateRight.Lower       = -10;
        
        idle.Right              = 10;
        idle.Left               = -10;
        idle.Upper              = 10;
        idle.Lower              = -10;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (WiiBoardPos) GetWiiBoardPosition:(int)topRight 
                         pressureTL:(int)topLeft 
                         pressureBR:(int)buttomRight 
                         pressureBL:(int)buttomLeft
{
    WiiBoardPos wiiboardPos;
    
    /* Center Of Gravity Widget logic */
    int x = (topRight + buttomRight) - (topLeft + buttomLeft);
    int y = (topLeft + topRight) - (buttomLeft + buttomRight);
    int weight = (topRight + buttomRight + topLeft + buttomLeft);
    
    wiiboardPos.X = x;
    wiiboardPos.Y = y;
    wiiboardPos.Weight = weight;
    
    if([self IsWithinIdleArea:x y:y])
    {
        wiiboardPos.Q = Idle;
    }
    else if([self IsWithinRotateLeftArea:x y:y])
    {
        wiiboardPos.Q = Rotate;
    }
    else if([self IsWithinRotateRightArea:x y:y])
    {
        wiiboardPos.Q = Rotate;
    }
    else if([self IsWithinStraightForwardArea:x y:y])
    {
        wiiboardPos.Q = Straight;
    }
    else if([self IsWithinStraightBackwardArea:x y:y])
    {
        wiiboardPos.Q = Straight; 
    }
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
    
    if (yPos < boundaries.Lower) 
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

- (BOOL) IsWithinRotateLeftArea:(int)xPos y:(int)yPos
{
    return [self IsWithinArea:xPos y:yPos area:rotateLeft];
}

- (BOOL) IsWithinRotateRightArea:(int)xPos y:(int)yPos
{
    return [self IsWithinArea:xPos y:yPos area:rotateRight];
}

- (BOOL) IsWithinStraightForwardArea:(int)xPos y:(int)yPos
{
    return [self IsWithinArea:xPos y:yPos area:straightForward];
}

- (BOOL) IsWithinStraightBackwardArea:(int)xPos y:(int)yPos
{
    return [self IsWithinArea:xPos y:yPos area:straightBackward];
}

@end
