#import <Cocoa/Cocoa.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <simd/simd.h>

#import "NameMangler.h"
#define MetalRenderer MangleClassName(MetalRenderer)

typedef struct {
    simd_float2 position;
    simd_float2 texCoord;
    simd_uchar4 color;
    simd_float3 normal;
} WaterVertex;

typedef struct {
    simd_float4x4 projectionMatrix;
    simd_float4x4 modelViewMatrix;
    simd_float4x4 textureMatrix;
    simd_float2 waterSize;
    float fade;
} WaterUniforms;

@interface MetalRenderer : NSObject

@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLBuffer> vertexBuffer;
@property (nonatomic, strong) id<MTLBuffer> indexBuffer;
@property (nonatomic, strong) id<MTLBuffer> uniformBuffer;
@property (nonatomic, strong) id<MTLTexture> backgroundTexture;
@property (nonatomic, strong) id<MTLTexture> reflectionTexture;

- (instancetype)initWithDevice:(id<MTLDevice>)device;
- (BOOL)setupRenderPipeline;
- (void)setupBuffersWithWaterWidth:(int)width height:(int)height;
- (void)updateVertexData:(WaterVertex *)vertices count:(NSUInteger)count;
- (void)updateUniforms:(WaterUniforms)uniforms;
- (void)setBackgroundTexture:(id<MTLTexture>)texture;
- (void)setReflectionTexture:(id<MTLTexture>)texture;
- (void)renderToTexture:(id<MTLTexture>)texture withCommandBuffer:(id<MTLCommandBuffer>)commandBuffer;

@end