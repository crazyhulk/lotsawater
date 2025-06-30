#import "MetalRenderer.h"

@implementation MetalRenderer

- (instancetype)initWithDevice:(id<MTLDevice>)device
{
    self = [super init];
    if (self) {
        _device = device;
        _commandQueue = [device newCommandQueue];
        
        if (![self setupRenderPipeline]) {
            return nil;
        }
    }
    return self;
}

- (BOOL)setupRenderPipeline
{
    NSError *error = nil;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *shaderURL = [bundle URLForResource:@"WaterShaders" withExtension:@"metal"];
    if (!shaderURL) {
        NSLog(@"Error: Could not find WaterShaders.metal file");
        return NO;
    }
    
    NSString *shaderSource = [NSString stringWithContentsOfURL:shaderURL encoding:NSUTF8StringEncoding error:&error];
    if (!shaderSource) {
        NSLog(@"Error reading shader source: %@", error.localizedDescription);
        return NO;
    }
    
    id<MTLLibrary> library = [self.device newLibraryWithSource:shaderSource options:nil error:&error];
    if (!library) {
        NSLog(@"Error creating library: %@", error.localizedDescription);
        return NO;
    }
    
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"waterVertexShader"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"waterFragmentShader"];
    
    if (!vertexFunction || !fragmentFunction) {
        NSLog(@"Error: Could not find shader functions");
        return NO;
    }
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    MTLVertexDescriptor *vertexDescriptor = [[MTLVertexDescriptor alloc] init];
    
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[0].offset = offsetof(WaterVertex, position);
    vertexDescriptor.attributes[0].bufferIndex = 0;
    
    vertexDescriptor.attributes[1].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[1].offset = offsetof(WaterVertex, texCoord);
    vertexDescriptor.attributes[1].bufferIndex = 0;
    
    vertexDescriptor.attributes[2].format = MTLVertexFormatUChar4Normalized;
    vertexDescriptor.attributes[2].offset = offsetof(WaterVertex, color);
    vertexDescriptor.attributes[2].bufferIndex = 0;
    
    vertexDescriptor.attributes[3].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[3].offset = offsetof(WaterVertex, normal);
    vertexDescriptor.attributes[3].bufferIndex = 0;
    
    vertexDescriptor.layouts[0].stride = sizeof(WaterVertex);
    vertexDescriptor.layouts[0].stepRate = 1;
    vertexDescriptor.layouts[0].stepFunction = MTLVertexStepFunctionPerVertex;
    
    pipelineDescriptor.vertexDescriptor = vertexDescriptor;
    
    _pipelineState = [self.device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
    if (!_pipelineState) {
        NSLog(@"Error creating pipeline state: %@", error.localizedDescription);
        return NO;
    }
    
    return YES;
}

- (void)setupBuffersWithWaterWidth:(int)width height:(int)height
{
    NSUInteger vertexCount = width * height;
    NSUInteger indexCount = (width - 1) * (height - 1) * 6;
    
    _vertexBuffer = [self.device newBufferWithLength:vertexCount * sizeof(WaterVertex)
                                             options:MTLResourceStorageModeShared];
    
    _indexBuffer = [self.device newBufferWithLength:indexCount * sizeof(uint16_t)
                                            options:MTLResourceStorageModeShared];
    
    _uniformBuffer = [self.device newBufferWithLength:sizeof(WaterUniforms)
                                              options:MTLResourceStorageModeShared];
    
    uint16_t *indices = (uint16_t *)[_indexBuffer contents];
    NSUInteger indexIndex = 0;
    
    for (int y = 0; y < height - 1; y++) {
        for (int x = 0; x < width - 1; x++) {
            uint16_t topLeft = y * width + x;
            uint16_t topRight = y * width + (x + 1);
            uint16_t bottomLeft = (y + 1) * width + x;
            uint16_t bottomRight = (y + 1) * width + (x + 1);
            
            indices[indexIndex++] = topLeft;
            indices[indexIndex++] = bottomLeft;
            indices[indexIndex++] = topRight;
            
            indices[indexIndex++] = topRight;
            indices[indexIndex++] = bottomLeft;
            indices[indexIndex++] = bottomRight;
        }
    }
}

- (void)updateVertexData:(WaterVertex *)vertices count:(NSUInteger)count
{
    if (!_vertexBuffer) return;
    
    memcpy([_vertexBuffer contents], vertices, count * sizeof(WaterVertex));
}

- (void)updateUniforms:(WaterUniforms)uniforms
{
    if (!_uniformBuffer) return;
    
    memcpy([_uniformBuffer contents], &uniforms, sizeof(WaterUniforms));
}

- (void)setBackgroundTexture:(id<MTLTexture>)texture
{
    _backgroundTexture = texture;
}

- (void)setReflectionTexture:(id<MTLTexture>)texture
{
    _reflectionTexture = texture;
}

- (void)renderToTexture:(id<MTLTexture>)texture withCommandBuffer:(id<MTLCommandBuffer>)commandBuffer
{
    MTLRenderPassDescriptor *renderPassDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
    renderPassDescriptor.colorAttachments[0].texture = texture;
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);
    renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    
    [renderEncoder setRenderPipelineState:_pipelineState];
    [renderEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
    [renderEncoder setVertexBuffer:_uniformBuffer offset:0 atIndex:1];
    
    if (_backgroundTexture) {
        [renderEncoder setFragmentTexture:_backgroundTexture atIndex:0];
    }
    if (_reflectionTexture) {
        [renderEncoder setFragmentTexture:_reflectionTexture atIndex:1];
    }
    
    MTLSamplerDescriptor *samplerDescriptor = [[MTLSamplerDescriptor alloc] init];
    samplerDescriptor.minFilter = MTLSamplerMinMagFilterLinear;
    samplerDescriptor.magFilter = MTLSamplerMinMagFilterLinear;
    samplerDescriptor.sAddressMode = MTLSamplerAddressModeClampToEdge;
    samplerDescriptor.tAddressMode = MTLSamplerAddressModeClampToEdge;
    
    id<MTLSamplerState> sampler = [self.device newSamplerStateWithDescriptor:samplerDescriptor];
    [renderEncoder setFragmentSamplerState:sampler atIndex:0];
    
    NSUInteger indexCount = [_indexBuffer length] / sizeof(uint16_t);
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:indexCount
                               indexType:MTLIndexTypeUInt16
                             indexBuffer:_indexBuffer
                       indexBufferOffset:0];
    
    [renderEncoder endEncoding];
}

@end