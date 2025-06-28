#import "LotsaCore/LotsaView.h"
#import "Water.h"
#import "WaterTypes.h"
#import "MTLRenderer.h"
#import "MTLBuffer.h"
#import "MTLTexture.h"
#import "MTLRenderPipeline.h"
#import "MTLComputePipeline.h"
#import "MTLView.h"
#import <ScreenSaver/ScreenSaver.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import "MTLShaderManager.h"
#import "MTLBufferManager.h"
#import "MTLComputePipelineManager.h"

#import "LotsaCore/NameMangler.h"
#define LotsaWaterView MangleClassName(LotsaWaterView)
#define ImagePicker MangleClassName(ImagePicker)

@class ImagePicker;

//@interface LotsaWaterView:ScreenSaverView
@interface LotsaWaterView: LotsaView
{
	// 水波纹数据
	NSBitmapImageRep *screenshot;

	double raintime,waterdepth;

	int tex_w,tex_h;
	float water_w,water_h;

	Water wet;

	// Metal 组件
	MTLView *_metalView;
	MTLRenderer *_metalRenderer;
	MTLBufferManager *_bufferManager;
	MTLComputePipelineManager *_computeManager;
	
	// Metal 缓冲区
	id<MTLBuffer> _vertexBuffer;
	id<MTLBuffer> _normalBuffer;
	id<MTLBuffer> _texCoordBuffer;
	id<MTLBuffer> _indexBuffer;
	id<MTLBuffer> _heightBuffer;
	id<MTLBuffer> _constantsBuffer;
	
	// Metal 纹理
	id<MTLTexture> _reflectionTexture;
	id<MTLTexture> _backgroundTexture;

	// 共享属性
	IBOutlet NSSlider *detail;
	IBOutlet NSSlider *accuracy;
	IBOutlet NSSlider *slomo;
	IBOutlet NSSlider *depth;
	IBOutlet NSSlider *rainfall;
	IBOutlet NSSlider *imagefade;
	IBOutlet NSPopUpButton *imgsrc;
	IBOutlet LWImagePicker *imageview;

	// Metal 设备和命令队列
	id<MTLDevice> _device;
	id<MTLCommandQueue> _commandQueue;

	// 水波纹参数
	float _time;
	float _nextTime;
	float _timeStep;
	float _waterDepth;
	float _damping;
	float _waveSpeed;
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
- (void)createMetalBuffers;
- (void)updateWaterSurface;
- (void)updateConstants;
- (void)addRandomWaterDrop;
- (void)updateReflectionTexture;
- (void)updateBackgroundTexture;

@end

@interface LWImagePicker:NSImageView
{
	NSString *filename;
}

-(void)concludeDragOperation:(id <NSDraggingInfo>)sender;
-(void)setFileName:(NSString *)newname;
-(NSString *)fileName;

@end
