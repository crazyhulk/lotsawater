#import <Metal/Metal.h>
#import <simd/simd.h>
#import "WaterTypes.h"

// 法线计算参数结构体
typedef struct {
    uint32_t width;
    uint32_t height;
    float scale;
} NormalComputeParams;

@interface MTLComputePipelineManager : NSObject

@property (nonatomic, readonly) id<MTLDevice> device;

- (instancetype)initWithDevice:(id<MTLDevice>)device;

// 法线计算
- (void)computeNormalsWithHeightBuffer:(id<MTLBuffer>)heightBuffer
                         normalBuffer:(id<MTLBuffer>)normalBuffer
                               width:(uint32_t)width
                              height:(uint32_t)height
                              scale:(float)scale
                        commandBuffer:(id<MTLCommandBuffer>)commandBuffer;

// 水波纹计算
- (void)computeWaterSurfaceWithCurrentBuffer:(id<MTLBuffer>)currentBuffer
                              previousBuffer:(id<MTLBuffer>)previousBuffer
                                  nextBuffer:(id<MTLBuffer>)nextBuffer
                                       width:(uint32_t)width
                                      height:(uint32_t)height
                                       time:(float)time
                                      depth:(float)depth
                                    damping:(float)damping
                                      speed:(float)speed
                               commandBuffer:(id<MTLCommandBuffer>)commandBuffer;

// 水滴效果
- (void)computeWaterDropWithHeightBuffer:(id<MTLBuffer>)heightBuffer
                               position:(simd_float2)position
                              amplitude:(float)amplitude
                                 radius:(float)radius
                          commandBuffer:(id<MTLCommandBuffer>)commandBuffer;

@end 