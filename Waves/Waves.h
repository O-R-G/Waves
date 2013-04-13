//
//  Waves.h
//  Waves
//
//  Created by e on 2/21/13.
//  Copyright (c) 2013 waves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#import "WaveFormDef.h"

static const NSTimeInterval  kScheduledTimerInSeconds      = 1.0f/30.0f;


@interface Waves : NSView{
    
 
    NSTimer            *timer;						// timer to update the view content

}

- (void)start;
- (void)initUpdateTimer;
@end



