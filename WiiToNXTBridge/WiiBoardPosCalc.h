//
//  WiiBoardPosCalc.h
//  WiiToNXTBridge
//
//  Created by Rasmus Gulbaek on 13/07/11.
//  Copyright 2011 Gulbaek I/S. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct boundaries
{
    int Upper;
    int Lower;
    int Left;
    int Right;
}Boundaries;

typedef enum quadrant 
{
    Straight,
    Rotate,
    Idle,
    Turn
} Quadrant;

typedef struct wiiBoardPos
{
    int X;
    int Y;
    Quadrant Q;
} WiiBoardPos;

@interface WiiBoardPosCalc : NSObject 
{
@private
     Boundaries rotateRight, rotateLeft, straightForward, straightBackward, idle;
    
}


- (BOOL) IsWithinIdleArea: (int)xPos y:(int)yPos;
- (BOOL) IsWithinStraightForwardArea: (int)xPos y:(int)yPos;
- (BOOL) IsWithinStraingtBackwardArea: (int)xPos y:(int)yPos;
- (BOOL) IsWithinRotateLeftArea: (int)xPos y:(int)yPos;
- (BOOL) IsWithinRotateRightArea: (int)xPos y:(int)yPos;
- (BOOL) IsWithinArea: (int)xPos y:(int)yPos area:(Boundaries)boundaries;

- (WiiBoardPos) ConvertPressurePoints: (float) topRight pressureTL:(float)topLeft pressureBR:(float)buttomRight pressureBL:(float)buttomLeft;

@end
