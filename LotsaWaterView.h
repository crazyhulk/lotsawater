#define GL_EXT_compiled_vertex_array 1

#import "LotsaCore/LotsaView.h"
#import "Water.h"
#import "WaterTypes.h"
#import "MTLRenderer.h"
#import "MTLBuffer.h"
#import "MTLTexture.h"
#import "MTLRenderPipeline.h"
#import "MTLComputePipeline.h"
#import "MTLView.h"

#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#import "LotsaCore/NameMangler.h"
#define LotsaWaterView MangleClassName(LotsaWaterView)
#define ImagePicker MangleClassName(ImagePicker)

@class ImagePicker;

@interface LotsaWaterView:LotsaView
{
	// OpenGL 相关
	NSBitmapImageRep *screenshot;

	GLuint backtex,refltex;
	double t,t_next,t_div;
	double raintime,waterdepth;

	int tex_w,tex_h;
	float water_w,water_h;

	Water wet;

	struct texcoord { float u,v; } *tex;
	struct color { GLubyte r,g,b,a; } *col;
	struct vertexcoord { float x,y; } *vert;

	// Metal 相关
	MTLView *_metalView;
	MTLRenderer *_metalRenderer;
	MTLBuffer *_vertexBuffer;
	MTLBuffer *_indexBuffer;
	MTLTexture *_reflectionTexture;
	MTLTexture *_backgroundTexture;
	MTLRenderPipeline *_renderPipeline;
	MTLComputePipeline *_waterComputePipeline;
	MTLComputePipeline *_dropComputePipeline;
	MTLBuffer *_waterParamsBuffer;
	MTLBuffer *_waterStateBuffer;
	MTLBuffer *_heightBuffer;
	MTLBuffer *_normalBuffer;
	id<MTLCommandBuffer> _currentCommandBuffer;
	id<CAMetalDrawable> _currentDrawable;

	// 共享属性
	IBOutlet NSSlider *detail;
	IBOutlet NSSlider *accuracy;
	IBOutlet NSSlider *slomo;
	IBOutlet NSSlider *depth;
	IBOutlet NSSlider *rainfall;
	IBOutlet NSSlider *imagefade;
	IBOutlet NSPopUpButton *imgsrc;
	IBOutlet LWImagePicker *imageview;
}

-(id)initWithFrame:(NSRect)frame isPreview:(BOOL)preview;
-(void)dealloc;

-(void)startAnimationWithDefaults:(ScreenSaverDefaults *)defaults;
-(void)stopAnimation;
-(void)animateOneFrame;

-(void)updateConfigWindow:(NSWindow *)window usingDefaults:(ScreenSaverDefaults *)defaults;
-(void)updateDefaults:(ScreenSaverDefaults *)defaults usingConfigWindow:(NSWindow *)window;

-(IBAction)pickImageSource:(id)sender;
-(IBAction)dropImage:(id)sender;

+(BOOL)performGammaFade;

// Metal 相关方法
- (void)setupMetal;
- (void)renderWithMetal;
- (void)updateMetalBuffers;
- (void)calculateWaterSurface;
- (void)addWaterDropAtX:(float)x y:(float)y depth:(float)d amplitude:(float)ampl;
- (void)updateReflectionTexture;

@end

@interface LWImagePicker:NSImageView
{
	NSString *filename;
}

-(void)concludeDragOperation:(id <NSDraggingInfo>)sender;
-(void)setFileName:(NSString *)newname;
-(NSString *)fileName;

@end
