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
    int velocityA;
    int velocityB;
    
    switch (quadrant) {
        case Idle:
            velocityA = 0;
            velocityB = 0;
            break;
        case Straight:
            if(yPos > 0)
            {
                velocityA = (yPos - idle.Upper) * 2;
                velocityB = (yPos - idle.Upper) * 2;
            }
            else
            {
                velocityA = (yPos - idle.Lower) * 2;
                velocityB = (yPos - idle.Lower) * 2;
            }
            break;
        case Turn:
            if(xPos > 0 && yPos > 0)
            {
                //Top right
                velocityA = (float)yPos * (((float)(80-xPos))/80.0);
                velocityB = yPos;
            }
            else if(xPos > 0 && yPos < 0)
            {
                //Buttom right
                velocityA = (float)yPos * (1.0-(((float)(xPos))/80.0));
                velocityB = yPos;    
            }
            else if(xPos < 0 && yPos > 0)
            {
                //Top left
                velocityA = yPos;
                velocityB = (float)yPos * (((float)(80+xPos))/80.0);
            }
            else if(xPos < 0 && yPos < 0)
            {
                //Buttom left
                velocityA = yPos;
                velocityB = (float)yPos * (1.0+(((float)(xPos))/80.0));
            }
            break;
        case Rotate:
            velocityA = - xPos;
            velocityB = xPos;
            break;
            
        default:
            break;
    }
    
    nxtMotorSpeed.MotorSpeedA = velocityA;
    nxtMotorSpeed.MotorSpeedB = velocityB;
    
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
