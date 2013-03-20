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
    WaveFormDef *testWave;
    WaveFormDef *testWave2;
}

/* *****************************
   Init function run once the view frame is loaded and visible
 ******************************* */
- (void)start
{
    
    testWave = [[WaveFormDef alloc ]initWithHz:1.f withAmp:2.f withHzLength:200.f];
    
    testWave2 = [[WaveFormDef alloc ]initWithHz:.5 withAmp:2.f withHzLength:200.f];
    
    //testWave3.sinOffset = 1.5;
    
    //testWave.res = 18.f;
    
    // New timer for updating OpenGL view
	[self initUpdateTimer];
    
    //[self drawWaveForm:testWave];
    //[self drawWaveForm:testWave2];
    //[self drawWaveForm:testWave3];
    
}


- (void) animateMe
{
    [self drawWaveForm:testWave];
    [self drawWaveForm:testWave2];
    testWave2.sinOffset -= .05;
    testWave.sinOffset += .1;
    
}

- (void) drawWaveForm: (WaveFormDef*)waveForm
{
    for(float i = 0; i < 4.f * 2.f * M_PI; i+=.25){
        
        [self drawDot:[waveForm findPointAt:(float)i xOffset:0 yOffset:300.f]];
    }
    
         
    
}

// custom drawrect function - used here for initing

- (void)drawRect:(NSRect)bounds inCIContext:(CIContext *)ctx;
{
    
    
    // this is a workaround to use openGlview subclass as there is no
    // standard init call back once it is loaded into view.
    if(!readyToDraw){
        readyToDraw = YES;
        [self start];
    }
    
    if (self.image != nil) {
   
        // clear the screen before redraw
        CIImageAccumulator *newAccumulator = [[CIImageAccumulator alloc] initWithExtent:*(CGRect *)&bounds format:kCIFormatRGBA16];
        CIFilter *filter = [CIFilter filterWithName:@"CIConstantColorGenerator" keysAndValues:@"inputColor", [CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0], nil];
        [newAccumulator setImage:[filter valueForKey:@"outputImage"]];
        
            
        self.imageAccumulator = newAccumulator;
        
        [self setImage:[self.imageAccumulator image]];
        
        [self animateMe];
        
        [ctx drawImage:self.image inRect:bounds fromRect:bounds];
    }

}


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _brushSize = 2.0;
        
        _color = [NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        _brushFilter = [CIFilter filterWithName: @"CIRadialGradient" keysAndValues:
                        @"inputColor1", [CIColor colorWithRed:0.0 green:0.0
                                                         blue:0.0 alpha:0.0], @"inputRadius0", @0.0, nil];
        
        _compositeFilter = [CIFilter filterWithName: @"CISourceOverCompositing"];
        
        
        
    }
    
    readyToDraw = NO;
   
    return self;
}

- (void)viewBoundsDidChange:(NSRect)bounds
{
   
    if ((self.imageAccumulator != nil) && (CGRectEqualToRect (*(CGRect *)&bounds, [self.imageAccumulator extent]))) {
        return;
    }
    
    /* Create a new accumulator and composite the old one over the it. */
     
    CIImageAccumulator *newAccumulator = [[CIImageAccumulator alloc] initWithExtent:*(CGRect *)&bounds format:kCIFormatRGBA16];
    CIFilter *filter = [CIFilter filterWithName:@"CIConstantColorGenerator" keysAndValues:@"inputColor", [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], nil];
    [newAccumulator setImage:[filter valueForKey:@"outputImage"]];
    
    if (self.imageAccumulator != nil)
    {
        filter = [CIFilter filterWithName:@"CISourceOverCompositing"
                            keysAndValues:@"inputImage", [self.imageAccumulator image],
                  @"inputBackgroundImage", [newAccumulator image], nil];
        //[newAccumulator setImage:[filter valueForKey:@"outputImage"]];
    }
    
    self.imageAccumulator = newAccumulator;
    
    [self setImage:[self.imageAccumulator image]];
    
   
    
}



- (void)drawDot:(NSPoint)loc
{
    CIFilter *brushFilter = self.brushFilter;
    
    //NSPoint  loc = [self convertPoint:[event locationInWindow] fromView:nil];
    
    [brushFilter setValue:@(self.brushSize) forKey:@"inputRadius1"];
    
    CIColor *cicolor = [[CIColor alloc] initWithColor:self.color];
    [brushFilter setValue:cicolor forKey:@"inputColor0"];
    
    CIVector *inputCenter = [CIVector vectorWithX:loc.x Y:loc.y];
    [brushFilter setValue:inputCenter forKey:@"inputCenter"];
    
    
    CIFilter *compositeFilter = self.compositeFilter;
    
    [compositeFilter setValue:[brushFilter valueForKey:@"outputImage"] forKey:@"inputImage"];
    [compositeFilter setValue:[self.imageAccumulator image] forKey:@"inputBackgroundImage"];
    
    CGFloat brushSize = self.brushSize;
    CGRect rect = CGRectMake(loc.x-brushSize, loc.y-brushSize, 2.0*brushSize, 2.0*brushSize);
    
    //flag for a redraw
   [self.imageAccumulator setImage:[compositeFilter valueForKey:@"outputImage"] dirtyRect:rect];
   [self setImage:[self.imageAccumulator image] dirtyRect:rect];
    
    
}




- (void)mouseDragged:(NSEvent *)event
{
    CIFilter *brushFilter = self.brushFilter;
    
    NSPoint  loc = [self convertPoint:[event locationInWindow] fromView:nil];
    [brushFilter setValue:@(self.brushSize) forKey:@"inputRadius1"];
    
    CIColor *cicolor = [[CIColor alloc] initWithColor:self.color];
    [brushFilter setValue:cicolor forKey:@"inputColor0"];
    
    CIVector *inputCenter = [CIVector vectorWithX:loc.x Y:loc.y];
    [brushFilter setValue:inputCenter forKey:@"inputCenter"];
    
    
    CIFilter *compositeFilter = self.compositeFilter;
    
    [compositeFilter setValue:[brushFilter valueForKey:@"outputImage"] forKey:@"inputImage"];
    [compositeFilter setValue:[self.imageAccumulator image] forKey:@"inputBackgroundImage"];
    
    CGFloat brushSize = self.brushSize;
    CGRect rect = CGRectMake(loc.x-brushSize, loc.y-brushSize, 2.0*brushSize, 2.0*brushSize);
    
    [self.imageAccumulator setImage:[compositeFilter valueForKey:@"outputImage"] dirtyRect:rect];
    [self setImage:[self.imageAccumulator image] dirtyRect:rect];
}


- (void)mouseDown:(NSEvent *)event
{
    [self mouseDragged: event];
}




  @end