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
        // 暂时跳过Metal初始化，由外部调用者处理
        NSLog(@"MTLRenderer init completed without setup");
    }
    return self;
}

- (instancetype)initWithDevice:(id<MTLDevice>)device library:(id<MTLLibrary>)library {
    self = [super init];
    if (self) {
        self.device = device;
        self.defaultLibrary = library;
        if (![self setupPipeline]) {
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
    NSLog(@"Loading default Metal library...");
    self.defaultLibrary = [self.device newDefaultLibrary];
    if (!self.defaultLibrary) {
        NSLog(@"Failed to load default library: newDefaultLibrary returned nil");
        
        // 尝试加载bundle内的库
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSError *error = nil;
        self.defaultLibrary = [self.device newDefaultLibraryWithBundle:bundle error:&error];
        if (!self.defaultLibrary) {
            NSLog(@"Failed to load library from bundle: %@", error.localizedDescription);
            
            // 尝试从main bundle加载
            self.defaultLibrary = [self.device newDefaultLibraryWithBundle:[NSBundle mainBundle] error:&error];
            if (!self.defaultLibrary) {
                NSLog(@"Failed to load library from main bundle: %@", error.localizedDescription);
                return NO;
            } else {
                NSLog(@"Successfully loaded library from main bundle");
            }
        } else {
            NSLog(@"Successfully loaded library from class bundle");
        }
    } else {
        NSLog(@"Default library loaded successfully");
    }
    
    return [self setupPipeline];
}

- (BOOL)setupPipeline {
    if (!self.defaultLibrary) {
        NSLog(@"No Metal library available for pipeline setup");
        return NO;
    }
    
    // 创建命令队列（如果还没有）
    if (!self.commandQueue) {
        self.commandQueue = [self.device newCommandQueue];
        if (!self.commandQueue) {
            NSLog(@"Failed to create command queue");
            return NO;
        }
    }
    
    // 创建渲染管线状态
    MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    
    id<MTLFunction> vertexFunction = [self.defaultLibrary newFunctionWithName:@"waterVertexShader"];
    id<MTLFunction> fragmentFunction = [self.defaultLibrary newFunctionWithName:@"waterFragmentShader"];
    
    if (!vertexFunction) {
        NSLog(@"ERROR: Could not load vertex shader 'waterVertexShader'");
        return NO;
    }
    if (!fragmentFunction) {
        NSLog(@"ERROR: Could not load fragment shader 'waterFragmentShader'");
        return NO;
    }
    
    NSLog(@"Successfully loaded shaders: vertex=%@, fragment=%@", vertexFunction, fragmentFunction);
    
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    // 配置混合模式
    pipelineDescriptor.colorAttachments[0].blendingEnabled = YES;
    pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactorSourceAlpha;
    pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactorOneMinusSourceAlpha;
    pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactorSourceAlpha;
    pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactorOneMinusSourceAlpha;
    
    NSError *pipelineError = nil;
    self.renderPipelineState = [self.device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&pipelineError];
    if (!self.renderPipelineState) {
        NSLog(@"Failed to create render pipeline state: %@", pipelineError.localizedDescription);
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
                        drawable:(id<CAMetalDrawable>)drawable
                   vertexBuffer:(id<MTLBuffer>)vertexBuffer
                  normalBuffer:(id<MTLBuffer>)normalBuffer
              texCoordBuffer:(id<MTLBuffer>)texCoordBuffer
                   indexBuffer:(id<MTLBuffer>)indexBuffer
              backgroundTexture:(id<MTLTexture>)backgroundTexture
              reflectionTexture:(id<MTLTexture>)reflectionTexture
                     constants:(id<MTLBuffer>)constantsBuffer {
    if (!commandBuffer || !drawable || !vertexBuffer || !normalBuffer || !texCoordBuffer || !indexBuffer || !backgroundTexture || !reflectionTexture || !constantsBuffer) {
        NSLog(@"Invalid render parameters");
        return;
    }
    
    // 创建渲染通道描述符
    MTLRenderPassDescriptor *renderPassDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);
    
    // 创建渲染命令编码器
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    if (!renderEncoder) {
        NSLog(@"Failed to create render command encoder");
        return;
    }
    
    [renderEncoder setLabel:@"Water Surface Render"];
    
    // 设置渲染管线状态
    [renderEncoder setRenderPipelineState:self.renderPipelineState];
    
    // 设置顶点缓冲区 - 顶点数据包含位置、法线和纹理坐标
    [renderEncoder setVertexBuffer:vertexBuffer offset:0 atIndex:0];
    [renderEncoder setVertexBuffer:normalBuffer offset:0 atIndex:1];
    [renderEncoder setVertexBuffer:texCoordBuffer offset:0 atIndex:2];
    
    // 设置常量缓冲区
    [renderEncoder setVertexBuffer:constantsBuffer offset:0 atIndex:1];
    [renderEncoder setFragmentBuffer:constantsBuffer offset:0 atIndex:1];
    
    // 设置片段纹理
    [renderEncoder setFragmentTexture:backgroundTexture atIndex:0];
    [renderEncoder setFragmentTexture:reflectionTexture atIndex:1];
    
    // 绘制索引三角形
    NSUInteger indexCount = indexBuffer.length / sizeof(uint32_t);
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                             indexCount:indexCount
                              indexType:MTLIndexTypeUInt32
                            indexBuffer:indexBuffer
                      indexBufferOffset:0];
    
    // 结束编码
    [renderEncoder endEncoding];
}

- (void)renderWithCommandBuffer:(id<MTLCommandBuffer>)commandBuffer
                   vertexBuffer:(id<MTLBuffer>)vertexBuffer
                  normalBuffer:(id<MTLBuffer>)normalBuffer
                   indexBuffer:(id<MTLBuffer>)indexBuffer
              backgroundTexture:(id<MTLTexture>)backgroundTexture
              reflectionTexture:(id<MTLTexture>)reflectionTexture {
    NSLog(@"Warning: Using deprecated render method. Please use the new method with drawable and constants.");
}

@end 