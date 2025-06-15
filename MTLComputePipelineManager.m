#import "MTLComputePipelineManager.h"

@implementation MTLComputePipelineManager {
    id<MTLComputePipelineState> _normalComputePipeline;
    id<MTLComputePipelineState> _waterSurfacePipeline;
    id<MTLComputePipelineState> _waterDropPipeline;
    id<MTLBuffer> _normalComputeParamsBuffer;
    id<MTLBuffer> _waterComputeParamsBuffer;
}

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    self = [super init];
    if (self) {
        _device = device;
        [self setupPipelines];
    }
    return self;
}

- (void)setupPipelines {
    NSError *error = nil;
    
    // 加载着色器库
    id<MTLLibrary> library = [_device newDefaultLibrary];
    
    // 创建法线计算管线
    id<MTLFunction> normalComputeFunction = [library newFunctionWithName:@"computeNormals"];
    _normalComputePipeline = [_device newComputePipelineStateWithFunction:normalComputeFunction error:&error];
    if (!_normalComputePipeline) {
        NSLog(@"Failed to create normal compute pipeline: %@", error);
        return;
    }
    
    // 创建水波纹计算管线
    id<MTLFunction> waterSurfaceFunction = [library newFunctionWithName:@"computeWaterSurface"];
    _waterSurfacePipeline = [_device newComputePipelineStateWithFunction:waterSurfaceFunction error:&error];
    if (!_waterSurfacePipeline) {
        NSLog(@"Failed to create water surface compute pipeline: %@", error);
        return;
    }
    
    // 创建水滴效果计算管线
    id<MTLFunction> waterDropFunction = [library newFunctionWithName:@"computeWaterDrop"];
    _waterDropPipeline = [_device newComputePipelineStateWithFunction:waterDropFunction error:&error];
    if (!_waterDropPipeline) {
        NSLog(@"Failed to create water drop compute pipeline: %@", error);
        return;
    }
    
    // 创建参数缓冲区
    _normalComputeParamsBuffer = [_device newBufferWithLength:sizeof(NormalComputeParams)
                                                    options:MTLResourceStorageModeShared];
    _waterComputeParamsBuffer = [_device newBufferWithLength:sizeof(WaterComputeParams)
                                                   options:MTLResourceStorageModeShared];
}

- (void)computeNormalsWithHeightBuffer:(id<MTLBuffer>)heightBuffer
                         normalBuffer:(id<MTLBuffer>)normalBuffer
                               width:(uint32_t)width
                              height:(uint32_t)height
                              scale:(float)scale
                        commandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    if (!_normalComputePipeline || !heightBuffer || !normalBuffer) {
        return;
    }
    
    // 更新参数
    NormalComputeParams *params = (NormalComputeParams *)_normalComputeParamsBuffer.contents;
    params->width = width;
    params->height = height;
    params->scale = scale;
    
    // 创建计算命令编码器
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    [computeEncoder setComputePipelineState:_normalComputePipeline];
    
    // 设置缓冲区
    [computeEncoder setBuffer:heightBuffer offset:0 atIndex:0];
    [computeEncoder setBuffer:normalBuffer offset:0 atIndex:1];
    [computeEncoder setBuffer:_normalComputeParamsBuffer offset:0 atIndex:2];
    
    // 计算线程组大小
    MTLSize threadGroupSize = MTLSizeMake(16, 16, 1);
    MTLSize threadGroups = MTLSizeMake(
        (width + threadGroupSize.width - 1) / threadGroupSize.width,
        (height + threadGroupSize.height - 1) / threadGroupSize.height,
        1
    );
    
    // 调度计算
    [computeEncoder dispatchThreadgroups:threadGroups threadsPerThreadgroup:threadGroupSize];
    [computeEncoder endEncoding];
}

- (void)computeWaterSurfaceWithCurrentBuffer:(id<MTLBuffer>)currentBuffer
                              previousBuffer:(id<MTLBuffer>)previousBuffer
                                  nextBuffer:(id<MTLBuffer>)nextBuffer
                                       width:(uint32_t)width
                                      height:(uint32_t)height
                                       time:(float)time
                                      depth:(float)depth
                                    damping:(float)damping
                                      speed:(float)speed
                               commandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    if (!_waterSurfacePipeline || !currentBuffer || !previousBuffer || !nextBuffer) {
        return;
    }
    
    // 更新参数
    WaterComputeParams *params = (WaterComputeParams *)_waterComputeParamsBuffer.contents;
    params->width = width;
    params->height = height;
    params->time = time;
    params->depth = depth;
    params->damping = damping;
    params->speed = speed;
    
    // 创建计算命令编码器
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    [computeEncoder setComputePipelineState:_waterSurfacePipeline];
    
    // 设置缓冲区
    [computeEncoder setBuffer:currentBuffer offset:0 atIndex:0];
    [computeEncoder setBuffer:previousBuffer offset:0 atIndex:1];
    [computeEncoder setBuffer:nextBuffer offset:0 atIndex:2];
    [computeEncoder setBuffer:_waterComputeParamsBuffer offset:0 atIndex:3];
    
    // 计算线程组大小
    MTLSize threadGroupSize = MTLSizeMake(16, 16, 1);
    MTLSize threadGroups = MTLSizeMake(
        (width + threadGroupSize.width - 1) / threadGroupSize.width,
        (height + threadGroupSize.height - 1) / threadGroupSize.height,
        1
    );
    
    // 调度计算
    [computeEncoder dispatchThreadgroups:threadGroups threadsPerThreadgroup:threadGroupSize];
    [computeEncoder endEncoding];
}

- (void)computeWaterDropWithHeightBuffer:(id<MTLBuffer>)heightBuffer
                               position:(simd_float2)position
                              amplitude:(float)amplitude
                                 radius:(float)radius
                          commandBuffer:(id<MTLCommandBuffer>)commandBuffer {
    if (!_waterDropPipeline || !heightBuffer) {
        return;
    }
    
    // 创建参数缓冲区
    id<MTLBuffer> positionBuffer = [_device newBufferWithBytes:&position
                                                      length:sizeof(simd_float2)
                                                     options:MTLResourceStorageModeShared];
    id<MTLBuffer> amplitudeBuffer = [_device newBufferWithBytes:&amplitude
                                                       length:sizeof(float)
                                                      options:MTLResourceStorageModeShared];
    id<MTLBuffer> radiusBuffer = [_device newBufferWithBytes:&radius
                                                    length:sizeof(float)
                                                   options:MTLResourceStorageModeShared];
    
    // 创建计算命令编码器
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    [computeEncoder setComputePipelineState:_waterDropPipeline];
    
    // 设置缓冲区
    [computeEncoder setBuffer:heightBuffer offset:0 atIndex:0];
    [computeEncoder setBuffer:positionBuffer offset:0 atIndex:1];
    [computeEncoder setBuffer:amplitudeBuffer offset:0 atIndex:2];
    [computeEncoder setBuffer:radiusBuffer offset:0 atIndex:3];
    
    // 计算线程组大小
    MTLSize threadGroupSize = MTLSizeMake(16, 16, 1);
    MTLSize threadGroups = MTLSizeMake(
        ((uint32_t)(radius) + threadGroupSize.width - 1) / threadGroupSize.width,
        ((uint32_t)(radius) + threadGroupSize.height - 1) / threadGroupSize.height,
        1
    );
    
    // 调度计算
    [computeEncoder dispatchThreadgroups:threadGroups threadsPerThreadgroup:threadGroupSize];
    [computeEncoder endEncoding];
}

@end 
