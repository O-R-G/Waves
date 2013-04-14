//
//  WavesFormDef.m
//  Waves
//
//  Created by e on 2/24/13.
//  Copyright (c) 2013 waves. All rights reserved.
//



#import "WaveFormDef.h"



@implementation WaveFormDef
@synthesize hz;
@synthesize amp;
@synthesize res;
@synthesize hzLength;
@synthesize color;

int *a;  // holders for x and y
int *b;
//int x;
//int y;


- (id) init
{
 
    return[self initWithHz:1.f withAmp:1 withHzLength:72.f];
    
}

// init the object using a definition of a standard 1 hz length
- (id) initWithHz:(float)aHz withAmp:(float)aAmp withHzLength:(float)aHzLength
{
    self.hz = aHz;      // frequency of wave in HZ
    self.amp = aAmp;    // Y amplitude of wave (standard amplitude is 1) as a multiplier of natural wave height

    self.hzLength = aHzLength;  // number of pixels in 1 hz wavelength (ie the px width of 2*PI)
    
    self.waveHeight = aHzLength / (2.f * M_PI);  //the natural px height of the wave derived from the hzLength
    
    self.sinOffset = 0.0;       // offset of wave pos
    
    self.color =  CGColorCreateGenericRGB(1, 1, 1, 1);
    
    return self;
    
}

// init the object using with a wave length instead of the herzlength
// here the height is determined from the wavelength instead of the hzlength
- (id) initWithHz:(float)aHz withAmp:(float)aAmp withWaveLength:(float)aWaveLength
{
    self.hz = aHz;      // frequency of wave in HZ
    self.amp = aAmp;    // Y amplitude of wave (standard amplitude is 1) as a multiplier of natural wave height
    
    self.hzLength = aWaveLength * aHz;  // number of pixels in 1 hz wavelength (ie the px width of 2*PI)
    
    self.waveHeight = aWaveLength / (2.f * M_PI);  //the natural px height of the wave derived from the hzLength
    
    self.sinOffset = 0.0;       // offset of wave pos
    
    self.color =  CGColorCreateGenericRGB(1, 1, 1, 1);

    return self;
    
}

// returns the x,y position of the sin of a number between 0 and 2(PI)
// 
- (NSPoint) findPointAt:(float)pos xOffset:(float)aXOffset yOffset:(float)aYOffset
{
    // find position in standard period
    float wavePos = pos / ((2.f) * M_PI);
    
    // adjust for frequency
    float ptX = (wavePos * hzLength);
    
    // find Y position
    //    ptY = sin(  ( position + offset  ) * hz ) * amp * (
    float ptY = sinf( (pos + self.sinOffset) * hz ) * amp * self.waveHeight;
    
    
    return NSMakePoint(ptX + aXOffset, ptY + aYOffset);
    
}
 
- (void)setSinOffset:(float)newSinOffset{
    
    // since sin ranges from 0 to 2*PI, prevent float overflow by reseting value
    if(newSinOffset > (2.f * M_PI)){
        _sinOffset = newSinOffset - ((2.f * M_PI)/self.hz);
    } else if (newSinOffset < 0){
        _sinOffset = ((2.f * M_PI)/self.hz) + newSinOffset;
    } else {
        _sinOffset = newSinOffset;

    }
    //_sinOffset = newSinOffset;
    
}
- (float)sinOffset
{
    return(_sinOffset);
    
}

/*
- (void)setAxis:(int) newAxis
{
    if(newAxis == hAxis){
        a = &x;
        b = &y;
        
    } else {
        a = &y;
        b = &x;
        
    }
    
}
*/

@end


