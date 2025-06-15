#import "MTLRenderer.h"

@interface MTLRenderer()
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id<MTLLibrary> defaultLibrary;
@property (nonatomic, strong) id<MTLCommandBuffer> currentCommandBuffer;
@property (nonatomic, strong) id<MTLRenderPipelineState> renderPipelineState;
@end

@implementation MTLRenderer

- (instancetype)init {
    self = [super init];
    if (self) {
        if (![self setupMetal]) {
            return nil;
        }
    }
    return self;
}

- (BOOL)setupMetal {
    // 获取默认的 Metal 设备
    self.device = MTLCreateSystemDefaultDevice();
    if (!self.device) {
        NSLog(@"Metal is not supported on this device");
        return NO;
    }
    
    // 创建命令队列
    self.commandQueue = [self.device newCommandQueue];
    if (!self.commandQueue) {
        NSLog(@"Failed to create command queue");
        return NO;
    }
    
    // 加载默认的 Metal 库
    NSError *error = nil;
    self.defaultLibrary = [self.device newDefaultLibrary];
    if (!self.defaultLibrary) {
        NSLog(@"Failed to load default library: %@", error);
        return NO;
    }
    
    // 创建渲染管线状态
    MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineDescriptor.vertexFunction = [self.defaultLibrary newFunctionWithName:@"waterVertexShader"];
    pipelineDescriptor.fragmentFunction = [self.defaultLibrary newFunctionWithName:@"waterFragmentShader"];
    pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    // 配置混合模式
    pipelineDescriptor.colorAttachments[0].blendingEnabled = YES;
    pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactorSourceAlpha;
    pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactorOneMinusSourceAlpha;
    pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactorSourceAlpha;
    pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactorOneMinusSourceAlpha;
    
    self.renderPipelineState = [self.device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
    if (!self.renderPipelineState) {
        NSLog(@"Failed to create render pipeline state: %@", error);
        return NO;
    }
    
    return YES;
}

- (void)cleanup {
    self.device = nil;
    self.commandQueue = nil;
    self.defaultLibrary = nil;
    self.currentCommandBuffer = nil;
    self.renderPipelineState = nil;
}

- (void)beginFrame {
    self.currentCommandBuffer = [self.commandQueue commandBuffer];
}

- (void)endFrame {
    [self.currentCommandBuffer commit];
    self.currentCommandBuffer = nil;
}

- (void)presentDrawable:(id<CAMetalDrawable>)drawable {
    if (!self.currentCommandBuffer) {
        NSLog(@"No active command buffer");
        return;
    }
    
    [self.currentCommandBuffer presentDrawable:drawable];
}

- (id<MTLBuffer>)createBufferWithBytes:(const void *)bytes 
                               length:(NSUInteger)length 
                              options:(MTLResourceOptions)options {
    return [self.device newBufferWithBytes:bytes 
                                  length:length 
                                 options:options];
}

- (id<MTLTexture>)createTextureWithDescriptor:(MTLTextureDescriptor *)descriptor {
    return [self.device newTextureWithDescriptor:descriptor];
}

- (void)renderWithCommandBuffer:(id<MTLCommandBuffer>)commandBuffer
                   vertexBuffer:(id<MTLBuffer>)vertexBuffer
                  normalBuffer:(id<MTLBuffer>)normalBuffer
                   indexBuffer:(id<MTLBuffer>)indexBuffer
              backgroundTexture:(id<MTLTexture>)backgroundTexture
              reflectionTexture:(id<MTLTexture>)reflectionTexture {
    
    // 创建渲染通道描述符
    MTLRenderPassDescriptor *renderPassDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);
    renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    
    // 创建渲染命令编码器
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    [renderEncoder setRenderPipelineState:self.renderPipelineState];
    
    // 设置顶点缓冲区
    [renderEncoder setVertexBuffer:vertexBuffer offset:0 atIndex:0];
    [renderEncoder setVertexBuffer:normalBuffer offset:0 atIndex:1];
    
    // 设置片段纹理
    [renderEncoder setFragmentTexture:backgroundTexture atIndex:0];
    [renderEncoder setFragmentTexture:reflectionTexture atIndex:1];
    
    // 绘制索引三角形
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                             indexCount:[indexBuffer length] / sizeof(uint32_t)
                              indexType:MTLIndexTypeUInt32
                            indexBuffer:indexBuffer
                      indexBufferOffset:0];
    
    [renderEncoder endEncoding];
}

@end 