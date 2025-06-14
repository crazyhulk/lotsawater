#import "MTLRenderer.h"

@interface MTLRenderer()
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id<MTLLibrary> defaultLibrary;
@property (nonatomic, strong) id<MTLCommandBuffer> currentCommandBuffer;
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
    
    return YES;
}

- (void)cleanup {
    self.device = nil;
    self.commandQueue = nil;
    self.defaultLibrary = nil;
    self.currentCommandBuffer = nil;
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

@end 