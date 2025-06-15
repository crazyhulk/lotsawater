#import "MTLComputePipeline.h"

@interface MTLComputePipeline()
@property (nonatomic, strong) id<MTLComputePipelineState> pipelineState;
@end

@implementation MTLComputePipeline

- (instancetype)initWithDevice:(id<MTLDevice>)device
                computeFunction:(id<MTLFunction>)computeFunction {
    self = [super init];
    if (self) {
        NSError *error = nil;
        _pipelineState = [device newComputePipelineStateWithFunction:computeFunction error:&error];
        if (!_pipelineState) {
            NSLog(@"Failed to create compute pipeline state: %@", error);
            return nil;
        }
    }
    return self;
}

- (void)computeWithCommandBuffer:(id<MTLCommandBuffer>)commandBuffer
                      gridSize:(MTLSize)gridSize
                    threadSize:(MTLSize)threadSize
                     buffers:(NSArray<id<MTLBuffer>> *)buffers {
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    [computeEncoder setComputePipelineState:_pipelineState];
    
    // 设置缓冲区
    for (NSUInteger i = 0; i < buffers.count; i++) {
        [computeEncoder setBuffer:buffers[i] offset:0 atIndex:i];
    }
    
    // 调度计算
    [computeEncoder dispatchThreads:gridSize threadsPerThreadgroup:threadSize];
    [computeEncoder endEncoding];
}

@end 