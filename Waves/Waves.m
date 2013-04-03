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
    [self drawWaveForm:Ala];
    [self drawWaveForm:Bsi];
    //[self drawWaveForm:Cdo];
    //[self drawWaveForm:Dre];
    //[self drawWaveForm:Emi];
    //[self drawWaveForm:Ffa];
    //[self drawWaveForm:Gsol];
    
    float offset = .015;
    
    Ala.sinOffset += offset;
    Bsi.sinOffset += offset;
    Cdo.sinOffset += offset;
    Dre.sinOffset += offset;
    Emi.sinOffset += offset;
    Ffa.sinOffset += offset;
    Gsol.sinOffset += offset;
    
}

- (void) drawWaveForm: (WaveFormDef*)waveForm
{
    for(float i = 0; i < 2.f * M_PI; i+=.05){
        
        [self drawDot:[waveForm findPointAt:(float)i xOffset:50 yOffset:300.f]];
    }
    
         
    
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
     
    
    [brushFilter setValue:inputCenter forKey:@"inputCenter"];
    
    
    CGRect rect = CGRectMake(loc.x-brushSize, loc.y-brushSize, 2.0*brushSize, 2.0*brushSize);
    
    //flag for a redraw
    //[self.imageAccumulator setImage:[compositeFilter valueForKey:@"outputImage"] dirtyRect:rect];
    [self.imageAccumulator setImage:[compositeFilter valueForKey:@"outputImage"] dirtyRect:rect];
     [self setImage:[self.imageAccumulator image] dirtyRect:rect];
    
    
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
        _brushSize = 5.0;
        
        _color = [NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:.5];
        
        _brushFilter = [CIFilter filterWithName: @"CIRadialGradient" keysAndValues:
                        @"inputColor1", [CIColor colorWithRed:1.0 green:1.0
                                                         blue:1.0 alpha:0.0], @"inputRadius0", @0.0, nil];
        
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