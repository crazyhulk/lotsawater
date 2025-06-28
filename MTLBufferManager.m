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
    id<MTLBuffer> buffer;
    
    if (vertices) {
        buffer = [self createBufferWithBytes:vertices length:bufferLength options:MTLResourceStorageModeShared];
    } else {
        buffer = [self createBufferWithLength:bufferLength options:MTLResourceStorageModeShared];
    }
    
    if (buffer) {
        buffer.label = @"Vertex Buffer";
    }
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
    id<MTLBuffer> buffer = [self createBufferWithLength:bufferLength options:MTLResourceStorageModeShared];
    if (buffer) {
        buffer.label = @"Height Buffer";
        // 初始化为0
        memset([buffer contents], 0, bufferLength);
    }
    return buffer;
}

- (id<MTLBuffer>)createNormalBufferWithWidth:(uint32_t)width height:(uint32_t)height {
    NSUInteger bufferLength = width * height * sizeof(simd_float3);
    id<MTLBuffer> buffer = [self createBufferWithLength:bufferLength options:MTLResourceStorageModeShared];
    if (buffer) {
        buffer.label = @"Normal Buffer";
        // 初始化法线为向上
        simd_float3 *normals = (simd_float3 *)[buffer contents];
        for (NSUInteger i = 0; i < width * height; i++) {
            normals[i] = simd_make_float3(0.0f, 0.0f, 1.0f);
        }
    }
    return buffer;
}

- (id<MTLBuffer>)createWaterStateBufferWithWidth:(uint32_t)width height:(uint32_t)height {
    // 为当前、上一帧和下一帧的状态创建缓冲区
    NSUInteger bufferLength = width * height * sizeof(float) * 3;
    return [self createBufferWithLength:bufferLength options:MTLResourceStorageModeShared];
}

- (id<MTLBuffer>)createTexCoordBufferWithWidth:(NSUInteger)width height:(NSUInteger)height {
    NSUInteger bufferLength = width * height * sizeof(simd_float2);
    id<MTLBuffer> buffer = [self createBufferWithLength:bufferLength options:MTLResourceStorageModeShared];
    
    if (buffer) {
        buffer.label = @"TexCoord Buffer";
        
        // 生成纹理坐标
        simd_float2 *texCoords = (simd_float2 *)[buffer contents];
        for (NSUInteger y = 0; y < height; y++) {
            for (NSUInteger x = 0; x < width; x++) {
                NSUInteger index = y * width + x;
                float u = (float)x / (float)(width - 1);
                float v = (float)y / (float)(height - 1);
                texCoords[index] = simd_make_float2(u, v);
            }
        }
    }
    return buffer;
}

- (id<MTLBuffer>)createConstantsBufferWithSize:(NSUInteger)size {
    id<MTLBuffer> buffer = [self createBufferWithLength:size options:MTLResourceStorageModeShared];
    if (buffer) {
        buffer.label = @"Constants Buffer";
    }
    return buffer;
}

- (void)generateGridVerticesForBuffer:(id<MTLBuffer>)vertexBuffer 
                         normalBuffer:(id<MTLBuffer>)normalBuffer
                        texCoordBuffer:(id<MTLBuffer>)texCoordBuffer
                                width:(NSUInteger)width 
                               height:(NSUInteger)height 
                           waterWidth:(float)waterWidth 
                          waterHeight:(float)waterHeight {
    if (!vertexBuffer || !normalBuffer || !texCoordBuffer) {
        return;
    }
    
    // 顶点位置 (包含高度信息)
    simd_float3 *vertices = (simd_float3 *)[vertexBuffer contents];
    // 法线
    simd_float3 *normals = (simd_float3 *)[normalBuffer contents];
    // 纹理坐标
    simd_float2 *texCoords = (simd_float2 *)[texCoordBuffer contents];
    
    for (NSUInteger y = 0; y < height; y++) {
        for (NSUInteger x = 0; x < width; x++) {
            NSUInteger index = y * width + x;
            
            // 计算网格位置 (-1 to 1 范围)
            float fx = (float)x / (float)(width - 1);
            float fy = (float)y / (float)(height - 1);
            
            // 顶点位置 (z值稍后由水波纹计算更新)
            vertices[index] = simd_make_float3(
                (fx - 0.5f) * 2.0f * waterWidth,
                (fy - 0.5f) * 2.0f * waterHeight,
                0.0f
            );
            
            // 初始法线朝上
            normals[index] = simd_make_float3(0.0f, 0.0f, 1.0f);
            
            // 纹理坐标
            texCoords[index] = simd_make_float2(fx, fy);
        }
    }
}

- (void)generateGridIndicesForBuffer:(id<MTLBuffer>)indexBuffer 
                               width:(NSUInteger)width 
                              height:(NSUInteger)height {
    if (!indexBuffer) {
        return;
    }
    
    uint32_t *indices = (uint32_t *)[indexBuffer contents];
    NSUInteger index = 0;
    
    for (NSUInteger y = 0; y < height - 1; y++) {
        for (NSUInteger x = 0; x < width - 1; x++) {
            uint32_t topLeft = (uint32_t)(y * width + x);
            uint32_t topRight = topLeft + 1;
            uint32_t bottomLeft = (uint32_t)((y + 1) * width + x);
            uint32_t bottomRight = bottomLeft + 1;
            
            // 第一个三角形
            indices[index++] = topLeft;
            indices[index++] = bottomLeft;
            indices[index++] = topRight;
            
            // 第二个三角形
            indices[index++] = topRight;
            indices[index++] = bottomLeft;
            indices[index++] = bottomRight;
        }
    }
}

@end 