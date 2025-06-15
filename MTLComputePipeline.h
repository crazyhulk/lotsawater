#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLComputePipeline : NSObject

@property (nonatomic, readonly) id<MTLComputePipelineState> pipelineState;

- (instancetype)initWithDevice:(id<MTLDevice>)device
                computeFunction:(id<MTLFunction>)computeFunction;

// 执行计算
- (void)computeWithCommandBuffer:(id<MTLCommandBuffer>)commandBuffer
                      gridSize:(MTLSize)gridSize
                    threadSize:(MTLSize)threadSize
                     buffers:(NSArray<id<MTLBuffer>> *)buffers;

@end

NS_ASSUME_NONNULL_END 