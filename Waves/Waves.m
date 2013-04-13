//
//  Waves.m
//  Waves
//
//  Created by e on 2/21/13.
//  Copyright (c) 2013 waves. All rights reserved.
//

#import "Waves.h"



@interface Waves ()

@property (nonatomic, strong) CIImageAccumulator *imageAccumulator;
@property (nonatomic, strong) NSColor *color;
@property (nonatomic, strong) CIFilter *brushFilter;
@property (nonatomic, strong) CIFilter *compositeFilter;
@property (assign) CGFloat brushSize;

@end



@implementation Waves
{

    BOOL readyToDraw;
    WaveFormDef *Ala;
    WaveFormDef *Bsi;
    WaveFormDef *Cdo;
    WaveFormDef *Dre;
    WaveFormDef *Emi;
    WaveFormDef *Ffa;
    WaveFormDef *Gsol;
}


//---------------------------------------------------------------------------------

- (void) heartbeat
{
     [self animateMe];
     [self displayIfNeeded];
    
	//[self drawRect:[self bounds]];
} // heartbeat

//---------------------------------------------------------------------------------

- (void) initUpdateTimer
{
    /*
    CFRunLoopTimerContext loopContext = {0, self, NULL, NULL, NULL};
    timer = CFRunLoopTimerCreate(NULL, timeStamp, 1.0/[self desiredFrameRate], 0, 0, heartbeat, &loopContext);
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes);
*/
    
	timer = [NSTimer timerWithTimeInterval:kScheduledTimerInSeconds
									target:self
								  selector:@selector(heartbeat)
								  userInfo:nil
								   repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	
	//[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSEventTrackingRunLoopMode];
} // initUpdateTimer





/* *****************************
   Init function run once the view frame is loaded and visible
 ******************************* */
- (void)start
{
    
       
    /*
    Ala = [[WaveFormDef alloc ]initWithHz:2.2f withAmp:1.f withHzLength:700.f];
    Bsi = [[WaveFormDef alloc ]initWithHz:2.47f withAmp:1.12f withHzLength:700.f];
    Cdo = [[WaveFormDef alloc ]initWithHz:2.62f withAmp:1.19f withHzLength:700.f];
     */
    Ala = [[WaveFormDef alloc ]initWithHz:2.2f withAmp:1.f withWaveLength:157.f*2.f];
    Bsi = [[WaveFormDef alloc ]initWithHz:2.47f withAmp:1.f withWaveLength:140.f*2.f];
    Cdo = [[WaveFormDef alloc ]initWithHz:2.62f withAmp:1.f withWaveLength:132.f*2.f];
    Dre = [[WaveFormDef alloc ]initWithHz:2.94f withAmp:1.f withWaveLength:117.f*2.f];
    Emi = [[WaveFormDef alloc ]initWithHz:3.29f withAmp:1.f withWaveLength:105.f*2.f];
    Ffa = [[WaveFormDef alloc ]initWithHz:3.49f withAmp:1.f withWaveLength:98.8f*2.f];
    Gsol = [[WaveFormDef alloc ]initWithHz:3.92f withAmp:1.f withWaveLength:88.f*2.f];


	[self initUpdateTimer];
    

    
}


- (void) animateMe
{
       
    float offset = .015;
    
    Ala.sinOffset += offset;
    Bsi.sinOffset += offset;
    Cdo.sinOffset += offset;
    Dre.sinOffset += offset;
    Emi.sinOffset += offset;
    Ffa.sinOffset += offset;
    Gsol.sinOffset += offset;
    
    [self setNeedsDisplay:YES];
    
    
}

- (void) drawWaveForm: (WaveFormDef*)waveForm
{
    for(float i = 0; i < 2.f * M_PI; i+=.05){
        
        [self drawDot:[waveForm findPointAt:(float)i xOffset:5 yOffset:200.f]];
    }
    
         
    
}

- (void)drawDot:(NSPoint)loc
{
   
    CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBFillColor (myContext, 1, 0, 0, 1 );// 3
    
    //CGContextFillRect (myContext, CGRectMake (loc.x, loc.y, 1, 1));
    NSRect dotRect = CGRectMake (loc.x, loc.y, 2, 2);
    [[NSBezierPath bezierPathWithOvalInRect:dotRect] fill];
    
    
}

- (void) drawBackground:(NSRect)bounds
{   
    CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
    //CGContextClearRect (myContext, bounds);
    CGContextSetRGBFillColor (myContext, 0, 0, 0, 1 );// 3
    CGContextFillRect (myContext, bounds);
}


// called when needed by the view class to update the screen

- (void)drawRect:(NSRect)bounds
{
    [self drawBackground:bounds];

    [self drawWaveForm:Ala];
    [self drawWaveForm:Bsi];
    [self drawWaveForm:Cdo];
    [self drawWaveForm:Dre];
    [self drawWaveForm:Emi];
    [self drawWaveForm:Ffa];
    [self drawWaveForm:Gsol];

   
}


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        [self start];
    }
    return self;
}

- (void)viewBoundsDidChange:(NSRect)bounds
{

    
}







  @end