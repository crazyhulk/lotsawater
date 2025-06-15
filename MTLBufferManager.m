#import "MTLBufferManager.h"

@interface MTLBufferManager()
@property (nonatomic, strong) id<MTLDevice> device;
@end

@implementation MTLBufferManager

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    self = [super init];
    if (self) {
        _device = device;
    }
    return self;
}

- (id<MTLBuffer>)createBufferWithLength:(NSUInteger)length options:(MTLResourceOptions)options {
    return [self.device newBufferWithLength:length options:options];
}

- (id<MTLBuffer>)createBufferWithBytes:(const void *)bytes length:(NSUInteger)length options:(MTLResourceOptions)options {
    return [self.device newBufferWithBytes:bytes length:length options:options];
}

- (id<MTLBuffer>)createVertexBufferWithVertices:(const void *)vertices count:(NSUInteger)count stride:(NSUInteger)stride {
    NSUInteger bufferLength = count * stride;
    id<MTLBuffer> buffer = [self createBufferWithBytes:vertices length:bufferLength options:MTLResourceStorageModeShared];
    return buffer;
}

- (id<MTLBuffer>)createIndexBufferWithIndices:(const void *)indices count:(NSUInteger)count format:(MTLIndexType)format {
    NSUInteger indexSize = (format == MTLIndexTypeUInt16) ? sizeof(uint16_t) : sizeof(uint32_t);
    NSUInteger bufferLength = count * indexSize;
    id<MTLBuffer> buffer = [self createBufferWithBytes:indices length:bufferLength options:MTLResourceStorageModeShared];
    return buffer;
}

- (id<MTLBuffer>)createUniformBufferWithBytes:(const void *)bytes length:(NSUInteger)length {
    return [self createBufferWithBytes:bytes length:length options:MTLResourceStorageModeShared];
}

- (void)updateBuffer:(id<MTLBuffer>)buffer withBytes:(const void *)bytes offset:(NSUInteger)offset length:(NSUInteger)length {
    void *bufferContents = buffer.contents;
    if (bufferContents) {
        memcpy(bufferContents + offset, bytes, length);
        [buffer didModifyRange:NSMakeRange(offset, length)];
    }
}

- (id<MTLBuffer>)createHeightBufferWithWidth:(uint32_t)width height:(uint32_t)height {
    NSUInteger bufferLength = width * height * sizeof(float);
    return [self createBufferWithLength:bufferLength options:MTLResourceStorageModeShared];
}

- (id<MTLBuffer>)createNormalBufferWithWidth:(uint32_t)width height:(uint32_t)height {
    NSUInteger bufferLength = width * height * sizeof(simd_float3);
    return [self createBufferWithLength:bufferLength options:MTLResourceStorageModeShared];
}

- (id<MTLBuffer>)createWaterStateBufferWithWidth:(uint32_t)width height:(uint32_t)height {
    // 为当前、上一帧和下一帧的状态创建缓冲区
    NSUInteger bufferLength = width * height * sizeof(float) * 3;
    return [self createBufferWithLength:bufferLength options:MTLResourceStorageModeShared];
}

@end 