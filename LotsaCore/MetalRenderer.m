#import "MetalRenderer.h"

@implementation MetalRenderer

- (instancetype)initWithDevice:(id<MTLDevice>)device
{
    self = [super init];
    if (self) {
        _device = device;
        _commandQueue = [device newCommandQueue];
        
        if (!_commandQueue) {
            NSLog(@"⚠️ Failed to create Metal command queue");
            return nil;
        }
        
        NSLog(@"✅ Metal device and command queue created successfully");
        
        if (![self setupRenderPipeline]) {
            NSLog(@"⚠️ Failed to setup Metal render pipeline");
            return nil;
        }
        
        NSLog(@"✅ Metal renderer initialized successfully");
    }
    return self;
}

- (BOOL)setupRenderPipeline
{
    NSError *error = nil;
    
    // Try to get the default library first (compiled shaders)
    id<MTLLibrary> library = [self.device newDefaultLibrary];
    
    if (library) {
        NSLog(@"✅ Using compiled Metal library (default.metallib)");
    } else {
        // Try loading from bundle path
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *libURL = [bundle URLForResource:@"default" withExtension:@"metallib"];
        if (libURL) {
            library = [self.device newLibraryWithURL:libURL error:&error];
            if (library) {
                NSLog(@"✅ Loaded Metal library from bundle path");
            } else {
                NSLog(@"❌ Error loading library from bundle: %@", error.localizedDescription);
            }
        } else {
            NSLog(@"⚠️ Default library not found, trying source fallback");
        }
        
        // If that fails, try loading from source (fallback for development)
        if (!library) {
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *shaderURL = [bundle URLForResource:@"WaterShaders" withExtension:@"metal"];
        if (!shaderURL) {
            NSLog(@"❌ Could not find WaterShaders.metal file in bundle: %@", bundle.bundlePath);
            return NO;
        }
        
        NSString *shaderSource = [NSString stringWithContentsOfURL:shaderURL encoding:NSUTF8StringEncoding error:&error];
        if (!shaderSource) {
            NSLog(@"❌ Error reading shader source: %@", error.localizedDescription);
            return NO;
        }
        
        library = [self.device newLibraryWithSource:shaderSource options:nil error:&error];
        if (!library) {
            NSLog(@"❌ Error creating library from source: %@", error.localizedDescription);
            return NO;
        }
        
        NSLog(@"✅ Created Metal library from source");
        }
    }
    
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"waterVertexShader"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"waterFragmentShader"];
    
    if (!vertexFunction) {
        NSLog(@"❌ Could not find vertex shader function 'waterVertexShader'");
        NSArray *functionNames = [library functionNames];
        NSLog(@"ℹ️ Available functions: %@", functionNames);
        return NO;
    }
    
    if (!fragmentFunction) {
        NSLog(@"❌ Could not find fragment shader function 'waterFragmentShader'");
        NSArray *functionNames = [library functionNames];
        NSLog(@"ℹ️ Available functions: %@", functionNames);
        return NO;
    }
    
    NSLog(@"✅ Found both vertex and fragment shader functions");
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    // Configure blending and render state
    pipelineDescriptor.colorAttachments[0].blendingEnabled = NO;
    pipelineDescriptor.colorAttachments[0].writeMask = MTLColorWriteMaskAll;
    
    // Configure rasterization
    pipelineDescriptor.rasterSampleCount = 1;
    
    MTLVertexDescriptor *vertexDescriptor = [[MTLVertexDescriptor alloc] init];
    
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[0].offset = offsetof(WaterVertex, position);
    vertexDescriptor.attributes[0].bufferIndex = 0;
    
    vertexDescriptor.attributes[1].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[1].offset = offsetof(WaterVertex, texCoord);
    vertexDescriptor.attributes[1].bufferIndex = 0;
    
    vertexDescriptor.attributes[2].format = MTLVertexFormatFloat4;
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
        NSLog(@"❌ Error creating pipeline state: %@", error.localizedDescription);
        return NO;
    }
    
    NSLog(@"✅ Metal render pipeline state created successfully");
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
    
    // Early exit if no data to render
    if (!_vertexBuffer || !_indexBuffer || !_pipelineState) {
        NSLog(@"⚠️ Metal Renderer: Missing critical data - vertexBuffer:%@ indexBuffer:%@ pipelineState:%@", 
              _vertexBuffer ? @"✓" : @"✗", _indexBuffer ? @"✓" : @"✗", _pipelineState ? @"✓" : @"✗");
        [renderEncoder endEncoding];
        return;
    }
    
    [renderEncoder setRenderPipelineState:_pipelineState];
    
    // Configure render state
    [renderEncoder setCullMode:MTLCullModeNone];
    [renderEncoder setFrontFacingWinding:MTLWindingCounterClockwise];
    
    [renderEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
    [renderEncoder setVertexBuffer:_uniformBuffer offset:0 atIndex:1];
    
    NSLog(@"🔧 Vertex buffer: %@ (%lu bytes)", _vertexBuffer, [_vertexBuffer length]);
    NSLog(@"🔧 Index buffer: %@ (%lu bytes)", _indexBuffer, [_indexBuffer length]);
    
    // Debug: Log first few vertices
    if (_vertexBuffer && [_vertexBuffer length] >= sizeof(WaterVertex)) {
        WaterVertex *verts = (WaterVertex *)[_vertexBuffer contents];
        NSLog(@"🔍 First vertex: pos(%.3f,%.3f) tex(%.3f,%.3f) color(%.3f,%.3f,%.3f,%.3f)", 
              verts[0].position.x, verts[0].position.y,
              verts[0].texCoord.x, verts[0].texCoord.y,
              verts[0].color.x, verts[0].color.y, verts[0].color.z, verts[0].color.w);
    }
    
    if (_backgroundTexture) {
        [renderEncoder setFragmentTexture:_backgroundTexture atIndex:0];
        NSLog(@"🖼️ Background texture set: %@", _backgroundTexture);
    } else {
        NSLog(@"⚠️ No background texture available");
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
    NSLog(@"🎨 Drawing %lu triangles with index buffer", indexCount / 3);
    
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:indexCount
                               indexType:MTLIndexTypeUInt16
                             indexBuffer:_indexBuffer
                       indexBufferOffset:0];
    
    [renderEncoder endEncoding];
}

@end