#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLRenderPipeline : NSObject

@property (nonatomic, readonly) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, readonly) id<MTLDepthStencilState> depthStencilState;

- (instancetype)initWithDevice:(id<MTLDevice>)device
                    vertexFunction:(id<MTLFunction>)vertexFunction
                  fragmentFunction:(id<MTLFunction>)fragmentFunction
                     pixelFormat:(MTLPixelFormat)pixelFormat;

// 配置深度测试
- (void)configureDepthStencilStateWithDevice:(id<MTLDevice>)device
                                  depthWriteEnabled:(BOOL)depthWriteEnabled
                                  depthCompareFunction:(MTLCompareFunction)depthCompareFunction;

// 获取渲染命令编码器
- (id<MTLRenderCommandEncoder>)renderCommandEncoderWithCommandBuffer:(id<MTLCommandBuffer>)commandBuffer
                                                      renderPassDescriptor:(MTLRenderPassDescriptor *)renderPassDescriptor;

@end

NS_ASSUME_NONNULL_END 