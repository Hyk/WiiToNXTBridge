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

- (NXTMotorSpeed) ConvertPressurePointsToSpeed:(int)topRight pressureTL:(int)topLeft pressureBR:(int)buttomRight pressureBL:(int)buttomLeft
{
    NSLog(@"===== ConvertPressurePointsToSpeed=====");
    WiiBoardPos wiiboardPos;
    NXTMotorSpeed nxtMotorSpeed;
    
    NSLog(@"topRight");
    NSLog([NSString stringWithFormat:@"%d", topRight]);
    
    /* Center Of Gravity Widget logic */
    int x = (topRight + buttomRight) - (topLeft + buttomLeft);
    int y = (topLeft + topRight) - (buttomLeft + buttomRight);
    //int weight = (topRight + buttomRight + topLeft + buttomLeft);

    NSLog(@"xPos");
    NSLog([NSString stringWithFormat:@"%d", x]);
    
    wiiboardPos.X = x;
    wiiboardPos.Y = y;
    
    //NSLog([NSString stringWithFormat:@"%dTest xPos", x]);
    //NSLog([NSString stringWithFormat:@"%dTest yPos", y]);
    NSLog(@"X");
    NSLog([NSString stringWithFormat:@"%d", x]);
    NSLog(@"Y");
    NSLog([NSString stringWithFormat:@"%d", y]);
    
    
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
    
    NSLog(@"Quadrant");
    NSLog([NSString stringWithFormat:@"%d", wiiboardPos.Q]);
    
    nxtMotorSpeed = [self CalcMotorSpeed:x y:y Q:wiiboardPos.Q];
    
    return nxtMotorSpeed;
}

- (NXTMotorSpeed) CalcMotorSpeed:(int)xPos y:(int)yPos Q:(Quadrant)quadrant
{
    NXTMotorSpeed nxtMotorSpeed;
    
    switch (quadrant) {
        case Idle:
            nxtMotorSpeed.MotorSpeedA = 0;
            nxtMotorSpeed.MotorSpeedB = 0;
            break;
        case Straight:
            nxtMotorSpeed.MotorSpeedA = yPos * 2;
            nxtMotorSpeed.MotorSpeedB = yPos * 2;
            break;
        case Turn:
            nxtMotorSpeed.MotorSpeedA = (xPos/yPos);
            nxtMotorSpeed.MotorSpeedB = xPos;
            break;
        case Rotate:
            nxtMotorSpeed.MotorSpeedA = xPos * 2;
            nxtMotorSpeed.MotorSpeedB = - xPos * 2;
            break;
            
        default:
            break;
    }
    
    return nxtMotorSpeed;
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