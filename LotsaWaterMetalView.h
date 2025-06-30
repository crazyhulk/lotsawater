#import "LotsaCore/LotsaView.h"
#import "Water.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import "LotsaCore/MetalConverter.h"
#import "LotsaCore/MetalRenderer.h"

#import "LotsaCore/NameMangler.h"
#define LotsaWaterMetalView MangleClassName(LotsaWaterMetalView)
#define ImagePicker MangleClassName(ImagePicker)

@interface LWImagePicker:NSImageView
{
    NSString *filename;
}

-(void)concludeDragOperation:(id <NSDraggingInfo>)sender;
-(void)setFileName:(NSString *)newname;
-(NSString *)fileName;

@end

@interface LotsaWaterMetalView : LotsaView <MTKViewDelegate>
{
    MTKView *metalView;
    id<MTLDevice> device;
    MetalRenderer *renderer;
    
    NSBitmapImageRep *screenshot;
    
    Water wet;
    WaterVertex *vertices;
    
    float t, t_next, t_div;
    float raintime, waterdepth;
    float water_w, water_h;
    
    int tex_w, tex_h;
    
    id<MTLTexture> backgroundTexture;
    id<MTLTexture> reflectionTexture;
    
    IBOutlet NSSlider *detail;
    IBOutlet NSSlider *accuracy;
    IBOutlet NSSlider *slomo;
    IBOutlet NSSlider *depth;
    IBOutlet NSSlider *rainfall;
    IBOutlet NSSlider *imagefade;
    IBOutlet NSPopUpButton *imgsrc;
    IBOutlet LWImagePicker *imageview;
}

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)preview;
- (void)dealloc;

- (void)startAnimation;
- (void)startAnimationWithDefaults:(ScreenSaverDefaults *)defaults;
- (void)stopAnimation;
- (void)animateOneFrame;

- (void)updateConfigWindow:(NSWindow *)window usingDefaults:(ScreenSaverDefaults *)defaults;
- (void)updateDefaults:(ScreenSaverDefaults *)defaults usingConfigWindow:(NSWindow *)window;

- (IBAction)pickImageSource:(id)sender;
- (IBAction)dropImage:(id)sender;

+ (BOOL)performGammaFade;

@end

