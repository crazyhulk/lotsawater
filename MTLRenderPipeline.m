#import "MTLRenderPipeline.h"

@interface MTLRenderPipeline()
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLDepthStencilState> depthStencilState;
@end

@implementation MTLRenderPipeline

- (instancetype)initWithDevice:(id<MTLDevice>)device
                vertexFunction:(id<MTLFunction>)vertexFunction
              fragmentFunction:(id<MTLFunction>)fragmentFunction
                   pixelFormat:(MTLPixelFormat)pixelFormat {
    self = [super init];
    if (self) {
        // 创建渲染管线描述符
        MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineDescriptor.vertexFunction = vertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        pipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat;
        
        // 配置混合模式
        pipelineDescriptor.colorAttachments[0].blendingEnabled = YES;
        pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactorSourceAlpha;
        pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactorOneMinusSourceAlpha;
        pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactorSourceAlpha;
        pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactorOneMinusSourceAlpha;
        
        // 创建渲染管线状态
        NSError *error = nil;
        _pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        if (!_pipelineState) {
            NSLog(@"Failed to create pipeline state: %@", error);
            return nil;
        }
    }
    return self;
}

- (void)configureDepthStencilStateWithDevice:(id<MTLDevice>)device
                              depthWriteEnabled:(BOOL)depthWriteEnabled
                              depthCompareFunction:(MTLCompareFunction)depthCompareFunction {
    MTLDepthStencilDescriptor *depthStencilDescriptor = [[MTLDepthStencilDescriptor alloc] init];
    depthStencilDescriptor.depthCompareFunction = depthCompareFunction;
    depthStencilDescriptor.depthWriteEnabled = depthWriteEnabled;
    
    _depthStencilState = [device newDepthStencilStateWithDescriptor:depthStencilDescriptor];
}

- (id<MTLRenderCommandEncoder>)renderCommandEncoderWithCommandBuffer:(id<MTLCommandBuffer>)commandBuffer
                                                    renderPassDescriptor:(MTLRenderPassDescriptor *)renderPassDescriptor {
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    [renderEncoder setRenderPipelineState:_pipelineState];
    
    if (_depthStencilState) {
        [renderEncoder setDepthStencilState:_depthStencilState];
    }
    
    return renderEncoder;
}

@end 