//
//  NXTMoterSpeedCalc.m
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NXTMoterSpeedCalc.h"


@implementation NXTMoterSpeedCalc

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (NXTMotorSpeed) CalcMotorSpeed:(WiiBoardPos)wiiBoardPos
{
    NXTMotorSpeed nxtMotorSpeed;
    int velocityA;
    int velocityB;
    float weight = wiiBoardPos.Weight - 10.0;
    
    switch (wiiBoardPos.Q) {
        case Idle:
            velocityA = 0;
            velocityB = 0;
            break;
        case Straight:
            if(wiiBoardPos.Y > 0)
            {
                velocityA = wiiBoardPos.Y;//(yPos - idle.Upper);
                velocityB = wiiBoardPos.Y;//(yPos - idle.Upper);
            }
            else
            {
                velocityA = wiiBoardPos.Y;//(yPos - idle.Lower);
                velocityB = wiiBoardPos.Y;//(yPos - idle.Lower);
            }
            break;
        case Turn:
            if(wiiBoardPos.X > 0 && wiiBoardPos.Y > 0)
            {
                //Top right
                velocityA = (float)wiiBoardPos.Y * ((((float)(weight-wiiBoardPos.X))/weight)/ 1.5);
                velocityB = wiiBoardPos.Y;
            }
            else if(wiiBoardPos.X > 0 && wiiBoardPos.Y < 0)
            {
                //Buttom right
                velocityA = (float)wiiBoardPos.Y * (1.0-(((float)(wiiBoardPos.X))/weight));
                velocityB = wiiBoardPos.Y;    
            }
            else if(wiiBoardPos.X < 0 && wiiBoardPos.Y > 0)
            {
                //Top left
                velocityA = wiiBoardPos.Y;
                velocityB = (float)wiiBoardPos.Y * ((((float)(weight+wiiBoardPos.X*2))/weight) / 1.5);
            }
            else if(wiiBoardPos.X < 0 && wiiBoardPos.Y < 0)
            {
                //Buttom left
                velocityA = wiiBoardPos.Y;
                velocityB = (float)wiiBoardPos.Y * (1.0+(((float)(wiiBoardPos.X))/weight));
            }
            break;
        case Rotate:
            velocityA = - wiiBoardPos.X;
            velocityB = wiiBoardPos.X;
            break;
            
        default:
            break;
    }
    
    nxtMotorSpeed.MotorSpeedA = velocityA * 2;
    nxtMotorSpeed.MotorSpeedB = velocityB * 2;
    
    return nxtMotorSpeed;
}

@end
