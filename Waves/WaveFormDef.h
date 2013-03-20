//
//  WaveFormDef.h
//  Waves
//
//  Created by e on 2/24/13.
//  Copyright (c) 2013 waves. All rights reserved.
//

#import <math.h>
#import <Foundation/Foundation.h>

#define hAxis 0
#define vAxis 1

@interface WaveFormDef : NSObject {
    float amp;  // amplitude as a fraction of hz (1 = 1/2 hz
    float hz; // frequency -
    float res;  // resolution - sample points per wavelength
    //int axis;   // 0 = horizontal, 1 = vertical axis
    float hzLength; //pixes per 1 hz
    float _sinOffset; //the sin value starting point offset (mostly for animation)

}

 - (void) setAxis:(int) newAxis;
 - (void) setSinOfset:(float) sinOffset;
 - (id) initWithHz:(float)aHz withAmp:(float)aAmp withHzLength:(float)aHzLength;
- (NSPoint) findPointAt:(float)pos xOffset:(float)aXOffset yOffset:(float)aYOffset;

@property float amp;
@property float hz;
@property float res;
@property int axis;
@property float hzLength;
@property float sinOffset;

@end


