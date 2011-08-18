//
//  NXTMoterSpeedCalc.h
//  WiiToNXTBridge
//
//  Created by Henrik Hykkelbjerg on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WiiBoardPosCalc.h"

typedef struct nxtMotorSpeed
{
    int MotorSpeedA;
    int MotorSpeedB;
} NXTMotorSpeed;

@interface NXTMoterSpeedCalc : NSObject 
{
@private
    
}
- (NXTMotorSpeed) CalcMotorSpeed:(WiiBoardPos)wiiBoardPos;
@end
